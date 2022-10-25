global class CountryMappingBatchClass implements Database.Batchable<sObject>{
    
    global List<Nationality__c> nationalityList = new List<Nationality__c>();
    global Map<String,String> mapToNationality = new Map<String,String>();
    
    global CountryMappingBatchClass(){
        nationalityList = Nationality__c.getAll().values();        	
        for(Nationality__c nationality : nationalityList){
            mapToNationality.put(nationality.HIS_ID__c,nationality.Name);
        }
    }
    
    global Database.QueryLocator start(Database.BatchableContext b){ 
        String[] s = new String[]{'%a%','%b%','%c%','%d%','%e%','%f%','%g%','%h%','%i%','%j%','%k%','%l%','%m%','%n%','%o%','%p%','%q%','%r%','%s%','%t%','%u%','%v%','%w%','%x%','%y%','%z%',
            '%!%','%@%','%#%','%$%','%^%','%&%','%*%','%(%','%)%','%-%','%+%','%=%','%|%','%{%','%[%','%}%','%]%','%:%','%;%','%<%','%,%','%>%','%.%','%?%','%/%','%~%','%`%'};
                
                return Database.getQueryLocator('SELECT iD,address2_country__c FROM Account WHERE RecordType.Name = \'Patient\' AND (not address2_country__c like :s) AND address2_country__c!= NULL AND address2_country__c != \'0\'');
    }
    
    global void execute(Database.BatchableContext b,List<Account> accountList){ 
        List<Account> updateAccountList = new List<Account>();
        if(mapToNationality != NULL && mapToNationality.keySet().size() > 0) {
            for(Account acc : accountList) {
                if(mapToNationality.containsKey(acc.address2_country__c)) {
                    Account accNew = new Account();
                    accNew.Id = acc.Id;
                    accNew.address2_country__c = mapToNationality.get(acc.address2_country__c);
                    updateAccountList.add(accNew);
                }
            }
        }
        
        if(updateAccountList != NULL && updateAccountList.size() > 0)
            update updateAccountList;
    }
    
    global void finish(Database.BatchableContext b){
        
    }
    
}