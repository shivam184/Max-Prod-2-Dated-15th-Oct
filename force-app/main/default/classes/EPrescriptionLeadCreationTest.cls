@isTest
public class EPrescriptionLeadCreationTest {
    
    @isTest
    static void testMe(){
        Business_Unit__c bu = new Business_Unit__c();
        bu.Name='Test Business';      
        insert bu;
        
        international_OP_Patient_Journey__c ipo=new international_OP_Patient_journey__c();
        ipo.First_OP_Bill_Date__c=system.today()-3;
        ipo.Patient_Max_id__c='1113';
        ipo.Consult__c=true;
        ipo.Radiology__c=true;
        ipo.Pharmacy__c=true;
        ipo.Pathology__c=true;
        insert ipo;
        
        
        String bunit=bu.Id;
        Prospect__c prospect = new Prospect__c();
        String recordTypeId = Schema.SObjectType.Prospect__c.getRecordTypeInfosByName().get('OP - IP').getRecordTypeId();
        if(recordTypeId != NULL){            
            prospect.RecordTypeId = recordTypeId;
            prospect.Name = 'test prospect';
            prospect.Max_Id__c = '1113';
            prospect.Source__c = 'E Prescription';
            insert prospect;
        }
       
        Admission_Acknowledgement__c ack=new Admission_Acknowledgement__c();
        ack.Max_ID__c='1113';
        ack.Admission_Status__c='Admitted';
        insert ack;
        
        billing_summary__c bs=new billing_summary__c();
        bs.Admission_Acknowledgement__c=ack.id;
        insert bs;
        
        String leadRecordType = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('CMP').getRecordTypeId();
        if(leadRecordType != NULL ){
            Lead__c lead = new Lead__c();
            lead.RecordTypeId = leadRecordType;
            lead.Name = 'test lead';
            lead.Max_ID__c = '1113';                       
            insert lead;
        }
        
        String leadDCARecordType = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Digital Customer Acquisition').getRecordTypeId();
        if(leadDCARecordType != NULL ){
            Lead__c lead = new Lead__c();
            lead.RecordTypeId = leadDCARecordType;
            lead.Name = 'test lead';
            lead.Max_ID__c = '223'; 
            lead.Mobile_Phone__c = '123456788';            
            insert lead;
        }
        test.setCreatedDate(ack.id, date.newInstance(2022, 02, 14) );
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();        
        req.requestURI = '/services/apexrest/createeprescription/';
        req.httpMethod = 'POST';
        req.requestBody = blob.valueOf('{"PatientName" : "Test","callCenterIds" : "1235","pcl_visitid" : "56ffy","ID" : "5","doctorId" : "45","DoctorName":"test","MaxID":"1113","Birthdate" : "2019-02-26","patientId" : "56","OPBillNo" : "78","ProcedureName" : "Test","PrescriptionDate" : "2019-03-12","SpecializationId" : "12","Specialization" : "Test","DepartmentId" : "78","DepartmentName" : "Test","Gender" : "Female","DiscountReason" : "Test","Mobile" : "123456788","VisitDate" : "2019-02-18","PayerChannel" : "Cash","SSN" : "DTR56","LocationCode" : "F787","AdmissionAdvised" : "Yes", "PrescriptionAdvice":true,"IsInternational":true}');
        RestContext.request = req;
        RestContext.response= res;                           
        
        EPrescriptionLeadCreation.doEPrescriptionLead();
        EPrescriptionLeadCreation.RequestBody requestBody = new EPrescriptionLeadCreation.RequestBody();
        
        req.requestBody = blob.valueOf('{"PatientName" : "Test","pcl_visitid" : "56ffy","ID" : "5","doctorId" : "45","DoctorName":"test","MaxID":"113","Birthdate" : "2019-02-26","patientId" : "56","OPBillNo" : "78","ProcedureName" : "Test","PrescriptionDate" : "2019-03-12","SpecializationId" : "12","Specialization" : "Test","DepartmentId" : "78","DepartmentName" : "Test","Gender" : "Female","DiscountReason" : "Test","Mobile" : "123456788","VisitDate" : "2019-02-18","PayerChannel" : "Cash","SSN" : "DTR56","LocationCode" : "F787","AdmissionAdvised" : "Yes"}');
        EPrescriptionLeadCreation.doEPrescriptionLead();   
        
        req.requestBody = blob.valueOf('{"PatientName" : "Test","pcl_visitid" : "56ffy","ID" : "5","doctorId" : "45","DoctorName":"test","MaxID":"223","HospitalLocation" : "bunit","Birthdate" : "2019-02-26","patientId" : "56","OPBillNo" : "78","ProcedureName" : "Test","PrescriptionDate" : "2019-03-12","SpecializationId" : "12","Specialization" : "Test","DepartmentId" : "78","DepartmentName" : "Test","Gender" : "Female","DiscountReason" : "Test","Mobile" : "123456788","VisitDate" : "2019-02-18","PayerChannel" : "Cash","SSN" : "DTR56","LocationCode" : "F787","AdmissionAdvised" : "Yes"}');
        EPrescriptionLeadCreation.doEPrescriptionLead();   

       
        req.requestBody = blob.valueOf('{"PatientName" : "","pcl_visitid" : "yi78","HospitalLocation" : "bunit"}');
        EPrescriptionLeadCreation.doEPrescriptionLead();   
        
        req.requestBody = blob.valueOf('{"PatientName" : "Test","Mobile" : "123456788","pcl_visitid" : "","HospitalLocation" : "bunit","AdmissionAdvised" : "Yes"}}');
        EPrescriptionLeadCreation.doEPrescriptionLead();     
        
        req.requestBody = blob.valueOf('{"PatientName" : "","pcl_visitid" : "","HospitalLocation" : "","AdmissionAdvised" : "Yes"}}');
        EPrescriptionLeadCreation.doEPrescriptionLead();  
        
        req.requestBody = blob.valueOf('{"PatientName" : "Test","Mobile" : "123456788","pcl_visitid" : "778","HospitalLocation" : "Agra","AdmissionAdvised" : "Yes"}}');
        EPrescriptionLeadCreation.doEPrescriptionLead();     
        
        req.requestBody = blob.valueOf('{"PatientName" : "Test","pcl_visitid" : "778","Gender":"Male","HospitalLocation" : "Agra","AdmissionAdvised" : "Yes"}}');
        EPrescriptionLeadCreation.doEPrescriptionLead();
        
        
        
        
    }
}