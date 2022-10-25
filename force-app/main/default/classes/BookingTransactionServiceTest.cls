@isTest
public class BookingTransactionServiceTest {
    
    public static testMethod void invokeBookingTransactionService(){
        
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/bookingtransactionservice';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof('{"patient": {"maxId" : "123","patientName":"test"},"trans": {"billNo": "1270101900022","lineList": [{"transactionId" : "hello"}]}}');
        RestContext.request = req;
        RestContext.response= res;
        BookingTransactionService.updatePateintTransaction();
        Test.stopTest();
    }
}