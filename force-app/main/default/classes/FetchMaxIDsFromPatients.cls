public class FetchMaxIDsFromPatients {
    public static Map<String,String> fetchMaxIdFromPhone(map<String,String> mapPhoneToMaxid,set<String> nameSet){
        String strname = '';
        String recordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId();
        if(String.isNotBlank(recordType)){
            List<Account> accountList = [Select id,Max_ID__c,PersonMobilePhone,FirstName,MiddleName,LastName from Account where RecordTypeId=:recordType 
                                         AND Max_ID__c!=null AND PersonMobilePhone!=null AND PersonMobilePhone IN:mapPhoneToMaxid.keySet()];
            for(Account act : accountList){
                if(act.LastName!=null)
                    strname = act.LastName;
                if(act.MiddleName!=null)
                    strname = act.MiddleName+' '+strname;
                if(act.FirstName!=null)
                    strname = act.FirstName+' '+strname;
                if(nameSet.contains(strname))
                    mapPhoneToMaxid.put(act.PersonMobilePhone,act.Max_ID__c);            }
            
        }
        return mapPhoneToMaxid;
    }
    
    public static Map<String,String> fetchMaxIdFromEmail(map<String, String> mapEmailToMaxid,set<String> nameSet){
        String strname = '';
        String recordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId();
        if(String.isNotBlank(recordType)){
            List<Account> accountList = [Select id,Max_ID__c,PersonEmail,LastName,MiddleName,FirstName from Account where RecordTypeId=:recordType 
                                         AND Max_ID__c!=null AND PersonEmail!=null AND PersonEmail IN:mapEmailToMaxid.keySet() ];
            
            for(Account act : accountList){
                if(act.LastName!=null)
                    strname = act.LastName;
                if(act.MiddleName!=null)
                    strname = act.MiddleName+' '+strname;
                if(act.FirstName!=null)
                    strname = act.FirstName+' '+strname;
                if(nameSet.contains(strname))
                    mapEmailToMaxid.put(act.PersonEmail,act.Max_ID__c);
            }
            
        }
        return mapEmailToMaxid;
    }
    
}