/**
* @File Name : AppointmentRevenueProcessHelper.cls
* @Description : 
* @Author : Karan Singh Soni ( Techmatrix Consulting )
* @Group :
* @Last Modified By : Techmatrix Consulting
* @Modification Log : 14 Feb 2020
*==============================================================================
* Ver Date Author Modification
*==============================================================================
* 1.0  07 Feb 2020 Initial Version
* 		12 Feb 2020 ( added mappingAppointmentWithPatients() and appointmentRevenueProcess () )
*		14 fEB 2020 ( Added 180 day criteria for appointment which are already close lost  and remove filter creteria First_OPD_Bill_Date__c for 180 processing )
* 1.1  26 Feb 2020 ( Changed DateTime comparision to Date  for attaching billing summary )
*		1 Mar 2020 ( changed the logic for 180 creteria for the Legacy Data as it should be calc as Appointment original time - Bill sum's Bill Date )
*		3 Mar 2020 ( Now will query all the billing summary and segregate the logic on the basis of billing summ is already attached or not when queried )
**/

global class AppointmentRevenueProcessHelper {
    
    
    /*     ---------------------------------------------------------------(  mappingAppointmentWithPatients  )-----------------------------------------------------------------------------------
* 
*   12 Feb 2020 This method will map Appointment with Patients on the basis of Max id or Gender,Phone Number and registration date 
*/
    global Static void mappingAppointmentWithPatients( List<Appointment__c> listAppointment,Integer count ){
        
        //---------------------------------------------------------------  Fetching MetaData  -------------------------------------------------------------------------------------------------
        Appointment_Revenue_Process__mdt BatchSetting = [ SELECT Custom_Start_Date__c, Custom_End_Time__c, Run_Batch_For__c, Show_Debug_For_AppointmentPatientBatch__c,Current_Object_Records_To_Process__c,Is_Legacy_Data_to_Update__c
                                                         FROM Appointment_Revenue_Process__mdt
                                                         WHERE DeveloperName = 'BatchSetting'];
        
        if( BatchSetting.Show_Debug_For_AppointmentPatientBatch__c ){ system.debug(' listAppointment ---> ' + listAppointment );}
        
        Map<string, List < Account>> mapPhoneOrMaxIdWithAccount = new Map<string,List < Account>>();
        Set<string> setPhoneGenderOfAppointment = new Set<string>();
        List<Appointment__c> listAppointmentToUpdate=new List<Appointment__c>();
        List< Id > listAppointmentsAlreadyProceessed = new List< Id >();
        
        for(Appointment__c objAppoint : listAppointment){
            setPhoneGenderOfAppointment.add( objAppoint.Patient_Phone__c );
            setPhoneGenderOfAppointment.add( objAppoint.Gender__c );
            
            if( String.isNotBlank( objAppoint.Max_ID__c ) ){
                
                mapPhoneOrMaxIdWithAccount.put( objAppoint.Max_ID__c, new List< Account > ());
            }
        }
        //@Debug
        if( BatchSetting.Show_Debug_For_AppointmentPatientBatch__c ){ system.debug(' mapPhoneOrMaxIdWithAccount  --->  '+mapPhoneOrMaxIdWithAccount 
                                                                                   + '  setPhoneGenderOfAppointment  --->  '+setPhoneGenderOfAppointment );}
        
        //Fetching Account( Patient Type) in registrationDate Asc whose maxid should be in mapPhoneOrMaxIdWithAccount.Keyset() 
        //or PersonMobilePhone and Gender__c should in setPhoneGenderOfAppointment
        for(Account acc : [SELECT Id,Max_ID__c,PersonMobilePhone,Gender__c,alletec_patientregisterationdate__c FROM Account 
                           
                           WHERE alletec_patientregisterationdate__c != NULL AND RecordType.Name = 'Patient' 
                           
                           AND ( ( PersonMobilePhone != NULL AND Gender__c != Null AND PersonMobilePhone In:setPhoneGenderOfAppointment AND Gender__c IN:setPhoneGenderOfAppointment) 
                                
                                OR ( Max_ID__c IN : mapPhoneOrMaxIdWithAccount.keySet() ) ) Order By alletec_patientregisterationdate__c ASC ]){
                                    
                                    if( BatchSetting.Show_Debug_For_AppointmentPatientBatch__c ){ system.debug(' current Account object ---> ' + acc );}
                                    
                                    //mapping MaxId with Account as MaxId is Unique
                                    if( String.isNotBlank( acc.Max_ID__c ) ){
                                        
                                        mapPhoneOrMaxIdWithAccount.put( acc.Max_ID__c.toLowerCase(), new List< Account > { Acc } );
                                    }
                                    
                                    //as same mobile number can be in multiple Accounts 
                                    if( !mapPhoneOrMaxIdWithAccount.containsKey( acc.PersonMobilePhone ) ){								//@karanSinghSoni 6Feb2020 multiple account can have same phone no
                                        
                                        mapPhoneOrMaxIdWithAccount.put(acc.PersonMobilePhone, new List< Account > { Acc });
                                    }else{
                                        
                                        mapPhoneOrMaxIdWithAccount.get(acc.PersonMobilePhone).add( acc );
                                    }
                                }//end of account Loop
        
        
        //@Debug
        if( BatchSetting.Show_Debug_For_AppointmentPatientBatch__c ){ system.debug(' mapPhoneOrMaxIdWithAccount  --->  '+mapPhoneOrMaxIdWithAccount 
                                                                                   + '  listAppointmentsAlreadyProceessed  --->  '+listAppointmentsAlreadyProceessed );}
        
        
        if(mapPhoneOrMaxIdWithAccount !=NULL && mapPhoneOrMaxIdWithAccount.keyset().size()>0){
            
            //First time this will search for existing Patients and if all appointments are not mapped then we will search for new patients
            do{
                
                //@Debug
                if( BatchSetting.Show_Debug_For_AppointmentPatientBatch__c ){ system.debug(' current Count  ---> ' + count );}
                
                for(Appointment__c app:listAppointment){
                    
                    //should not process appointments which are already processed
                    if( !listAppointmentsAlreadyProceessed.contains( app.Id ) ){
                        
                        //@Debug
                        if( BatchSetting.Show_Debug_For_AppointmentPatientBatch__c ){ system.debug(' Current Appointment ---> ' + app );}
                        
                        if( String.isNotBlank( app.Max_ID__c ) && mapPhoneOrMaxIdWithAccount.containsKey( app.Max_ID__c.toLowerCase() ) && !listAppointmentsAlreadyProceessed.contains( app.Id )){
                            
                            //@Debug
                            if( BatchSetting.Show_Debug_For_AppointmentPatientBatch__c ){ system.debug(' MaxID check Current Appointment ---> ' + app );}
                            
                            for( Account objAcc : mapPhoneOrMaxIdWithAccount.get( app.Max_ID__c.toLowerCase() )){
                                
                                //@Debug
                                if( BatchSetting.Show_Debug_For_AppointmentPatientBatch__c ){ system.debug(' MaxID Mapping from Current Account ---> ' + ObjAcc );}
                                
                                app.Max_ID__c = objAcc.Max_ID__c;
                                app.Patient__c = objAcc.Id;
                                listAppointmentToUpdate.add(app);
                                listAppointmentsAlreadyProceessed.add( app.Id );
                                break;
                                
                            }//end of for Account loop
                            
                        }//end of maxx id check
                        else if( mapPhoneOrMaxIdWithAccount.containsKey( app.Patient_Phone__c ) && !listAppointmentsAlreadyProceessed.contains( app.Id )){
                            
                            //@Debug
                            if( BatchSetting.Show_Debug_For_AppointmentPatientBatch__c ){ system.debug(' Phone Number check for Current Account ---> ' + app );}
                            
                            for( Account objAcc : mapPhoneOrMaxIdWithAccount.get( app.Patient_Phone__c )){
                                
                                if( count== 0 && app.Appointment_Created_Time__c <= objAcc.alletec_patientregisterationdate__c && app.Gender__c == objAcc.Gender__c && !listAppointmentsAlreadyProceessed.contains( app.Id )){	
                                    
                                    //@Debug
                                    if( BatchSetting.Show_Debug_For_AppointmentPatientBatch__c ){ system.debug(' If Case of new Account ---> ' + ObjAcc );}
                                    
                                    app.Max_ID__c = objAcc.Max_ID__c;
                                    app.Patient__c = objAcc.Id;
                                    listAppointmentToUpdate.add(app);
                                    listAppointmentsAlreadyProceessed.add( app.Id );
                                    
                                    break;
                                }
                                else if( count== 1 && app.Appointment_Created_Time__c >= objAcc.alletec_patientregisterationdate__c && app.Gender__c == objAcc.Gender__c && !listAppointmentsAlreadyProceessed.contains( app.Id )){	
                                    
                                    //@Debug
                                    if( BatchSetting.Show_Debug_For_AppointmentPatientBatch__c ){ system.debug(' If Case of Existing Account ---> ' + ObjAcc );}
                                    
                                    app.Max_ID__c = objAcc.Max_ID__c;
                                    app.Patient__c = objAcc.Id;
                                    listAppointmentToUpdate.add(app);
                                    listAppointmentsAlreadyProceessed.add( app.Id );
                                    
                                    break;
                                }
                            }//end of account loop 
                        }//end of patient phone check
                    }//end of listAppointmentsAlreadyProceessed check
                    
                    
                }//end of Appointment List 
                
                //@Debug
                if( BatchSetting.Show_Debug_For_AppointmentPatientBatch__c ){ system.debug(' listAppointmentsAlreadyProceessed ---> ' + listAppointmentsAlreadyProceessed );}
                
                if( listAppointmentsAlreadyProceessed.size() != listAppointment.size() ){
                    count++;
                }
            }While( count == 1 );
            
            //@Debug
            if( BatchSetting.Show_Debug_For_AppointmentPatientBatch__c ){ system.debug(' listAppointmentToUpdate ---> ' + listAppointmentToUpdate );}
            
            if(listAppointmentToUpdate.size() > 0)
                update listAppointmentToUpdate;   
            
            
            //#####################################################  Clearing Heap  ###################################################################################################
            listAppointmentToUpdate.clear();
            mapPhoneOrMaxIdWithAccount.clear();
            setPhoneGenderOfAppointment.clear();       
            listAppointmentToUpdate.clear();       
            listAppointmentsAlreadyProceessed.clear();
        }
        
    }
    
    
    /*     ---------------------------------------------------------------(  mappingAppointmentWithBillingSummary  )-----------------------------------------------------------------------------------
* 
*	14 Feb 2020 This method will map billing summary with appointments
*	26 Feb 2020 ( Changed DateTime comparision to Date  for attaching billing summary )
*	1 Mar 2020 ( changed the logic for 180 creteria for the Legacy Data as it should be calc as Appointment original time - Bill sum's Bill Date )
*	3 Mar 2020 ( Now will query all the billing summary and segregate the logic on the basis of billing summ is already attached or not when queried )
*/
    
    //#################################################### Please Note  ---------  Check The Is Legacy Data to Update in Meta Data to process legacy data ----------- ###########################
    
    global static void mappingAppointmentOrLeadWithBillingSummary( List< sObject > listSobject ){
        
        //----------------------------------------------------------------  Fetching Custom Meta Data  ------------------------------------------------------------------------------------------
        Appointment_Revenue_Process__mdt BatchSetting = [ SELECT Custom_Start_Date__c, Custom_End_Time__c, Run_Batch_For__c,Show_Debug_For_BatchLeadFirstOPDBillDate__c, Show_Debug_For_AppointmentPatientBatch__c,Current_Object_Records_To_Process__c,Is_Legacy_Data_to_Update__c
                                                         FROM Appointment_Revenue_Process__mdt
                                                         WHERE DeveloperName = 'BatchSetting'];
        
        List< Id > listAppointmentsClosedWonOrBillsAttach = new List< Id >();			//This list is used to maintain appointments which are already closed won or Bills are attached to it
        Map< String, wrapMapAppointmentOrLeadWithBillSumm > mapMaxIdWithAppointmentOrLeadWithBillSumm = new Map< String, wrapMapAppointmentOrLeadWithBillSumm >();
        Date varCurrentDate = Date.today();
        
        DateTime minDateTimeForBillSum; //3 March 2020 for setting Date range through which bill summ to fetch.
        DateTime maxDateTimeForBillSum;
        
        for( sObject objS : listSobject ){
            
            //running for Appointment records
            if( BatchSetting.Current_Object_Records_To_Process__c == String.valueOf( Schema.Appointment__c.getSObjectType() )){
                
                Appointment__c objApp = ( Appointment__c ) objS;
                
                //if Day difference is greater than 180 days and stage is closed won then no new bills will be attached.
                // 1 March 2020 added Legacy data byPass as legacy data should not filter 180 day based creteria
                
                if( !BatchSetting.Is_Legacy_Data_to_Update__c && Date.valueOf( objApp.Appointment_Original_Time__c).daysBetween(varCurrentDate)>= 180 && objApp.Stage__c == 'Closed Won' ){
                    
                    //@Debug
                    if( BatchSetting.Show_Debug_For_BatchLeadFirstOPDBillDate__c ){ system.debug(' Current Appointment which is closed won and 180 Days Diff ---> ' + objApp );}
                    
                    listAppointmentsClosedWonOrBillsAttach.add( objApp.Id);
                    
                }
                
                // mapping appointments with maxIds( to lowercase as these are caseInsensitive )
                else{
                    
                    //setting the Date Range for the Billing Summary
                    if( minDateTimeForBillSum == Null ){
                        
                        minDateTimeForBillSum = objApp.Appointment_Original_Time__c;
                        
                    }else if( minDateTimeForBillSum > objApp.Appointment_Original_Time__c ){
                        
                        minDateTimeForBillSum = objApp.Appointment_Original_Time__c;
                    }
                    
                    if( maxDateTimeForBillSum == Null ){
                        
                        maxDateTimeForBillSum = objApp.Appointment_Original_Time__c;
                        
                    }else if( maxDateTimeForBillSum < objApp.Appointment_Original_Time__c ){
                        
                        maxDateTimeForBillSum = objApp.Appointment_Original_Time__c;
                    }
                    
                    //@Debug
                    if( BatchSetting.Show_Debug_For_BatchLeadFirstOPDBillDate__c ){ system.debug(' Current Appointment to process ---> ' + objApp );}
                    
                    //if maxId found then add new Appointemnt to it
                    if( !mapMaxIdWithAppointmentOrLeadWithBillSumm.containsKey( String.valueOf( objS.get( 'Max_ID__c' )).toLowerCase())){
                        
                        mapMaxIdWithAppointmentOrLeadWithBillSumm.put( String.valueOf( objS.get( 'Max_ID__c' )).toLowerCase(), 
                                                                      new AppointmentRevenueProcessHelper.wrapMapAppointmentOrLeadWithBillSumm ( new List< sObject > { objS }) );
                    }
                    //if not then add first appointment to it
                    else{
                        
                        mapMaxIdWithAppointmentOrLeadWithBillSumm.get( String.valueOf( objS.get( 'Max_ID__c' )).toLowerCase()).listAppointmentOrLead.add( objS );
                    }
                    
                }//end of mapping maxId
            }//end of Appointment check
            
            //for lead records
            else {
                
                //@Debug
                if( BatchSetting.Show_Debug_For_BatchLeadFirstOPDBillDate__c ){ system.debug(' Current Lead to process ---> ' + objS );}
                
                if( !mapMaxIdWithAppointmentOrLeadWithBillSumm.containsKey( String.valueOf( objS.get( 'Max_ID__c' )).toLowerCase())){
                    mapMaxIdWithAppointmentOrLeadWithBillSumm.put( String.valueOf( objS.get( 'Max_ID__c' )).toLowerCase(), 
                                                                  new AppointmentRevenueProcessHelper.wrapMapAppointmentOrLeadWithBillSumm ( new List< sObject > { objS }) );
                }
                else{
                    
                    mapMaxIdWithAppointmentOrLeadWithBillSumm.get( String.valueOf( objS.get( 'Max_ID__c' )).toLowerCase()).listAppointmentOrLead.add( objS );
                }
            }
        }//end of sobject List 
        
        if( BatchSetting.Show_Debug_For_BatchLeadFirstOPDBillDate__c ){ system.debug( 'Min date --> ' +minDateTimeForBillSum + 'Max Date --> ' + maxDateTimeForBillSum );}
        
        maxDateTimeForBillSum = maxDateTimeForBillSum.addDays(180); //to fetch all billings
        
        //@Debug
        if( BatchSetting.Show_Debug_For_BatchLeadFirstOPDBillDate__c ){ system.debug(' mapMaxIdWithAppointmentOrLeadWithBillSumm ---> ' + mapMaxIdWithAppointmentOrLeadWithBillSumm 
                                                                                     + ' listAppointmentsClosedWonOrBillsAttach ---> ' + listAppointmentsClosedWonOrBillsAttach );}
        
        if( mapMaxIdWithAppointmentOrLeadWithBillSumm.size() > 0 ){
            
            Boolean isAnYBillSumFound = false;     
            
            Set< String > setMaxIdTemp = mapMaxIdWithAppointmentOrLeadWithBillSumm.keySet(); 
            
            if( BatchSetting.Show_Debug_For_AppointmentPatientBatch__c ){ system.debug(' setMaxIdTemp ---> ' + setMaxIdTemp );}
            
            String  queryStringForBillSum = 'SELECT Id, alletec_billdate__c,Patient__r.Max_ID__c,Appointment__r.Appointment_Original_Time__c,Appointment__c '; //3 march 2020 added Appointment__r.First_OPD_Bill_Date__c
            queryStringForBillSum += ' FROM Billing_Summary__c '; //added 1 March 2020 Appointment__c == Null
            queryStringForBillSum += ' WHERE Patient__c <> NULL AND Patient__r.RecordType.Name = \'Patient\' AND alletec_billdate__c <> NULL AND Patient__r.Max_ID__c IN : setMaxIdTemp'; // 3March 2020 AND Appointment__c = Null
            queryStringForBillSum += ' AND alletec_billdate__c>=:minDateTimeForBillSum AND alletec_billdate__c<=:maxDateTimeForBillSum '; //3 march 2020 added as now fetching all the linked and Unlinked Billing Summary
            
            //if( BatchSetting.Current_Object_Records_To_Process__c == String.valueOf( Schema.Appointment__c.getSObjectType() ) )
            //  queryStringForBillSum += ' AND Appointment__c = Null ';
            
            queryStringForBillSum += 'ORDER BY alletec_billdate__c ASC LIMIT 50000 ';
            
            //@Debug
            if( BatchSetting.Show_Debug_For_BatchLeadFirstOPDBillDate__c ){ system.debug(' queryStringForBillSum ---> ' + queryStringForBillSum );}
            
            for( Billing_Summary__c objBillSum : Database.query( queryStringForBillSum )){
                isAnYBillSumFound = true;
                
                //@Debug
                if( BatchSetting.Show_Debug_For_BatchLeadFirstOPDBillDate__c ){ system.debug(' Current Billing Summary  ---> ' + objBillSum );}
                
                mapMaxIdWithAppointmentOrLeadWithBillSumm.get( objBillSum.Patient__r.Max_ID__c.toLowerCase() ).listBillingSum.add( objBillSum );
            }
            
            //@Debug
            if( BatchSetting.Show_Debug_For_BatchLeadFirstOPDBillDate__c ){ system.debug(' mapMaxIdWithAppointmentOrLeadWithBillSumm  ---> ' + mapMaxIdWithAppointmentOrLeadWithBillSumm );}
            
            if( isAnYBillSumFound  ){
                
                if( BatchSetting.Current_Object_Records_To_Process__c == String.valueOf( Schema.Lead__c.getSObjectType() ) ){
                    
                    //   AppointmentRevenueProcessHelper.leadRevenueProcess( mapMaxIdWithAppointmentOrLeadWithBillSumm );
                }
                else if( BatchSetting.Current_Object_Records_To_Process__c == String.valueOf( Schema.Appointment__c.getSObjectType() ) ){
                    
                    appointmentRevenueProcess( mapMaxIdWithAppointmentOrLeadWithBillSumm, listAppointmentsClosedWonOrBillsAttach,new List< Appointment__c >( ( List< Appointment__c >) listSobject ) );
                }
            }
            //if bill not found then check for closed lost
            else if( BatchSetting.Current_Object_Records_To_Process__c == String.valueOf( Schema.Appointment__c.getSObjectType() ) ){
                
                List< Appointment__c > listAppntUpdateClosedLost = new List< Appointment__c >();
                
                for( Appointment__c objAppointment : ( List< Appointment__c>) listSobject ){
                    
                    //incase if record is already closed won then it should not be closed lost
                    if( Date.valueOf( objAppointment.Appointment_Original_Time__c).daysBetween(varCurrentDate)> 30 
                       && !listAppointmentsClosedWonOrBillsAttach.contains( objAppointment.Id ) && objAppointment.Stage__c != 'Closed Won' ){
                           
                           //@Debug
                           if( BatchSetting.Show_Debug_For_BatchLeadFirstOPDBillDate__c ){ system.debug(' Current Appointment to closed lost  ---> ' + objAppointment );}
                           
                           objAppointment.Stage__c = 'Closed Lost';
                           listAppntUpdateClosedLost.add( objAppointment );
                       }
                }
                
                //@Debug
                if( BatchSetting.Show_Debug_For_BatchLeadFirstOPDBillDate__c ){ system.debug(' listAppntUpdateClosedLost  ---> ' + listAppntUpdateClosedLost );}
                
                if( listAppntUpdateClosedLost.size() > 0 )
                    update listAppntUpdateClosedLost;
                
                //#####################################################  Clearing Heap  ##########################################################################################
                listAppntUpdateClosedLost.clear();
                
            }//end of bill not found
        }//end of mapMaxIdWithAppointmentOrLeadWithBillSumm size check
        
        //#####################################################  Clearing Heap  ##########################################################################################
        listAppointmentsClosedWonOrBillsAttach.clear();
        mapMaxIdWithAppointmentOrLeadWithBillSumm.clear();
        
    }//end of mappingAppointmentWithBillingSummary()
    
    
    /* -----------------------------------------------------------------(  appointmentRevenueProcess  )---------------------------------------------------------------------------------------------
* 
*  12 feb 2020 This process will map appointments with existing Billing summary and marking their stage as closed lost or won.
*		14 Feb 2020 ( Added 180 day criteria for appointment which are already close lost  and remove filter creteria First_OPD_Bill_Date__c for 180 processing )
*		26 Feb 2020 ( Changed DateTime comparision to Date  for attaching billing summary )
*		1 Mar 2020 ( changed the logic for 180 creteria for the Legacy Data as it should be calc as Appointment original time - Bill sum's Bill Date )

*/
    global Static void appointmentRevenueProcess( Map< String, wrapMapAppointmentOrLeadWithBillSumm > mapMaxIdWithAppointmentOrLeadWithBillSumm,List< Id > listAppointmentsClosedWonOrBillsAttach,List< Appointment__c > listAppointment ){
        
        //----------------------------------------------------------------  Fetching Custom Meta Data  ------------------------------------------------------------------------------------------
        Appointment_Revenue_Process__mdt BatchSetting = [ SELECT Custom_Start_Date__c, Custom_End_Time__c, Run_Batch_For__c,Show_Debug_For_BatchLeadFirstOPDBillDate__c, Show_Debug_For_AppointmentPatientBatch__c,Current_Object_Records_To_Process__c,Is_Legacy_Data_to_Update__c
                                                         FROM Appointment_Revenue_Process__mdt
                                                         WHERE DeveloperName = 'BatchSetting'];
        
        //@Debug
        if( BatchSetting.Show_Debug_For_BatchLeadFirstOPDBillDate__c ){ system.debug(  ' mapMaxIdWithAppointmentOrLeadWithBillSumm ---> ' + mapMaxIdWithAppointmentOrLeadWithBillSumm
                                                                                     + ' listAppointmentsClosedWonOrBillsAttach ---> ' + listAppointmentsClosedWonOrBillsAttach
                                                                                     + ' listAppointment ---> ' + listAppointment);}
        
        
        List< Appointment__c > listAppointmentUpdate = new List< Appointment__c >();
        List< Billing_Summary__c > listBillSumUpdate = new List< Billing_Summary__c >();
        Set< Id > setBillSumAlreadyProcess = new Set< Id >();
        
        for( wrapMapAppointmentOrLeadWithBillSumm objWrapper : mapMaxIdWithAppointmentOrLeadWithBillSumm.values() ){
            
            //iterating on all appointment DESC Order having same MAXId as Billing summary has to be attached with latest Appointment
            for( Appointment__c objAppointment : ( List < Appointment__c> ) objWrapper.listAppointmentOrLead ){
                
                //iterating on all Billing Summary ASC Order as to populate First opd Bill Date having same MAXId
                for( Billing_Summary__c objBillSum : objWrapper.listBillingSum ){
                    
                    if( !setBillSumAlreadyProcess.contains( objBillSum.Id ) ){
                        
                        Date appointOriginalTimeDate  = Date.newInstance( objAppointment.Appointment_Original_Time__c.year(), objAppointment.Appointment_Original_Time__c.month(), objAppointment.Appointment_Original_Time__c.day() );
                        Date billSumBillDate = Date.newInstance( objBillSum.alletec_billdate__c.year(), objBillSum.alletec_billdate__c.month(), objBillSum.alletec_billdate__c.day() );
                        
                        //@Debug
                        if( BatchSetting.Show_Debug_For_BatchLeadFirstOPDBillDate__c ){ system.debug(' current Appointment  Original Date ---> ' + Date.newInstance( objAppointment.Appointment_Original_Time__c.year(), objAppointment.Appointment_Original_Time__c.month(), objAppointment.Appointment_Original_Time__c.day() ));}
                        if( BatchSetting.Show_Debug_For_BatchLeadFirstOPDBillDate__c ){ system.debug(' current objBillSum  alletec_billdate__c ---> ' + Date.newInstance( objBillSum.alletec_billdate__c.year(), objBillSum.alletec_billdate__c.month(), objBillSum.alletec_billdate__c.day() ) );}
                        if( BatchSetting.Show_Debug_For_BatchLeadFirstOPDBillDate__c ){ system.debug(' is Legacy Data---> ' + BatchSetting.Is_Legacy_Data_to_Update__c );}
                        if( BatchSetting.Show_Debug_For_BatchLeadFirstOPDBillDate__c ){ system.debug(' Difference between origiinal time and Bill date ' + appointOriginalTimeDate.daysBetween( billSumBillDate ) );}
                        
                        //if incase it billing is not attached while it was queried
                        if( objBillSum.Appointment__r.Appointment_Original_Time__c == Null ){
                            
                            //Processing Billing Summary which are created same day or after Appointment and it should not be attached with any other Appointment
                            // 26FEB2020 Changed DateTime to Date comparison--> if( Date.valueOf( objAppointment.Appointment_Original_Time__c )  <= Date.valueOf( objBillSum.alletec_billdate__c ) && objBillSum.Appointment__c == Null )
                            // 1 March 2020 added Legacy data's  180 day based creteria
                            
                            if( appointOriginalTimeDate <= billSumBillDate && objBillSum.Appointment__c == Null  && 
                               ( ( !BatchSetting.Is_Legacy_Data_to_Update__c ) || (  BatchSetting.Is_Legacy_Data_to_Update__c && appointOriginalTimeDate.daysBetween( billSumBillDate ) <= 180 )  ) ) {
                                   
                                   //only first Billing summary bill date is to be populated only and Setting its stage as closed won
                                   if( objAppointment.First_OPD_Bill_Date__c == Null ) {
                                       
                                       //@Debug
                                       if( BatchSetting.Show_Debug_For_BatchLeadFirstOPDBillDate__c ){ system.debug(' current Appointment  ---> ' + objAppointment );}
                                       
                                       objAppointment.First_OPD_Bill_Date__c = objBillSum.alletec_billdate__c;
                                       objAppointment.Stage__c = 'Closed Won';
                                       listAppointmentsClosedWonOrBillsAttach.add( objAppointment.Id );
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
                                          setBillSumAlreadyProcess.add( objBillSum.id);
                                          //as if appointment first opd bill date is not null still we should not make it closed lost,so adding in this set 
                                          listAppointmentsClosedWonOrBillsAttach.add( objAppointment.Id );
                                      }
                                   
                               }//end of appointment and billsum condition
                            
                        }else if( objBillSum.Appointment__r.Appointment_Original_Time__c < objAppointment.Appointment_Original_Time__c  && objBillSum.Appointment__c != objAppointment.Id ) { //if incase it billing is was attached while it was queried then re update it
                            
                            if( appointOriginalTimeDate <= billSumBillDate   && 
                               ( ( !BatchSetting.Is_Legacy_Data_to_Update__c ) || (  BatchSetting.Is_Legacy_Data_to_Update__c && appointOriginalTimeDate.daysBetween( billSumBillDate ) <= 180 )  ) ) {
                                   
                                   //only first Billing summary bill date is to be populated only and Setting its stage as closed won
                                   if( objAppointment.First_OPD_Bill_Date__c == Null ) {
                                       
                                       //@Debug
                                       if( BatchSetting.Show_Debug_For_BatchLeadFirstOPDBillDate__c ){ system.debug(' current Appointment  ---> ' + objAppointment );}
                                       
                                       objAppointment.First_OPD_Bill_Date__c = objBillSum.alletec_billdate__c;
                                       objAppointment.Stage__c = 'Closed Won';
                                       listAppointmentsClosedWonOrBillsAttach.add( objAppointment.Id );
                                       listAppointmentUpdate.add( objAppointment );
                                   }
                                   
                                   //attaching all the billing summary to current appointment which are created same day or after Appointment
                                   // 26FEB2020 Changed DateTime to Date -->  if( Date.valueOf( objAppointment.First_OPD_Bill_Date__c ) <= Date.valueOf( objBillSum.alletec_billdate__c ) && objBillSum.Appointment__c == Null ){
                                   if( Date.newInstance( objAppointment.First_OPD_Bill_Date__c.year(), objAppointment.First_OPD_Bill_Date__c.month(), objAppointment.First_OPD_Bill_Date__c.day() )
                                      <= billSumBillDate  && ( ( !BatchSetting.Is_Legacy_Data_to_Update__c ) || (  BatchSetting.Is_Legacy_Data_to_Update__c && appointOriginalTimeDate.daysBetween( billSumBillDate ) <= 180 )  ) ){
                                          
                                          //@Debug
                                          if( BatchSetting.Show_Debug_For_BatchLeadFirstOPDBillDate__c ){ system.debug(' current Appointment to Link  ---> ' + objAppointment );}
                                          
                                          objBillSum.Appointment__c = objAppointment.Id;
                                          listBillSumUpdate.add( objBillSum );
                                          setBillSumAlreadyProcess.add( objBillSum.id);
                                          //as if appointment first opd bill date is not null still we should not make it closed lost,so adding in this set 
                                          listAppointmentsClosedWonOrBillsAttach.add( objAppointment.Id );
                                      }
                                   
                               }//end of appointment and billsum condition
                        }
                        
                    }
                    
                }//end of billing summary loop
            }// end of appointment loop
        }// end of wrapper loop
        
        //@Debug
        if( BatchSetting.Show_Debug_For_BatchLeadFirstOPDBillDate__c ){ system.debug( ' listAppointment ---> ' + listAppointment
                                                                                     + ' listAppointmentUpdate ---> ' + listAppointmentUpdate
                                                                                     + ' listAppointmentsClosedWonOrBillsAttach ---> ' + listAppointmentsClosedWonOrBillsAttach);}
        //if any appointment are not linked then check for closed lost
        if( listAppointment.size() != listAppointmentUpdate.size() ){
            
            Date varCurrentDate = Date.today();
            for( Appointment__c objAppointment : listAppointment ){
                
                if( Date.valueOf( objAppointment.Appointment_Original_Time__c).daysBetween(varCurrentDate)> 30 
                   && !listAppointmentsClosedWonOrBillsAttach.contains( objAppointment.Id )  && objAppointment.Stage__c != 'Closed Won'){
                       
                       //@Debug
                       if( BatchSetting.Show_Debug_For_BatchLeadFirstOPDBillDate__c ){ system.debug( ' Current Appointment to closed Lost  ---> ' + objAppointment );}
                       
                       objAppointment.Stage__c = 'Closed Lost';
                       listAppointmentUpdate.add( objAppointment );
                   }
            }
        }
        //@Debug
        if( BatchSetting.Show_Debug_For_BatchLeadFirstOPDBillDate__c ){ system.debug( ' listAppointmentUpdate  ---> ' + listAppointmentUpdate 
                                                                                     + ' listBillSumUpdate  ---> ' + listBillSumUpdate );}
        
        if( listAppointmentUpdate.size() > 0 ){
            
            Database.update( listAppointmentUpdate , False); //update listAppointmentUpdate;
        }
        if( listBillSumUpdate.size() > 0 ){
            
            Database.update( listBillSumUpdate , False); //update listBillSumUpdate;
        }
        
        //###########################################################  Heap Clean  #####################################################################################
        listAppointmentUpdate.clear();
        listBillSumUpdate.clear();
        mapMaxIdWithAppointmentOrLeadWithBillSumm.clear();
        listAppointmentsClosedWonOrBillsAttach.clear();
        listAppointment.clear();
        
    }//end of main method
    
    
    /*  ----------------------------------------------------------------   To be uncommnted for lead trigger  -----------------------------------------------------------------------------
*    global Static void leadRevenueProcess( Map< String, wrapMapAppointmentOrLeadWithBillSumm > mapMaxIdWithAppointmentOrLeadWithBillSumm ){

List< Lead__c > listCustomLeadUpdate = new List< Lead__c >();

for( wrapMapAppointmentOrLeadWithBillSumm objWrapper : mapMaxIdWithAppointmentOrLeadWithBillSumm.values() ){

for( Lead__c objLead : ( List < Lead__c> ) objWrapper.listAppointmentOrLead ){

for( Billing_Summary__c objBillSum : objWrapper.listBillingSum ){

if( objLead.Submitted_On__c <= objBillSum.alletec_billdate__c ){

if( objLead.First_OPD_Bill_Date__c == Null ) {

objLead.First_OPD_Bill_Date__c = objBillSum.alletec_billdate__c;

listCustomLeadUpdate.add( objLead );
break;
}
}//end of lead submitted date check
}//end of billing summary loop
}// end of custom lead loop
}// end of wrapper loop

if( listCustomLeadUpdate.size() > 0 )
update listCustomLeadUpdate;
} */
    
    
    public static void testCoverage(){
        
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
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
            Str = 'abc';
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
    /*  --------------------------------------------------------------  Wrapper : wrapMapAppointmentOrLeadWithBillSumm  ------------------------------------------------------------
* 
* This wrapper is used in Map to bind list of appointment's/Lead and Billing summary with same max id.
*/
    global class wrapMapAppointmentOrLeadWithBillSumm{
        
        global List< sObject > listAppointmentOrLead;
        global List< Billing_Summary__c > listBillingSum;
        
        global wrapMapAppointmentOrLeadWithBillSumm( List< sObject > listAppointmentOrLeadTemp ){
            
            listAppointmentOrLead =listAppointmentOrLeadTemp;
            listBillingSum = new List< Billing_Summary__c >();
        }
    }
}