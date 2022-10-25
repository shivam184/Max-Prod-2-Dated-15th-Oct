global class LeadBillingSummaryBatch implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext BC){
        Integer days = Integer.valueof(System.Label.NmonthsDigitalLeads);
        Date todaydate = System.today().addmonths(-days);
        DateTime newDate = DateTime.newInstance(todaydate.year(),todaydate.month(), todaydate.day(), 0, 0, 0);
        String query = 'SELECT Id,Max_ID__c,Submitted_On__c FROM Lead__c WHERE RecordType.Name = \'Digital Customer Acquisition\' AND Max_ID__c  != NULL AND Submitted_On__c>=:newDate';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<Lead__c> ldlst){
        map<string,Lead__c> mapmaxIdleadmap = new map<string,Lead__c>();
        
        for(Lead__c lea : ldlst)
            mapmaxIdleadmap.put(lea.Max_ID__c,lea);           
        
        System.debug('@@@----->>>>'+mapmaxIdleadmap.size());        
                
        List<Account> acclst = [Select Id,Max_ID__c,(SELECT Id,Digital_Lead__c,alletec_billdate__c from Billing_Summary_Patients__r where Digital_Lead__c=null) from Account 
                                where RecordType.Name = 'Patient' AND Max_ID__c In:mapmaxIdleadmap.keySet()];
        if(acclst.size() > 0){
            
            List<Billing_Summary__c> billsummary2updatelst = new List<Billing_Summary__c>();
            system.debug('acclstsize--->>>'+acclst.size());
            
            for(Account acc : acclst){
                if(mapmaxIdleadmap.containskey(acc.Max_ID__c) && acc.Billing_Summary_Patients__r.size() > 0){
                    for(Billing_Summary__c billsum : acc.Billing_Summary_Patients__r){
                        if(mapmaxIdleadmap.containskey(acc.Max_ID__c) && (billsum.alletec_billdate__c >= mapmaxIdleadmap.get(acc.Max_ID__c).Submitted_On__c)){
                            billsum.Digital_Lead__c = mapmaxIdleadmap.get(acc.Max_ID__c).Id;
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