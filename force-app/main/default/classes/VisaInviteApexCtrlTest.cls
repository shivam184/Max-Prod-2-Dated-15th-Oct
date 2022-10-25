@ isTest
public class VisaInviteApexCtrlTest {
	@testsetup
	static void setup() {
		//Patient
		Account patient = new Account();
		patient.LastName = 'Test Patient';
		patient.Max_ID__c = 'S124';
		patient.recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId();
		insert patient;

		//Doctor
		String recordTypeIdd = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Doctor').getRecordTypeId();
		Account doctor = new Account();
		doctor.RecordTypeId = recordTypeIdd;
		doctor.LastName = 'Test Doctor';
		doctor.Max_ID__c = 'test123';
		doctor.PersonMobilePhone = '9876543210';
		doctor.PersonEmail = 'test@gm.com';
		insert doctor;

		//HCF
		Account hcf = new Account();
		hcf.Name = 'test';
		hcf.Type = 'MACN';
		hcf.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('International HCF Account').getRecordTypeId();
		insert hcf;

		//Business Unit
		Business_Unit__c bu = new Business_Unit__c();
		bu.Name = 'MAX Saket';
		bu.Business_Unit_HIS__c = 'test MAX';
		bu.HIS_ID__c = '20';
		bu.Business_Unit_Code__c = 'VSH';
		insert bu;

		//Country
		Address_Master__c add = new Address_Master__c();
		add.Name = 'Nigeria/Lagos';
		add.Capital__c = 'Lagos';
		add.RecordtypeId = Schema.SObjectType.Address_Master__c.getRecordTypeInfosByName().get('Country').getRecordTypeId();
		insert add;

		//Visa Invites
		Visa_Invite__c inv = new Visa_Invite__c();
		inv.Hospital_Location__c = bu.Id;
		inv.Passport_number__c = '125485';
		inv.HCF_Partner_name__c = hcf.Id;
		inv.Country__c = add.id;
		inv.Customer_Patient_Name__c = 'test';
        inv.Doctor_Name__c=doctor.Id;
        inv.Visa_Invite_Number__c = '2020/Mar/693753/v1.1';
        inv.Ailment__c = 'test';
        inv.Gender__c ='Male';
        inv.Sub_HCF_Name__c ='Test';
        inv.HCF_Mobile_No__c ='123456789';
        inv.Recipient_Email__c ='test@test.com';
        inv.Recipient_City__c ='Delhi';
        inv.Type_of_Visa__c='Donor';
		insert inv;

		Id attendeeRTId = Schema.SObjectType.Attendant_Detail__c.getRecordTypeInfosByDeveloperName().get('Attendee').getRecordTypeId();
		//Attendants
		Attendant_Detail__c attendant = new Attendant_Detail__c();
		attendant.Name = 'Attendant';
		attendant.Visa_Invite__c = inv.id;
		attendant.Passport_number__c = '125485';
		attendant.RecordTypeId = attendeeRTId;
		attendant.Relation__c = 'Mother';
		Insert attendant;

		Attendant_Detail__c attendant1 = new Attendant_Detail__c();
		attendant1.Name = 'Attendant';
		attendant1.Visa_Invite__c = inv.id;
		attendant1.RecordTypeId = attendeeRTId;
		attendant1.Passport_number__c = '125485';
		attendant1.Relation__c = 'Father';
		Insert attendant1;
        
        

		//Donor
		Id donorRTId = Schema.SObjectType.Attendant_Detail__c.getRecordTypeInfosByDeveloperName().get('Donor').getRecordTypeId();
		Attendant_Detail__c donor = new Attendant_Detail__c();
		donor.Name = 'Donor';
		donor.Visa_Invite__c = inv.id;
		donor.RecordTypeId = donorRTId;
		donor.Passport_number__c = '125485';
		donor.Relation__c = 'Father';
		Insert donor;

		//Document
		ContentVersion cv = new ContentVersion();
		cv.Title = 'Max/PPG/';
		cv.PathOnClient = 'Max/PPG.pdf';
		cv.VersionData = Blob.valueOf('Test Content');
		cv.IsMajorVersion = true;
		Insert cv;

		//Get Content Version
		List<ContentVersion> cvList = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];
		System.assertEquals(cvList.size(), 1);

		//Get Content Documents
		List<ContentDocument> cdList = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];


	}

	static testmethod void getVisaInviteTest() {
		List<Visa_Invite__c> LstVIsa = [Select Id, Passport_number__c From Visa_Invite__c];
		Test.startTest();
		VisaInviteApexCtrl.getVisaInvite(LstVIsa [0].Passport_number__c, true);
		test.stopTest();
	}


	static testmethod void getAttedeeRelatedToVisaInviteTest() {
		List<Visa_Invite__c> LstVIsa = [Select Id, Passport_number__c From Visa_Invite__c];
		Test.startTest();
		VisaInviteApexCtrl.getAttedeeRelatedToVisaInvite(LstVIsa [0].Id, true, true, true);
		Test.stopTest();

	}

	static testmethod void insertAttedeeRelatedToVisaInviteTest() {
		List<Visa_Invite__c> LstVIsa = [Select Id, Passport_number__c From Visa_Invite__c];
		Attendant_Detail__c attendant = new Attendant_Detail__c();
		attendant.Name = 'Attendant1';
		attendant.Visa_Invite__c = LstVIsa [0].id;
		attendant.Passport_number__c = '125485';
		attendant.Relation__c = 'Mother';

		Attendant_Detail__c donor = new Attendant_Detail__c();
		donor.Name = 'donor1';
		donor.Passport_number__c = '125485';
		donor.Visa_Invite__c = LstVIsa [0].id;
		donor.Relation__c = 'Mother';

		Test.startTest();
		VisaInviteApexCtrl.insertAttedeeRelatedToVisaInvite(attendant, 'Attendee');
		VisaInviteApexCtrl.insertAttedeeRelatedToVisaInvite(donor, 'Donor');
		test.stopTest();
	}

	static testmethod void updateAttendantDetailsTest() {
		List<Attendant_Detail__c> attendantList = [Select Id, Name From Attendant_Detail__c];
		Test.startTest();
		VisaInviteApexCtrl.updateAttendantDetails(attendantList);
		test.stopTest();
	}

	static testmethod void deleteAttendantDetailTest() {
		List<Attendant_Detail__c> attendantList = [Select Id, Name From Attendant_Detail__c];
		Test.startTest();
		VisaInviteApexCtrl.deleteAttendantDetail(attendantList [0]);
        try{
        VisaInviteApexCtrl.deleteAttendantDetail(attendantList [0]);
        }catch(Exception e){
            
        }
		test.stopTest();
	}

	static testmethod void deleteAttachmentFileTest() {
		List<ContentVersion> cvList = [Select Id From ContentVersion];
		Test.startTest();
        if(cvList.size()>0)
		VisaInviteApexCtrl.deleteAttachmentFile(cvList [0].Id);
		test.stopTest();
	}

	static testmethod void getVisaInviteAllInfoTest() {
		List<Visa_Invite__c> LstVIsa = [Select Id, Passport_number__c From Visa_Invite__c];
		Test.startTest();
		VisaInviteApexCtrl.getVisaInviteAllInfo(LstVIsa [0].Id);
		test.stopTest();

	}

	static testmethod void generatePdfAndSaveTest() {
		List<Visa_Invite__c> LstVIsa = [Select Id, Passport_number__c From Visa_Invite__c];
		Test.startTest();
		VisaInviteApexCtrl.generatePdfAndSave(LstVIsa [0].Id, 'test',true,'test');
		Test.stopTest();
	}

	static testmethod void sendvisainvitemailTest() {
		List<Visa_Invite__c> LstVIsa = [Select Id, Passport_number__c From Visa_Invite__c];
		Test.startTest();
		VisaInviteApexCtrl.sendvisainvitemail(LstVIsa[0].Id, 'test@gmail.com','nitya.k@cloud-icon.com', 'dummy@gmail.com');
		Test.stopTest();
	}
 
/*
	static testmethod void GenerateTemplatePDFControllerTest() {
		List<Visa_Invite__c> LstVIsa = [Select Id, Passport_number__c From Visa_Invite__c where Passport_number__c = '125485' limit 1];
		Test.startTest();
		PageReference pageRef = Page.GenerateTemplatePDF;
		Test.setCurrentPage(pageRef);
		pageRef.getParameters().put('id', LstVIsa [0].Id);

		GenerateTemplatePDFController pdf = new GenerateTemplatePDFController();
		pdf.footerimg = '';
		pdf.bottomImgURL = '';
		pdf.bottomImageset = new List<String>();
		pdf.invitefromaddress = '';
		String templateBodyPreview = pdf.templateBodyPreview;


		Test.stopTest();
	}*/
}