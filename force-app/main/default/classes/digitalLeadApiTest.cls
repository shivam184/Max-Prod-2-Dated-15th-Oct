/*created by : Nitya(IRT)
 * Created Date :23rd May 2022
 * Purpose: Common API for Max Digital Process
 */
@isTest
public class digitalLeadApiTest {
@isTest
    public static void test1(){
         RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/MaxDigitalLead';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody=blob.valueOf('{"Data":[{ "Name":"Test","Hospital Location":"ujjain","Description":"this is the description","Email":"nitya.k@dummy.com","Lead Channel":"","Lead Sub Source":"Google","Lead Source":"Website","Campaign":"Contact Us","Specialty":"Urology","Doctor Name":"Dr.xyz","Mobile Phone":"1234567890"}]}');
        
        RestContext.request = req;
        RestContext.response= res;
        test.startTest();
       DigitalLeadApi.createCase();
        test.stopTest();
    }
}