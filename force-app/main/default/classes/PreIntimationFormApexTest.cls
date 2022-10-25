@isTest 
public class PreIntimationFormApexTest {
    @isTest
    public static void Test(){
        
        Department__c dept=new Department__c();
        dept.Name='test';
        insert dept;
        
        Speciality__c scp= new Speciality__c();
        scp.Name='test';
        scp.alletec_department__c=dept.id;
        insert scp;
        
        Account acc = new Account();
        acc.Name ='teste';
        acc.SF_Speciality__c = scp.Id;
        insert acc;
        
        PreIntimationFormApex.doInItApex();
        PreIntimationFormApex.getdepartment(acc.Id);
        PreIntimationFormApex.doSaveApex('patientName', '','mecpSource', '', 'ailment', 'Vaishali', 'Yes', 'fileName', 'base64Data', 'notes', 'selectedFileType', System.now(),'12','test');
    }
}