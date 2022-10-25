/**
* @File Name : BatchLeadFirstOPDBillDateUpdate.cls
* @Description : To update First OPD Bill Date in lead from the account whose max id is same as Lead max id and having billing summary which is just greater than lead's submitted on date.
* @Author : Karan Singh Soni
* @Group :
* @Last Modified By : Karan Singh Soni
* @Modification Log :
*==============================================================================
* Ver Date Author Modification
*==============================================================================
* 1.0  23 Jan 2019 Initial Version
**/
global class BatchLeadFirstOPDBillDateUpdate implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        
        //----------------------------------------------------------------  setting date as per last 6 months  ---------------------------------------------------------------------------
        DateTime startDate = Datetime.newInstance(system.today().addMonths(-6), time.newInstance(0,0,0,0));
        DateTime endDate = Datetime.newInstance(system.today(), time.newInstance(0,0,0,0));
        
        //---------------------------------------------------  Uncomment this if you want to run batch for specific time period  -----------------------------------------------------------
        if( String.isNotBlank( Label.BatchLeadFirstOPDBillDateUpdate_Start_Date ) &&  Label.BatchLeadFirstOPDBillDateUpdate_Start_Date.countMatches('-') == 2 ){
            //2019-01-01
            startDate = DateTime.newInstance( Integer.valueOf( Label.BatchLeadFirstOPDBillDateUpdate_Start_Date.split('-')[0] ) , 
                                             Integer.valueOf( Label.BatchLeadFirstOPDBillDateUpdate_Start_Date.split('-')[1] ) ,
                                             Integer.valueOf( Label.BatchLeadFirstOPDBillDateUpdate_Start_Date.split('-')[2] ) );
        }
        if( String.isNotBlank( Label.BatchLeadFirstOPDBillDateUpdate_End_Date ) &&  Label.BatchLeadFirstOPDBillDateUpdate_End_Date.countMatches('-') == 2 ){
            //2019-12-30
            endDate = DateTime.newInstance( Integer.valueOf( Label.BatchLeadFirstOPDBillDateUpdate_End_Date.split('-')[0] ) , 
                                           Integer.valueOf( Label.BatchLeadFirstOPDBillDateUpdate_End_Date.split('-')[1] ) ,
                                           Integer.valueOf( Label.BatchLeadFirstOPDBillDateUpdate_End_Date.split('-')[2] ) );
        }
        
        String query = 'SELECT Id,Max_ID__c,Submitted_On__c,First_OPD_Bill_Date__c FROM Lead__c WHERE RecordType.Name = \'Digital Customer Acquisition\' AND Stage__c=\'OPD Consult Taken\' AND Max_ID__c  != NULL AND Submitted_On__c>=:startDate AND Submitted_On__c<=:endDate AND First_OPD_Bill_Date__c = NULL';
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Lead__c> listLead ){
        
        //----------------------------------------------------  use to map Max id with Lead's submitted date and Account's billing summary date  --------------------------------------------
        Map< String, WrapLeadSubmitDateWithBilldate > mapMaxIdWithWrapSubmit_BillDate = new Map< String, WrapLeadSubmitDateWithBilldate >();
        List< Lead__c > listCustomLead = new List< Lead__c >();
        
        for( Lead__c objLead : listLead ){
            
            if( Boolean.valueOf( Label.showDebugForBatchLeadFirstOPDBillDateUpdate ) ) { System.debug( 'objLead' + objLead );}
            
            mapMaxIdWithWrapSubmit_BillDate.put( objLead.Max_ID__c.toLowerCase(), new WrapLeadSubmitDateWithBilldate( objLead.Submitted_On__c ) );
        }
        
        if( Boolean.valueOf( Label.showDebugForBatchLeadFirstOPDBillDateUpdate ) ) { System.debug( 'mapMaxIdWithWrapSubmit_BillDate' + mapMaxIdWithWrapSubmit_BillDate );}
        
        //------------------------------------------------  didnt use account id lookup //Digital_Lead__c = NULL  AND  // Billing summary will come in Asc order.  ----------------------------------
        for( Billing_Summary__c objBillSum : [ SELECT Id, alletec_billdate__c,Patient__r.Max_ID__c 
                                              FROM Billing_Summary__c 
                                              WHERE Patient__c <> NULL AND Patient__r.RecordType.Name = 'Patient' 
                                              AND Patient__r.Max_ID__c IN : mapMaxIdWithWrapSubmit_BillDate.keySet() 
                                              AND alletec_billdate__c <> NULL
                                              ORDER BY alletec_billdate__c ASC  ] ){
                                                  
                                                   if( Boolean.valueOf( Label.showDebugForBatchLeadFirstOPDBillDateUpdate ) ) 
                                                   { System.debug( 'objBillSum' + objBillSum );
                                                    system.debug('mapMaxIdWithWrapSubmit_BillDate.get( objBillSum.Patient__r.Max_ID__c ).submittedDate'+mapMaxIdWithWrapSubmit_BillDate.get( objBillSum.Patient__r.Max_ID__c.toLowerCase() ).submittedDate);
                                                   }
                                                  
                                                  //-------------------------------  only if objBillSum.alletec_billdate__c is greater than lead's Submitted on date   -----------------------
                                                  if( mapMaxIdWithWrapSubmit_BillDate.get( objBillSum.Patient__r.Max_ID__c.toLowerCase() ).submittedDate <= objBillSum.alletec_billdate__c ){
                                                      
                                                      if( mapMaxIdWithWrapSubmit_BillDate.get( objBillSum.Patient__r.Max_ID__c.toLowerCase() ).firstBilldate == Null ){
                                                          
                                                          mapMaxIdWithWrapSubmit_BillDate.get( objBillSum.Patient__r.Max_ID__c.toLowerCase() ).firstBilldate = objBillSum.alletec_billdate__c;
                                                      }
                                                      //-------------------------------------------  Just in case Billing summary doesn't come in Asc order  -----------------------------------
                                                      else {
                                                          
                                                          if( mapMaxIdWithWrapSubmit_BillDate.get( objBillSum.Patient__r.Max_ID__c.toLowerCase()).firstBilldate >= objBillSum.alletec_billdate__c ){
                                                              
                                                              mapMaxIdWithWrapSubmit_BillDate.get( objBillSum.Patient__r.Max_ID__c.toLowerCase() ).firstBilldate = objBillSum.alletec_billdate__c;
                                                          }
                                                      }
                                                  }
                                                  
                                              }//end of Loop Billing_Summary__c
        
        for( Lead__c objLead :  listLead ){
            
            //---------------------------------------------------  only if there is a billing summary found whose bill date is greater than Lead's submitted date  -------------------------
            if( mapMaxIdWithWrapSubmit_BillDate.get( objLead.Max_ID__c.toLowerCase() ).firstBilldate <> NULL ){
                
                objLead.First_OPD_Bill_Date__c = mapMaxIdWithWrapSubmit_BillDate.get( objLead.Max_ID__c.toLowerCase() ).firstBilldate;
                listCustomLead.add( objLead );
            }
                
        }//end of lead loop
        
        if( listCustomLead.size() > 0 )
            update listCustomLead;
        //-------------------------------------------------------- Clearing Heap ---------------------------------------------------------------------------------------
        mapMaxIdWithWrapSubmit_BillDate.clear();
        listCustomLead.clear();
    }
    
    global void finish(Database.BatchableContext BC){
    }
    
    //--------------------------------------------------  use to map Max id with Lead's submitted date and Account's billing summary date  -------------------------------------------
    global class WrapLeadSubmitDateWithBilldate{
        
        DateTime submittedDate;
        DateTime firstBilldate;
        
        global WrapLeadSubmitDateWithBilldate( DateTime submittedDate1 ){
            
            submittedDate = submittedDate1;
        }
    }
}