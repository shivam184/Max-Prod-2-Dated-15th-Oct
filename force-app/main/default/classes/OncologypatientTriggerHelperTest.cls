@isTest
public class OncologypatientTriggerHelperTest {
    @isTest
    public static void FinalTest1(){
        Test.startTest();
        String oncorecordTypeId = Schema.SObjectType.Prospect__c.getRecordTypeInfosByName().get('Onco Patient Prospect').getRecordTypeId();
        Prospect__c pros = new Prospect__c();
        pros.name = 'Abhi test';
        pros.Max_Id__c = '123';
        pros.RecordTypeId = oncorecordTypeId;
        pros.Treatment_Completed__c = false;
        insert pros;
            Account acc33=new account();
        acc33.Name='Test1';
        acc33.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('International HCF Account').getRecordTypeId();
        insert acc33;
        
        String patientRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId(); 
        Account acc2 = new Account();
        if(String.isNotBlank(patientRecordTypeId))
            acc2.RecordTypeId = patientRecordTypeId;
        acc2.Max_ID__c ='123';
        acc2.LastName = 'Patient Account';        
        
        insert acc2;
        Billing_Summary__c bs = new Billing_Summary__c();
        
        bs.alletec_isinternational__c=true;
        bs.HCF_Source__c = acc33.id;
        bs.Patient__c = acc2.id;
        bs.name__c='123';
        bs.Auto_Tagged__c=true;
        bs.alletec_dateofadmission__c=date.today().adddays(-5);
        bs.Is_Tagged_By_International_Hidden__c=true;
        bs.SMS_Tagged__c=true;
        bs.alletec_billdate__c = date.today().addDays( -1 );
        bs.alletec_transactiontype__c = 'IP';
        insert bs;
        
        
        
        
        oncology_patient_journey__c onco = new oncology_patient_journey__c();
        onco.Patient_Max_id__c ='1234';
        onco.Patient_Name__c ='Abhishek Singh';
        onco.Malignant__c = True;
         onco.Benign__c = false;
        onco.EP_Number__c ='122';
        onco.Stage__c ='New';
        Insert onco;
        
        //oncology_patient_journey__c onco1 = [Select Id ,Malignant__c,EP_Number__c,Benign__c from oncology_patient_journey__c where Id =: onco.Id];
        //onco1.EP_Number__c ='Test Abhi';
        //onco1.Benign__c = true;
        //update onco1;
        
        


        test.Stoptest();
         }

}