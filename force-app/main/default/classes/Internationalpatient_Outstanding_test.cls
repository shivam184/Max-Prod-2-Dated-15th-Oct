@isTest
public class Internationalpatient_Outstanding_test {
    static testmethod	void test()
    {
        Account acc3=new account();
        acc3.Name='Test1';
         acc3.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('International HCF Account').getRecordTypeId();
        insert acc3;
        
        Speciality__c s=new Speciality__c();
        s.name='ghoul';
        insert s;
        
        Business_Unit__c obj1=new Business_Unit__c();
        obj1.Name = 'Test';
        insert obj1;
        
        Admission_Acknowledgement__c ack= new Admission_Acknowledgement__c();
        ack.IPID__c='123';
        ack.alletec_hospitallocation__c=obj1.id;
        ack.HCF_Source__c=acc3.id;
        ack.Sub_Speciality__c=s.id;
        ack.pcl_markuptype__c='gfgfghgf';
        ack.Is_Patient_Transfer__c='yesss';
        insert ack;
        
        Internationalpatient_Outstanding__c io =new Internationalpatient_Outstanding__c();
        io.alletec_ipid__c=123;
        io.alletec_location__c=obj1.id;
        insert io;
    }
    
}