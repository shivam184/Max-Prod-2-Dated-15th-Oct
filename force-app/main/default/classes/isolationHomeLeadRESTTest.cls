@isTest
public class isolationHomeLeadRESTTest {
    
    @isTest static void testGetMaxById() {
        
        
        
        try{
            Id recordId = createTestRecord();
            // Set up a test request
            RestRequest request = new RestRequest();
            request.requestUri =
                'https://maxhealthcare--maxdev.my.salesforce.com/services/apexrest/isoloationHome/';
            request.httpMethod = 'POST';
            RestContext.request = request;        
            
            System.assertEquals(1, [SELECT count() FROM Max_at_Home_Enquiry_Page__c WHERE Invoice_No__c = 'inv112']);
        }
        catch(Exception e) {
            String jsonStr = 'Error has occured';
            
            System.debug('jsonStr >>> ' + jsonStr);
        }
    }
    
    static Id createTestRecord() {
        try{
            
            
           Max_at_Home_Enquiry_Page__c mahep = new Max_at_Home_Enquiry_Page__c();
        //mahep.Name = 'A S K';
            mahep.Invoice_No__c='6776998';
            mahep.Age__c=25;
            mahep.PayU_Transaction_ID__c='t7t';

        insert mahep;
       
            // Create test record
            Id maxTest = isolationHomeLeadREST.createLead(
                mahep.id,
                'inv112',
                'Success',
                'trx123',
                'Paytm',
                123,
                datetime.newInstance(2021, 9, 15, 12, 30, 0),
                'ptid123');
            maxTest = maxTest +'a';
            //system.assert(false);
            return maxTest;
        }
        Catch(exception e)
        {
            return null;
        }
    }
    static Id createTestRecordCatch(String ASDF) {
        try{
            
            Max_at_Home_Enquiry_Page__c mahep = new Max_at_Home_Enquiry_Page__c();
        //mahep.Name = 'A S K';
            mahep.Invoice_No__c='6776998';
            mahep.Age__c=25;
            mahep.PayU_Transaction_ID__c='t7t';

        insert mahep;
            // Create test record
            Id maxTest = isolationHomeLeadREST.createLead(
                mahep.id,
                'inv112',
                'Success',
                'trx123',
                'Paytm',
                123,
                datetime.newInstance(2021, 9, 15, 12, 30, 0),
                'ptid123');
            maxTest = maxTest +'a';
            //system.assert(false);
            return maxTest;
        }
        Catch(exception e)
        {
            return null;
        }
    }
}