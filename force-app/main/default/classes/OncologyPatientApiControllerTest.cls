@isTest
public class OncologyPatientApiControllerTest {
 
      
      @isTest
    public static void FinalTest1(){
        
        oncology_patient_journey__c onco = new oncology_patient_journey__c();
        onco.Patient_Max_id__c ='SKDD.8485119';
        onco.Patient_Name__c ='Abhishek Singh';
        Insert onco;
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/OncologyPatientJourney/OncologyEprescription';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof('{"Data":[{"Maxid":"SKDD.8485119","EPrescriptionNo":"TestEp 123","RequiredMoreinvestigation":false,"Malignant":true,"Benign":false}]}');
        RestContext.request = req;
        RestContext.response= res;
        OncologyPatientApiController.doCreateRecords(); 
        test.Stoptest();
         }
      @isTest
    public static void FinalTest2(){
     Test.startTest();
         String oncorecordTypeId = Schema.SObjectType.Prospect__c.getRecordTypeInfosByName().get('Onco Patient Prospect').getRecordTypeId();
     	Prospect__c pros = new Prospect__c ();
        //pros.Patient_Name__c = 'test';
        pros.RecordTypeId = oncorecordTypeId;
        pros.Max_Id__c ='123456';
        pros.Name ='test123';
        insert pros;
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = 'services/apexrest/OncologyPatientJourney/OncoTracker';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof('Test');
         //OncologyPatientApiController.doCreateRecords();  
        
        req.requestBody = Blob.valueof('{"Data":[{"MaxID":"123456","Referstotumourboard":true,"DMG" : "Test Data","DATEOFADMISSION" : "2018-06-04","ProcedureName" : "Test Data","PrescriptionDate" : "2018-06-04","VisitDate" : "2018-06-04","DiscountReason" : "Test Data","Surgery" :false,"Chemo" : true,"RT" :false,"CTRT": true,"SurRT" : false,"SurCT" : true ,"TreatmentStarted" : true ,"TreatmentCompleted" : false,"Surgical" : true,"Medical" : true,"Radiation" : true,"oncono" : "123456","Diagnosis" : "Test Diagnosis","OncoStage" : "Test OncoStage","PathologyPrescribe" : "test Pathology", "RadiologyPrescribe" : "Test Radiology Prescribe"}]}');
        RestContext.request = req;
        RestContext.response= res;
        
        OncologyPatientApiController.doCreateRecords();
        Test.stopTest();
         }
    
          @isTest
    public static void FinalTest3(){
        
     Test.startTest();
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = 'services/apexrest/OncologyPatientJourney/Chemo';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof('Test');
         //OncologyPatientApiController.doCreateRecords();  
        
        req.requestBody = Blob.valueof('{"Data":[{"Maxid":"SKDD.848511","Title":"MR.","FirstName" : "Abhishek","LastName" :"Mishra","DrugName" : "Drug Name","Drugtype" :"Medical","DrugNameSecondary": "Secondary","Estimate" : "1200000","ProcedureType" : "Procedure Test","Age" : "20","EmailId" : "Test.@test.com","Phoneno" : "1234567890","Admissiondate" : "2018-06-04", "Gender" : "Male", "DMG" : "DMG Data","Diagnosis" : "Test Diagnosis","Admittingdoctor" : "Abhishek Singh","ProcedureDate" : "2021-06-04 12:15:38","FollowUpDate" : "2021-07-04 12:15:38","Chemoid" : "1234564", "Remark" : "Test remarks"} ]}');
          RestContext.request = req;
        RestContext.response= res;
        
        OncologyPatientApiController.doCreateRecords();
        Test.stopTest();
         }
  

}