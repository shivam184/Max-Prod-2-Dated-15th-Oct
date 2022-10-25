/***********************Written By Shivam Gupta/Asger Mehndi***************
 * 
 * 
 * This is used for Patient Form QR Code LWC Component-8th June 2022
 * 
 * *************************************************************************/

public without sharing class QRController {
    @AuraEnabled
    public static list<Account> getAccountList(string searchKey) {
        string searchKeyword = '%' + searchKey + '%';
        System.debug('Seacrhkeyword'+searchKeyword);
        list<Account> AccListRecord = new list<Account>();
        List<Account> AccountList = [Select id,Name,Phone,PersonMobilePhone,mobilephone__c,FirstName,LastName,Gender__c
                              From Account
                              WHERE (PersonMobilePhone LIKE:searchKeyword)
                              And RecordType.Name='Patient' LIMIT 20];
        for(Account Accounts  : AccountList){
            
                                  AccListRecord.add(Accounts);
                         
                              }
            System.debug('ListRecord'+AccListRecord);
           
        if(AccListRecord.size()==0){
     
            throw new AuraHandledException('No Record Found..'); 
     
        }
        
        return AccListRecord;
    }
    
    
    
}