@isTest
public class callDoctorPatientTest{

    
    public static testMethod void test1(){
        Max_at_Home_Enquiry_Page__c mhep = new Max_at_Home_Enquiry_Page__c(Call__c = 'Open',Payment_Mode__c='Online', Name__c = 'test1',Stage__c='Open', Covid_Tested__c='No', Age__c=31);
        insert mhep;
        
        Test.setMock(HttpCalloutMock.class, new MockClass());
        String returnValue = callDoctorPatient.callDoctorPatient(mhep.id);
        System.debug('returnValue >> ' + returnValue);
        System.assertEquals(returnValue, null);
        callDoctorPatient.coverage();
        
    }    
}