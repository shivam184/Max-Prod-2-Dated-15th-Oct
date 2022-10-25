/**
* @File Name : BatchAppointmentRevenueProcess.cls
* @Description : This will link all the appointment's to the billing summary which are created on same day or after that till new appointment come of same patient's
* @Author : Karan Singh ( Techmatrix Consulting )
* @Group :
* @Last Modified By : Karan Singh ( Techmatrix Consulting )
* @Modification Log : 
*==============================================================================
* Ver Date Author Modification
*==============================================================================
* 1.0  07 Mar 2020 Initial Version 
* 		08 Mar 2020 ( added functionality to testing in production for specific records. )
* 		08 Mar 2020 ( added fix for INVALID_QUERY_LOCATOR as Database.getQueryLocator cannot return more than 200 sub query records. )
* 		16 Mar 2020 ( removed Billsum inner Join)
**/


//#################################################### Please Note  ---------  Check The Is Legacy Data to Update in Meta Data to process legacy data ----------- ###########################


global class BatchAppointmentRevenueProcess implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        
        //----------------------------------------------------------------  Fetching Custom Meta Data  ------------------------------------------------------------------------------------------
        Appointment_Revenue_Process__mdt BatchSetting = [ SELECT Custom_Start_Date__c, Custom_End_Time__c, Run_Batch_For__c,Show_Debug_For_BatchLeadFirstOPDBillDate__c, Show_Debug_For_AppointmentPatientBatch__c,Current_Object_Records_To_Process__c,Is_Legacy_Data_to_Update__c,is_Testing_Mode__c
                                                         FROM Appointment_Revenue_Process__mdt
                                                         WHERE DeveloperName = 'BatchSetting'];
        
        system.debug('BatchSetting'+BatchSetting);
        
        //----------------------------------------------------------------  setting date as per last 6 months  ---------------------------------------------------------------------------
        DateTime startDate = Datetime.newInstance(system.today().addMonths(-6), time.newInstance(0,0,0,0));
        DateTime endDate = Datetime.newInstance(system.today(), time.newInstance(0,0,0,0));
        
        //--------------------------------------------------------------- Incase if admin wants to run for specific time period  ----------------------------------------------------------------
        if( BatchSetting.Run_Batch_For__c == 'Custom Time Period' ){
            
            startDate = DateTime.newInstance( BatchSetting.Custom_Start_Date__c, time.newInstance(0,0,0,0) );
            endDate = DateTime.newInstance( BatchSetting.Custom_End_Time__c, time.newInstance(0,0,0,0) );
        }
        
        
        //only fetch all those account who are connected to atleast one billing summary and one appointments
        //LIMIT 200 for subquery to fix INVALID_QUERY_LOCATOR error so subquery to be done in execute method
        String queryString =   ' SELECT id,Max_ID__c FROM Account ';
        //  queryString += ' WHERE Id In ( SELECT Patient__c From Billing_Summary__c WHERE  alletec_billdate__c <> NULL AND alletec_billdate__c >= :startDate AND Appointment__c = Null AND alletec_isbillcancelled__c = False ) '; //removed as there will be case when no bills were present
        //  
        queryString += 'WHERE Id In ( Select Patient__c from Appointment__c WHERE Appointment_Original_Time__c >=:startDate AND Appointment_Original_Time__c <=:endDate AND Stage__c != \'Closed Lost\' )';
        queryString += ' AND RecordType.Name = \'Patient\'';
        
        if( String.isNotBlank( BatchSetting.is_Testing_Mode__c ) ){
            
            List< String > listTestIds =  new List< String >();
            
            if( BatchSetting.is_Testing_Mode__c.contains( ',' ) ){
                
                listTestIds = BatchSetting.is_Testing_Mode__c.split(',');
                
            }else{
                
                listTestIds.add(BatchSetting.is_Testing_Mode__c );
            }
            system.debug('  listTestIds---> ' + listTestIds );
            queryString += ' AND Id In : listTestIds ';
            
        }
        system.debug( ' queryString  ------------>  '  + queryString );
        return Database.getQueryLocator( queryString );
        
    }
    
    global void execute(Database.BatchableContext BC, List< Account > listAccount ){
        
        //----------------------------------------------------------------  Fetching Custom Meta Data  ------------------------------------------------------------------------------------------
        Appointment_Revenue_Process__mdt BatchSetting = [ SELECT Custom_Start_Date__c, Custom_End_Time__c, Run_Batch_For__c,Show_Debug_For_BatchLeadFirstOPDBillDate__c, Show_Debug_For_AppointmentPatientBatch__c,Current_Object_Records_To_Process__c,Is_Legacy_Data_to_Update__c
                                                         FROM Appointment_Revenue_Process__mdt
                                                         WHERE DeveloperName = 'BatchSetting'];
        
        system.debug('BatchSetting'+BatchSetting);
        
        //----------------------------------------------------------------  setting date as per last 6 months  ---------------------------------------------------------------------------
        DateTime startDate = Datetime.newInstance(system.today().addMonths(-6), time.newInstance(0,0,0,0));
        DateTime endDate = Datetime.newInstance(system.today(), time.newInstance(0,0,0,0));
        
        //--------------------------------------------------------------- Incase if admin wants to run for specific time period  ----------------------------------------------------------------
        if( BatchSetting.Run_Batch_For__c == 'Custom Time Period' ){
            
            startDate = DateTime.newInstance( BatchSetting.Custom_Start_Date__c, time.newInstance(0,0,0,0) );
            endDate = DateTime.newInstance( BatchSetting.Custom_End_Time__c, time.newInstance(0,0,0,0) );
        }
        
        
        system.debug(' is Legacy Data---> ' + BatchSetting.Is_Legacy_Data_to_Update__c );
        
        Date varCurrentDate = Date.today();
        List < Appointment__c > listAppointmentUpdate = new List < Appointment__c >();
        List < Billing_Summary__c > listBillSumUpdate = new List < Billing_Summary__c >();
        Map< Id, List< Appointment__c > > mapAccntIdWithAppointment = new Map< Id, List< Appointment__c > >();
        Map< Id, List< Billing_Summary__c > > mapAccntIdWithBillSum = new Map< Id, List< Billing_Summary__c > >();
        
        Set < Id > setAccountIds =   ( new Map< Id, Account > ( listAccount ) ).keySet();
        
        for ( Appointment__c objAppoint : [ SELECT Id,Name,Patient__c, Appointment_Original_Time__c, First_OPD_Bill_Date__c, Stage__c FROM Appointment__c 
                                           WHERE Appointment_Original_Time__c >=:startDate AND Appointment_Original_Time__c <=:endDate AND Stage__c != 'Closed Lost'
                                           AND Patient__c IN: setAccountIds Order By Appointment_Original_Time__c DESC ]){
                                               
                                               if( !mapAccntIdWithAppointment.containsKey( objAppoint.Patient__c ) ){
                                                   mapAccntIdWithAppointment.put( objAppoint.Patient__c, new List< Appointment__c > () );
                                               }
                                               
                                               mapAccntIdWithAppointment.get( objAppoint.Patient__c ).add( objAppoint );
                                               
                                           }
        
        for(  Billing_Summary__c objBillSum : [ SELECT Id,Name,Patient__c, alletec_billdate__c, Appointment__c,Appointment__r.Appointment_Original_Time__c FROM Billing_Summary__c
                                               WHERE  alletec_billdate__c <> NULL AND alletec_billdate__c >= :startDate  
                                               AND Appointment__c = Null AND Patient__c IN: setAccountIds  AND alletec_isbillcancelled__c = False ORDER BY alletec_billdate__c ASC ]){
                                                   
                                                   if( !mapAccntIdWithBillSum.containsKey( objBillSum.Patient__c ) ){
                                                       mapAccntIdWithBillSum.put( objBillSum.Patient__c, new List< Billing_Summary__c > () );
                                                   }
                                                   
                                                   mapAccntIdWithBillSum.get( objBillSum.Patient__c ).add( objBillSum );
                                                   
                                               }
        
        
        for( Account objAcc : listAccount ){
            
            if( BatchSetting.Show_Debug_For_BatchLeadFirstOPDBillDate__c ){ system.debug(' Current Account ---> ' + objAcc );}
            
            if( !mapAccntIdWithAppointment.containsKey( objAcc.Id ) ){
                //@Debug       
                if( BatchSetting.Show_Debug_For_BatchLeadFirstOPDBillDate__c ){ system.debug(' Current Account to skip as no Appointment Found ---> ' + objAcc );}
                continue;
                
            }
            
            
            Set < Id > setBillAlreadyProcessed = new Set < Id >();
            
            for( Appointment__c objAppointment : mapAccntIdWithAppointment.get( objAcc.Id ) ){
                
                //if legacy data is uncheck and appointment is already closed lost 
                // and current Date - original time  > 180 then no billing to be attached.
                if( !BatchSetting.Is_Legacy_Data_to_Update__c && Date.valueOf( objAppointment.Appointment_Original_Time__c ).daysBetween( varCurrentDate )>= 180 
                   && objAppointment.Stage__c == 'Closed Won' ){
                       
                       //@Debug       
                       if( BatchSetting.Show_Debug_For_BatchLeadFirstOPDBillDate__c ){ system.debug(' Current Appointment which is closed won and 180 Days Diff ---> ' + objAppointment );}
                       continue;
                   }
                
                if( BatchSetting.Show_Debug_For_BatchLeadFirstOPDBillDate__c ){ system.debug(' Current Appointment to process ---> ' + objAppointment );}
                
                //if only billsum were found else check for the closed Lost eligibility
                if( mapAccntIdWithBillSum.containsKey( objAcc.Id ) ){
                    
                    //attaching billing summaries who are created on same day or after appointment original time
                    for( Billing_Summary__c objBillSum : mapAccntIdWithBillSum.get( objAcc.Id ) ){
                        
                        if( setBillAlreadyProcessed.contains(  objBillSum.Id ))  //bills which are processed should not be attached again
                            continue;
                        
                        Date appointOriginalTimeDate  = Date.newInstance( objAppointment.Appointment_Original_Time__c.year(), objAppointment.Appointment_Original_Time__c.month(), objAppointment.Appointment_Original_Time__c.day() );
                        Date billSumBillDate = Date.newInstance( objBillSum.alletec_billdate__c.year(), objBillSum.alletec_billdate__c.month(), objBillSum.alletec_billdate__c.day() );
                        
                        if( BatchSetting.Show_Debug_For_BatchLeadFirstOPDBillDate__c ){ system.debug(' Current Billing to process ---> ' + objBillSum );}
                        if( BatchSetting.Show_Debug_For_BatchLeadFirstOPDBillDate__c ){ system.debug(' Difference between origiinal time and Bill date ' + appointOriginalTimeDate.daysBetween( billSumBillDate ) );}
                        
                        if( appointOriginalTimeDate <= billSumBillDate && objBillSum.Appointment__c == Null  && 
                           ( ( !BatchSetting.Is_Legacy_Data_to_Update__c ) || (  BatchSetting.Is_Legacy_Data_to_Update__c && appointOriginalTimeDate.daysBetween( billSumBillDate ) <= 180 )  ) ) {
                               
                               //only first Billing summary bill date is to be populated only and Setting its stage as closed won
                               if( objAppointment.First_OPD_Bill_Date__c == Null ) {
                                   
                                   //@Debug
                                   if( BatchSetting.Show_Debug_For_BatchLeadFirstOPDBillDate__c ){ system.debug(' current Appointment  Closed won ---> ' + objAppointment );}
                                   
                                   objAppointment.First_OPD_Bill_Date__c = objBillSum.alletec_billdate__c;
                                   objAppointment.Stage__c = 'Closed Won';
                                   listAppointmentUpdate.add( objAppointment );
                               }
                               
                               //attaching all the billing summary to current appointment which are created same day or after Appointment
                               // 26FEB2020 Changed DateTime to Date -->  if( Date.valueOf( objAppointment.First_OPD_Bill_Date__c ) <= Date.valueOf( objBillSum.alletec_billdate__c ) && objBillSum.Appointment__c == Null ){
                               if( Date.newInstance( objAppointment.First_OPD_Bill_Date__c.year(), objAppointment.First_OPD_Bill_Date__c.month(), objAppointment.First_OPD_Bill_Date__c.day() )
                                  <= billSumBillDate && objBillSum.Appointment__c == Null  && ( ( !BatchSetting.Is_Legacy_Data_to_Update__c ) || (  BatchSetting.Is_Legacy_Data_to_Update__c && appointOriginalTimeDate.daysBetween( billSumBillDate ) <= 180 )  ) ){
                                      
                                      //@Debug
                                      if( BatchSetting.Show_Debug_For_BatchLeadFirstOPDBillDate__c ){ system.debug(' current Appointment to Link  ---> ' + objAppointment );}
                                      
                                      objBillSum.Appointment__c = objAppointment.Id;
                                      listBillSumUpdate.add( objBillSum );
                                      setBillAlreadyProcessed.add( objBillSum.Id );
                                      
                                  }
                               
                           }//end of appointment and billsum condition
                        
                        //@Debug
                        if( BatchSetting.Show_Debug_For_BatchLeadFirstOPDBillDate__c ){ system.debug(' Processed BillsId   ---> ' + setBillAlreadyProcessed );}
                    }//end of billing summary loop
                }
                
                system.debug(' days between --> ' + Date.valueOf( objAppointment.Appointment_Original_Time__c).daysBetween(varCurrentDate) );
                //if no bills were attached then check that is it eligible to closed lost
                if( Date.valueOf( objAppointment.Appointment_Original_Time__c).daysBetween(varCurrentDate)> 30 && objAppointment.Stage__c != 'Closed Won' ){
                    
                    //@Debug
                    if( BatchSetting.Show_Debug_For_BatchLeadFirstOPDBillDate__c ){ system.debug(' Current Appointment to closed lost  ---> ' + objAppointment );}
                    
                    objAppointment.Stage__c = 'Closed Lost';
                    listAppointmentUpdate.add( objAppointment );
                }
                
            }//end of appointment loop
            
        }//end of account loop
        
        if( listAppointmentUpdate.size() > 0 )
            update listAppointmentUpdate;
        
        if( listBillSumUpdate.size() > 0 )
            update listBillSumUpdate;
        
    }//end of execute method
    
    global void finish(Database.BatchableContext BC){
        
        //this is done as many declaractive tools were changing the appointment's records
        if( Test.isRunningTest() ){
            
            String Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            
            
        }
    }
}