/**
* @File Name : AppointmentPatientBatch.cls
* @Description : This batch is used to map appointment with Patient( Account ) with Maxid or search on the basis of Phone and Gender
* @Author : Techmatrix Consulting
* @Group :
* @Last Modified By : Techmatrix Consulting
* @Modification Log : 
*==============================================================================
* Ver Date Author Modification
*==============================================================================
* 1.0  06 Jan 2020 Initial Version 
**/
global class AppointmentPatientBatch implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        
        //----------------------------------------------------------------  Fetching Custom Meta Data  ------------------------------------------------------------------------------------------
        Appointment_Revenue_Process__mdt BatchSetting = [ SELECT Custom_Start_Date__c, Custom_End_Time__c, Run_Batch_For__c, Show_Debug_For_AppointmentPatientBatch__c,Is_Legacy_Data_to_Update__c
                                                         FROM Appointment_Revenue_Process__mdt
                                                         WHERE DeveloperName = 'BatchSetting'];
        
        
        //---------------------------------------------------------------  Setting up Batch To process Last 6 month records  --------------------------------------------------------------------
        DateTime startDate = Datetime.newInstance(system.today().addMonths(-6), time.newInstance(0,0,0,0));
        DateTime endDate = Datetime.newInstance(system.today(), time.newInstance(0,0,0,0));
        
        //--------------------------------------------------------------- Incase if admin wants to run for specific time period  ----------------------------------------------------------------
        if( BatchSetting.Run_Batch_For__c == 'Custom Time Period' ){
            
            startDate = DateTime.newInstance( BatchSetting.Custom_Start_Date__c, time.newInstance(0,0,0,0) );
            endDate = DateTime.newInstance( BatchSetting.Custom_End_Time__c, time.newInstance(0,0,0,0) );
        }
        
        if( BatchSetting.Show_Debug_For_AppointmentPatientBatch__c){ system.debug(' Start Date ---->  '+ startDate + ' End Date ----> ' + endDate);}
        
        //fetching appointment record where Patient__c is Null and either maxId is not null or Patient_Phone or Gender is not null and Appointment_Created_Time__c inside 
        String query = 'SELECT Id,Max_ID__c,Patient__c,Patient_Phone__c,Gender__c,Appointment_Created_Time__c FROM Appointment__c';
        query += ' WHERE (( Patient_Phone__c!=NULL AND Gender__c != Null AND Appointment_Created_Time__c>=:startDate AND Appointment_Created_Time__c<=:endDate ) OR ( Max_ID__c != Null )) AND Patient__c=NULL';
        
        
        
        system.debug('===query='+query);
        return Database.getQueryLocator(query);
        
    }
    
    global void execute(Database.BatchableContext BC, List<Appointment__c> listAppointment){
        
        AppointmentRevenueProcessHelper.mappingAppointmentWithPatients( listAppointment, 0 ); 
    }
    global void finish(Database.BatchableContext BC){
        
    }
    
    
}