@isTest
public class CreateLeadAndLineItemTest {
    @isTest
    public static void runTest(){
        
        
        test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/OptoOpLeads/*';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof('{ "LEADINFO": [{ "MAXID": "EHPG.710028", "DOCTORID": "4321", "CHANNEL": "EWS", "NAME": "TESTOP2OP", "OPDDATE": "2019-12-12", "VISITID": "1234", "VISITDATE": "2019-12-13", "PATIENTTYPE": "OP", "UNITID": "14", "RECOMENDEDTEST": [{ "SERVICEID": "30", "TESTID": "6086", "TESTNAME": "TestName", "TESTMRP": "420" }, { "SERVICEID": "93", "TESTID": "6086", "TESTNAME": "TestName", "TESTMRP": "420" }]  }]}');
        res.addHeader('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response= res;
        CreateLeadAndLineItem.doCreate(); 
        test.stopTest();
    }

}