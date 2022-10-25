@isTest
public class InternationalQueryFormTest {
    @isTest
    static void test(){
        
        test.startTest();
        
        String recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('International HCF Account').getRecordTypeId();
        String recordTypeIdCountry = Schema.SObjectType.Address_Master__c.getRecordTypeInfosByName().get('Country').getRecordTypeId();
        
        Account acnt = new Account();
        acnt.RecordTypeId = recordTypeId;
        acnt.Name = 'test';
        acnt.Max_ID__c = 'test.12345';
        insert acnt;
        
        Address_Master__c addd=new Address_Master__c();
        addd.Name='India';
        addd.RecordTypeId=recordTypeIdCountry;
        Insert addd;
        
        String recordtypeIdld = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('International Query Management').getRecordTypeId();
        
        list<lead__c> leadList = new list<lead__c>();
        
        Lead__c ld1 = new lead__c();
        ld1.First_Name__c = 'test';
        ld1.HCF_Partner__c =acnt.id;
        ld1.Name = 'test test test';
        ld1.RecordTypeId = recordtypeIdld;
        ld1.Mobile_Phone__c = '9876543210';
       ld1.LeadType__c = 'International Query';
     	 ld1.Country_Query__c=addd.Id;
        ld1.Stage__c = 'New Query';
        ld1.Lead_Channel__c='International';
        ld1.Lead_Source__c='Email';
        ld1.Intlr_Intimation_Date__c=system.today();
      
        leadList.add(ld1);
          
        insert leadList;
       
     	ld1.International_Query_File_Name__c='test';
        
        update leadList;
      
        blob blobbody = blob.valueOf('Test data to be inserted');
       
        ContentVersion con = new ContentVersion();
        con.Title = 'image_2021_03_25T12_26_54_923Z';
        con.PathOnClient ='image_2021_03_25T12_26_54_923Z.png' ;
     	con.VersionData =blobbody;
            
        insert con;
        ContentVersion conv2 =[select id,Title,ContentDocumentId from ContentVersion where Id =: con.Id Limit 1 ];
        ContentDocumentLink cl = new ContentDocumentLink();
         cl.ContentDocumentId = conv2.ContentDocumentId;
        cl.LinkedEntityId = leadList[0].Id; 
        cl.ShareType = 'V';
        insert cl;
        InternationalQueryForm.WrapperClass testWrap=new InternationalQueryForm.WrapperClass();
        String fname1 ='[{"fname":"image_2021_03_25T12_26_54_923Z.png","base64":"iVBORw0KGgoAAAANSUhEUgAABVYAAAMACAYAAADPPjzCAAAgAElEQVR4Aey9B5gVVbru77ln7v+c/z13ZhS6iSbMYdTRMTGjY8Q4jjrmMY4ZxYSCCCo5Q0OTmtTEJgcFBETQUclBguTQTdPQ3dC0IEEEAd/7fKv2qr2qdu3euXvv3e9+nupKK37rXbWqfv3VqlMKdpQgkmX7jlLk++Lk7yiOKG4k+TBsZO1Ce6WHvXSfUn2sqLTC/sW+mB5tzr6bnO3Ivpic7cL+Uv3ahX2x+rU5+3lytnkkfbFkdzkOHPoJPx89hhMnT4I/WoAWiI8FpD9Jv5L+Vby7vMJnRV5Lk/NaynZJz3Y5JZKG1QNqJHEYNj2Fw3atpHYt9M6HfdHbLtQl7"}]';
        
        InternationalQueryForm.doSaveLead(leadList[0], addd.Id, acnt.id, fname1);
        //InternationalQueryForm.doSaveLead(ld1,addd.id,acnt.id);
        List<String> lstPickValue = InternationalQueryForm.getPickListValuesIntoList();
        
        
        test.stopTest();
        
    }
}