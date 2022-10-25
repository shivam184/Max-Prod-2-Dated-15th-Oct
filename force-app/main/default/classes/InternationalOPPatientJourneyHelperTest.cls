@isTest
public class InternationalOPPatientJourneyHelperTest {
    
     @isTest
    public static void FinalTest1(){
         Test.startTest();
        Billing_Summary__c bs = new Billing_Summary__c();
        bs.alletec_hisamount__c = 100;
        bs.billto_city__c='34';
        bs.alletec_state__c ='22' ; 
        bs.billto_country__c = '149';     
        bs.Hospital_Location_HIS__c = 'BU1';
        bs.name__c = 'MAX123';
        bs.alletec_transactiontype__c='IP';       
        bs.alletec_doctorid__c = '13254';        
        bs.alletec_locality__c = '42';
        bs.GL_Code__c='test23';
        bs.alletec_ipid__c='al123';
        insert bs;
        
        String oncorecordTypeId = Schema.SObjectType.Prospect__c.getRecordTypeInfosByName().get('OP - IP').getRecordTypeId();
        Prospect__c pros = new Prospect__c();
        pros.name = 'Test';
       pros.Max_Id__c = 'MAX123';
       pros.RecordTypeId = oncorecordTypeId;
        insert pros;
        
        International_OP_Patient_Journey__c IOP = new International_OP_Patient_Journey__c ();
        IOP.Name = 'Test';
        IOP.Patient_Max_id__c ='MAX123';
        IOP.First_OP_Bill_Date__c=system.today()-2;
        Insert IOP;
        //IOP.Stage__c ='Admission Advice';
       // IOP.Admission_advice__c = true;
        Update IOP;
        Test.stopTest();
        
        
    }

}