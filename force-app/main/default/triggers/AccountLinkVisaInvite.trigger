trigger AccountLinkVisaInvite on Account (after insert,after update) {
    if(label.accountrigger=='On'){
    Set<string>  passportNoSet=new set<string>();
    list< Visa_Invite__c> viList=new List<Visa_Invite__c>();
    Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId();
    for(account acc:trigger.new){

        if(acc.Passport__c!=null && acc.RecordTypeId==accRecordTypeId)
            passportNoSet.add(acc.Passport__c);
        
    }
    if(passportNoSet!=null){
        
        system.debug('passportNoSet'+passportNoSet);
        list<Visa_Invite__c> VisaInviteList = [select Id, Name,Max_Id__c,Stage__c, Country__c, Country__r.Name, Diagnosis__c, Doctor_Name__c, Doctor_Name__r.Name, Doctor_Specialty__c, Expiration_Date__c, 
                                               HCF_Partner_name__c, HCF_Partner_name__r.Name,Hospital_Code__c, Hospital_Location__c, Hospital_Location__r.Name, Invite_address__c, Mobile_Number__c, 
                                               Passport_number__c, Issue_Date__c, Customer_Patient_Name__c, Email_Notification_Id__c,Visa_Invite_Number__c from Visa_Invite__c where Passport_number__c IN:passportNoSet AND createddate <= LAST_N_DAYS:90 order by createddate desc limit 1];           
        
      
       Map<string,Visa_Invite__c> VisaInviteMap = new  Map<string,Visa_Invite__c>();
        if(VisaInviteList.size()>0){
            for(Visa_Invite__c vi:VisaInviteList)
            {
                if(vi.Stage__c != 'Expired' && vi.Stage__c != 'Converted and Expired')
                   VisaInviteMap.put(vi.Passport_number__c,vi);
            }
            
        }
        
        if(VisaInviteList.size()>0){
            
                for(account acc:trigger.new){
                    if(acc.Passport__c <> null && VisaInviteMap.containsKey(acc.Passport__c)){
                    VisaInviteMap.get(acc.Passport__c).Customer_Patient_Name__c=acc.name;
                    if(acc.Max_ID__c!=null)            
                        VisaInviteMap.get(acc.Passport__c).Max_Id__c=acc.Max_ID__c;
                    if(acc.Patient_Mobile_Number__c	!=null)
                        VisaInviteMap.get(acc.Passport__c).Mobile_Number__c=acc.Patient_Mobile_Number__c	;
                    if(acc.CountryAddressMaster__c!=null)
                        VisaInviteMap.get(acc.Passport__c).Country__c=acc.CountryAddressMaster__c;
                    VisaInviteMap.get(acc.Passport__c).Patient__c=acc.id;
                    viList.add(VisaInviteMap.get(acc.Passport__c));
                    }
                }
            
            if(viList.size()>0)
            update viList;
        }
        
    }
    }
    
}