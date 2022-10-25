global class LeadBillingSummaryBatchNew implements Database.Batchable<sObject>{
     global   DateTime startDate=Datetime.newInstance(system.today().addMonths(-6), time.newInstance(0,0,0,0));
      global  DateTime endDate=Datetime.newInstance(system.today(), time.newInstance(0,0,0,0));
    global Database.QueryLocator start(Database.BatchableContext BC){
        Integer days = Integer.valueof(System.Label.Noofdays);
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
        
        
        //@Karan Singh 22Jan2020 added First_OPD_Bill_Date__c in query
        String query = 'SELECT Id,Max_ID__c,Submitted_On__c,First_OPD_Bill_Date__c FROM Lead__c WHERE RecordType.Name = \'Digital Customer Acquisition\' AND Stage__c=\'OPD Consult Taken\' AND Max_ID__c  != NULL AND First_OPD_Bill_Date__c>=:startDate AND First_OPD_Bill_Date__c<=:endDate';
        //system.debug([SELECT Id,Max_ID__c,Submitted_On__c,First_OPD_Bill_Date__c FROM Lead__c WHERE RecordType.Name = 'Digital Customer Acquisition' AND Stage__c='OPD Consult Taken' AND Max_ID__c  != NULL]);
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<Lead__c> ldlst){
        map<string,Lead__c> mapmaxIdleadmap = new map<string,Lead__c>();
        
        

        
        for(Lead__c lea : ldlst)
            mapmaxIdleadmap.put(lea.Max_ID__c.toLowerCase(),lea);           
        
        System.debug('@@@----->>>>'+mapmaxIdleadmap.size());        
        
        List<Account> acclst = [Select Id,Max_ID__c,(SELECT Id,Digital_Lead__c,alletec_billdate__c from Billing_Summary_Patients__r where Digital_Lead__c=null AND alletec_billdate__c>=:startDate 
                               AND alletec_billdate__c<=:endDate) from Account 
                                where RecordType.Name = 'Patient' AND Max_ID__c In:mapmaxIdleadmap.keySet()];
        if(acclst.size() > 0){
            
            List<Billing_Summary__c> billsummary2updatelst = new List<Billing_Summary__c>();
            system.debug('acclstsize--->>>'+acclst.size());
            
            for(Account acc : acclst){
                system.debug('====max='+mapmaxIdleadmap.containskey(acc.Max_ID__c.toLowerCase()));
                system.debug('====pat='+acc.Billing_Summary_Patients__r.size());
                if(mapmaxIdleadmap.containskey(acc.Max_ID__c.toLowerCase()) && acc.Billing_Summary_Patients__r.size() > 0){
                    for(Billing_Summary__c billsum : acc.Billing_Summary_Patients__r){
                        if(mapmaxIdleadmap.containskey(acc.Max_ID__c.toLowerCase()) && (billsum.alletec_billdate__c >= mapmaxIdleadmap.get(acc.Max_ID__c.toLowerCase()).First_OPD_Bill_Date__c)){ //@Karan Singh 22Jan2020 as per raghav sir exchanged Submitted_On__c to First_OPD_Bill_Date__c
                            billsum.Digital_Lead__c = mapmaxIdleadmap.get(acc.Max_ID__c.toLowerCase()).Id;
                            billsummary2updatelst.add(billsum);
                        }
                    }
                }
            }
            System.debug('billsummary2updatelst--->>>'+billsummary2updatelst.size());
            if(billsummary2updatelst.size() > 0)
                update billsummary2updatelst;
            
        }
    }
    
    global void finish(Database.BatchableContext BC){
    }
}