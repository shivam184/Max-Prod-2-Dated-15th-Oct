@isTest
public class generatePaymentLinkTest{

    @isTest
    public static void test(){
        Max_at_Home_Enquiry_Page__c mhep = new Max_at_Home_Enquiry_Page__c(Call__c = 'Open',Payment_Mode__c='Online', Name__c = 'test1',Stage__c='Open', Covid_Tested__c='No', Age__c=31);
        insert mhep;
        
        String returnValue = generatePaymentLink.sendPaymentLink(mhep.id);
        
        Date dob = Date.newInstance(2016, 12, 9);
        
        Max_at_Home_Enquiry_Page__c isoLead = new Max_at_Home_Enquiry_Page__c(Call__c = 'Open', Name__c = 'test2', Covid_Tested__c='No', Age__c=31, 
                                                                              Patient_DOB__c=dob, Stage__c='Converted', Address__c='new Delhi',Payment_Mode__c='Online');
        insert isoLead;
        
        String leadIdStr = String.valueOf(isoLead.id);
        //test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockClass());
            generatePaymentLink.sendPaymentLink(mhep.id);
            generatePaymentLink.sendPaymentLink(leadIdStr);
        //test.stopTest();


        
    }
}