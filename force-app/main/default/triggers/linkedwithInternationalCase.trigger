trigger linkedwithInternationalCase on Visa_Invite__c (before insert,before update,after insert) {
    
    if (Trigger.isBefore && label.Visainvite_trigger=='On') {
        
        map<String,Id> mappas2record = new map<String,Id>();
        for(Visa_Invite__c vis : trigger.new){
            if(vis.Passport_number__c!=null) 
                mappas2record.put(vis.Passport_number__c, vis.id);
        }
         system.debug('Account Passport Id' +mappas2record );
        
        if(mappas2record!=null && mappas2record.size() > 0){
           map<string,Account> AccountMap = new map<string,Account>();
          list<account> acclist=[SELECT Passport__c,id,Max_ID__c,name,CountryAddressMaster__c,Patient_Mobile_Number__c FROM Account where Passport__c IN:mappas2record.keySet() AND RecordType.Name='Patient' AND createddate <= LAST_N_DAYS:90];
            system.debug('Account List Size' +acclist.size()) ;
            if(acclist.size()>0){
                for(account acc:acclist){
                    AccountMap.put(acc.Passport__c,acc);
                }
                
            }
            for(Visa_Invite__c vis : trigger.new){

                if(vis.Passport_number__c <> null && AccountMap.containsKey(vis.Passport_number__c)){
                    vis.Customer_Patient_Name__c=AccountMap.get(vis.Passport_number__c).Name;
                if(AccountMap.get(vis.Passport_number__c).Patient_Mobile_Number__c !=null)
                    vis.Mobile_Number__c=AccountMap.get(vis.Passport_number__c).Patient_Mobile_Number__c; 
                if(AccountMap.get(vis.Passport_number__c).Max_Id__c !=null)
                    vis.Max_ID__c=AccountMap.get(vis.Passport_number__c).Max_ID__c;
               // if(AccountMap.get(vis.Passport_number__c).CountryAddressMaster__c!=null)
                   // vis.Country__c=AccountMap.get(vis.Passport_number__c).CountryAddressMaster__c;
                vis.Patient__c=AccountMap.get(vis.Passport_number__c).id; 
                }
            } 
            
            
        }    
        
        
        
        
    }
    
    
    
    
    
   
    if (Trigger.isAfter) {
        map<String,Id> mappas2record = new map<String,Id>();
        for(Visa_Invite__c vis : trigger.new){
            if(vis.Passport_number__c!=null)
                mappas2record.put(vis.Passport_number__c, vis.id);
        }
         system.debug('PassportNumber' + mappas2record);
        if(mappas2record!=null && mappas2record.size() > 0){
            list<Case> lst2update = new list<Case>();
            list<Lead__c> lstLead2update = new list<Lead__c>();
            List<Case> caseList = [SELECT Id,VIL_Detail__c,Passport_No__c from Case where VIL_Detail__c = null AND
                            Passport_No__c IN : mappas2record.keySet() and passport_No__c != null ];
            system.debug('CaseList Data ' + caseList);
            if(caseList.size() == 0)
                return;
            for(Case cse : caseList){
                                if(mappas2record.containsKey(cse.Passport_No__c)){
                                    cse.VIL_Detail__c = mappas2record.get(cse.Passport_No__c);
                                    cse.VIL_requested_by_partner__c = 'Yes';
                                    lst2update.add(cse);
                                }
                            }
            for(Lead__c lead : [SELECT Id,VIL_Detail__c,Passport_No__c from Lead__c where VIL_Detail__c=null AND 
                                Passport_No__c IN:mappas2record.keySet() and passport_No__c != null]){
                                    if(mappas2record.containsKey(lead.Passport_No__c)){
                                        lead.VIL_Detail__c = mappas2record.get(lead.Passport_No__c);
                                        lead.VIL_requested_by_partner__c = 'Yes';
                                        lstLead2update.add(lead);
                                    }
                                }
            
            if(lstLead2update!=null && lstLead2update.size() > 0)
                update lstLead2update;
            
            if(lst2update!=null && lst2update.size() > 0)
                update lst2update;
        }
    }
    
    
}