@isTest(seeAllData = false)
public class EstimationControllerTest {
    @isTest
    public static void getoutput(){
        Test.startTest();
        
        Business_Unit__c Bunit = new Business_Unit__c();
        Bunit.HIS_ID__c = 'New Delhi';
        insert Bunit;
        
        
        
        
        Admission_Acknowledgement__c act = new Admission_Acknowledgement__c();
        act.Admission_Status__c = 'Admitted';
        act.Max_ID__c = '45';
        insert act;
        
          String oncorecordTypeId = Schema.SObjectType.Prospect__c.getRecordTypeInfosByName().get('Onco Patient Prospect').getRecordTypeId();
        Prospect__c pros = new Prospect__c();
        pros.name = 'Abhi test';
        pros.Max_Id__c = '123';
        pros.RecordTypeId = oncorecordTypeId;
        pros.Stage__c = 'Treatment Started';
        pros.Treatment_Completed__c = False;
        //pros.Onco_Lead__c = onco.id;
        insert pros;
        oncology_patient_journey__c onco = new oncology_patient_journey__c();
        onco.Patient_Max_id__c ='45';
        onco.Patient_Name__c ='Abhishek Singh';
        onco.Malignant__c = True;
        onco.EP_Number__c ='122';
        onco.Stage__c ='New';
        Insert onco;
       
        Billing_Summary__c bill = new Billing_Summary__c();
        bill.alletec_billdate__c = System.now();
        bill.Admission_Acknowledgement__c = act.Id;
        insert bill;
                
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/createestimation/';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof('{"PatientName" : "Test","EstimationID" : "345","HIS_Hospital_Location__c" : "Business Unit","LengthOfStay" : "10","EstimationDate" : "2017-02-17","AdmissionDate":"2019-01-01","MaxID" : "45","DoctorName":"Raman Dixit","DoctorID" : "1234","prospectId" :"4321","EstimatedGivenBy" : "2018-02-17","EstimatedGivenById":"102","EstimatedGivenByDepartment":"IT","EstimationNo":"201","CurrentBedType":"Normal","IsPatientReg":"Yes","LocationName":"New Delhi","DepositAmount":"110","CurrentBill":"209","LocationCode":"207","DiscountPer":"20","DiscRemarks":"201","DiscPerAmt":"7","DiscReason":"xyz","AnnexureDescription":"blahhh","leadId":"0054","BirthDate" : "2010-02-12","LineItems":[{"ServiceName":"ESR","SingleBed":1,"DoubleBed":0,"FourBed":0,"EconomyBed":0,"ClassicDeluxBed":1,"SuiteBed":1,"VIPSuiteBed":0,"DayCareBed":0,"Itemcount":1}]}');
        RestContext.request = req;
        RestContext.response= res;        
        
        EstimationController.doCreateOPIPLead();
        EstimationController.RequestBody requestBody = new EstimationController.RequestBody();
        
        req.requestBody = Blob.valueof('{"PatientName" : "Test","EstimationID" : "345","MaxID" : "","BirthDate" : "2010-02-12","LengthOfStay" : "10","EstimationDate" : "2017-02-17","EstimatedGivenBy" : "2018-02-17","IsPatientReg" :"No","AdmissionDate":"2019-01-01","DoctorName":"Raman Dixit","DoctorID":"101","EstimatedGivenById":"102","EstimatedGivenByDepartment":"IT","EstimationNo":"201","CurrentBedType":"Normal","CompanyType":"Platinum","LocationName":"New Delhi","LocationCode":"110077","DiscountPer":30,"DiscRemarks":"Good","DiscPerAmt":50,"DiscReason":"Unidentified","AnnexureDescription":"I do not know","leadId":"0054"}');
        EstimationController.doCreateOPIPLead();     
        
        Test.stopTest();
    }
}