@isTest
public class PreIntimationTaggingApexTest {
    @isTest
    public static void outcome(){
        Lead__c lead = new Lead__c();
        lead.Name = 'testLead';
        lead.RecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('MECP').getRecordTypeId();
        lead.Dr_Intimation_Date_Time__c = DateTime.newInstance(2019,01,01,23,01,01);
        lead.Intimation_Date_Time__c = DateTime.newInstance(2019,01,01,23,01,01);
        insert lead;

		PreintimationTaggingApex.fetchDataApex(UserInfo.getUserId(),'test','test');
        //PreintimationTaggingApex.fetchDataApex(UserInfo.getUserId(),'tzzz');
        
        //minutesOfEmergencyEPrescription em=label.minutesOfEmergencyEPrescription();
        //em.
        
        Admission_Acknowledgement__c adm = new Admission_Acknowledgement__c();
        adm.Max_ID__c = '12345';
        adm.Patient_Name__c = 'test';
        adm.Doctor_Name__c = 'test';
        adm.Channel_Name__c = 'TPA';
        adm.Is_Emergency__c=true;
        insert adm;
        
       
        
        PreintimationTaggingApex.doSearchApex('12345','test','test','',false);
        
        adm.Pre_Intimation_Status__c = 'Pre';
        adm.Channel_Name__c = 'MECP';
        update adm;
        
        PreintimationTaggingApex.doSearchApex('12345','test','test','',true);
        
        Account acc = new Account();
        acc.Name = 'test';
        acc.Type = 'MACN';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('MECP Doctor Business').getRecordTypeId();
        insert acc;
        
        PreintimationTaggingApex.getMECPType(acc.Id);
        
        PreintimationTaggingApex.retaggingApex(adm.Id, acc.Id);
        
        PreintimationTaggingApex.doGetMecpDoctor('test');
        
        PreintimationTaggingApex.untag(acc.Id,adm.Id,'testing');
        
        PreintimationTaggingApex.tagWithoutPreIntimationApex(acc.Id,adm.Id,'testing',true);
        
        PreintimationTaggingApex.checkAccountType(adm.id);
        
        PreintimationTaggingApex.tagWithPreIntimationApex(lead.Id,adm.id, acc.id);
        
        adm.Coupon_Code__c = 'MECP';
        update adm;
        
        PreintimationTaggingApex.tagWithPreIntimationApex(lead.Id,adm.id, acc.id);
        
        adm.Coupon_Code__c = '';
        adm.Date_Time_of_Admission__c = System.now();
        update adm;
        
        acc.Type = 'MECP';
        update acc;
        
        test.setCreatedDate(lead.Id,DateTime.newInstance(2018,01,01,01,01,01));
        
        PreintimationTaggingApex.tagWithPreIntimationApex(lead.Id,adm.id, acc.id);
        
        adm.Is_Emergency__c = true;
        update adm;
        
        PreintimationTaggingApex.tagWithPreIntimationApex(lead.Id,adm.id, acc.id);
        
        adm.Is_Emergency__c = false;
        update adm;
        
        PreintimationTaggingApex.tagWithPreIntimationApex(lead.Id,adm.id, acc.id);
        
        ContentVersion content =new ContentVersion(); 
        content.Title = 'test'; 
        content.VersionData=EncodingUtil.base64Decode('testing');
        content.Notes__c = 'testing';
        content.File_Type__c = 'E-Prescription';
        content.PathOnClient= '/' + 'testing';
        insert content; 
        
        content = [select id, ContentDocumentId from ContentVersion WHERE Id =: Content.Id];
        ContentDocumentLink cl = new ContentDocumentLink();
        cl.ContentDocumentId = content.ContentDocumentId;
        cl.LinkedEntityId = lead.Id; 
        cl.ShareType = 'V';
        insert cl;
        
        PreintimationTaggingApex.tagWithPreIntimationApex(lead.Id,adm.id, acc.id);
        
        ContentVersion content1 =new ContentVersion(); 
        content1.Title = 'test'; 
        content1.VersionData=EncodingUtil.base64Decode('testing');
        content1.Notes__c = 'testing';
        content1.File_Type__c = 'Screenshot';
        content1.PathOnClient= '/' + 'testing';
        insert content1; 
        
        test.setCreatedDate(content1.id, DateTime.newInstance(2019,01,01,23,01,01));
        
        content1 = [select id, ContentDocumentId from ContentVersion WHERE Id =: Content1.Id];
        ContentDocumentLink cl1 = new ContentDocumentLink();
        cl1.ContentDocumentId = content1.ContentDocumentId;
        cl1.LinkedEntityId = lead.Id; 
        cl1.ShareType = 'V';
        insert cl1;
        
        PreintimationTaggingApex.tagWithPreIntimationApex(lead.Id,adm.id, acc.id);
        
    }
    
    @isTest
    public static void test1(){
		Lead__c lead = new Lead__c();
        lead.Name = 'testLead';
        lead.RecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('MECP').getRecordTypeId();
        lead.Dr_Intimation_Date_Time__c = DateTime.newInstance(2019,01,01,23,01,01);
        
        insert lead;
		
        Account acc = new Account();
        acc.Name = 'test';
        acc.Type = 'MECP';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('MECP Doctor Business').getRecordTypeId();        
        insert acc;
        
        ContentVersion contents =new ContentVersion(); 
        contents.Title = 'test'; 
        contents.VersionData=EncodingUtil.base64Decode('testing');
        contents.Notes__c = 'testing';
        contents.File_Type__c = 'E-Prescription';
        contents.PathOnClient= '/' + 'testing';
        insert contents; 
        
        contents = [select id, ContentDocumentId from ContentVersion WHERE Id =: Contents.Id];
        ContentDocumentLink cls = new ContentDocumentLink();
        cls.ContentDocumentId = contents.ContentDocumentId;
        cls.LinkedEntityId = lead.Id; 
        cls.ShareType = 'V';
        insert cls;   
        
        Admission_Acknowledgement__c adm = new Admission_Acknowledgement__c();
        adm.Max_ID__c = '12345';
        adm.Patient_Name__c = 'test';
        adm.Doctor_Name__c = 'test';
        adm.Channel_Name__c = 'TPA';     
        adm.Is_Emergency__c=false;
        adm.Date_Time_of_Admission__c = System.now();
        insert adm;                    
		
        PreintimationTaggingApex.tagWithPreIntimationApex(lead.Id,adm.id, acc.id);                          
        
        Lead__c l = new Lead__c();
        l.Name = 'testLead1';
        l.RecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('MECP').getRecordTypeId();
        l.Dr_Intimation_Date_Time__c = DateTime.newInstance(2019,01,01,23,01,01);        
        insert l;
		
        Account a = new Account();
        a.Name = 'test1';
        a.Type = 'MECP';
        a.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('MECP Doctor Business').getRecordTypeId();        
        insert a;
        
        ContentVersion content1 =new ContentVersion(); 
        content1.Title = 'test1'; 
        content1.VersionData=EncodingUtil.base64Decode('testing');
        content1.Notes__c = 'testing1';
        content1.File_Type__c = 'Screenshot';
        content1.PathOnClient= '/' + 'testing1';
        insert content1; 
        
        test.setCreatedDate(content1.id, DateTime.newInstance(2019,01,01,23,01,01));
        
        content1 = [select id, ContentDocumentId from ContentVersion WHERE Id =: Content1.Id];
        ContentDocumentLink cls1 = new ContentDocumentLink();
        cls1.ContentDocumentId = content1.ContentDocumentId;
        cls1.LinkedEntityId = l.Id; 
        cls1.ShareType = 'V';
        insert cls1;   
        
        Admission_Acknowledgement__c ad = new Admission_Acknowledgement__c();
        ad.Max_ID__c = '123451';
        ad.Patient_Name__c = 'test1';
        ad.Doctor_Name__c = 'test1';
        ad.Channel_Name__c = 'PSU';     
        ad.Is_Emergency__c=false;        
        insert ad;                    
		
        PreintimationTaggingApex.tagWithPreIntimationApex(l.Id,ad.id, a.id);                                       
        
        PreintimationTaggingApex.tagWithPreIntimationApex('',ad.id, a.id);
        
        PreintimationTaggingApex.tagWithPreIntimationApex(l.Id,'', a.id);

        PreintimationTaggingApex.tagWithoutPreIntimationApex(acc.Id,adm.Id,'testing',false);
                
        acc.Type='Pehel';
        update acc;
        
        PreintimationTaggingApex.tagWithoutPreIntimationApex(acc.Id,adm.Id,'testing',false);               
        
        PreintimationTaggingApex.tagWithoutPreIntimationApex(acc.Id,'','testing',false);
        
        PreintimationTaggingApex.tagWithPreIntimationApex(lead.Id,adm.id, acc.id);                       
        
        PreintimationTaggingApex.untag(acc.Id,'','testing');
        
        PreintimationTaggingApex.doGetMecpDoctor('');
        
        PreintimationTaggingApex.retaggingApex('','');
        
        PreintimationTaggingApex.getMECPType('');
                        
    }
    
}