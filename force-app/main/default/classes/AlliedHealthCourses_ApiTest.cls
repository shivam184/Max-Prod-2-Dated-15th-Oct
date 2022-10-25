@isTest
public class AlliedHealthCourses_ApiTest {
    @isTest
    public static void test1(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/AlliedHealthCoursesLeads';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody=blob.valueOf('[{"attributes":{"type":"Allied_Healthcare_Courses__c", "referenceId":"1234"},"Student_Name__c":"Nitya","Contact_No__c":"1234567890","Course_Interested_In__c":"B.Sc. Medical Laboratory Technology","Preferred_Centre__c":"Max Healthcare Education, Vaishali","Email_Id__c":"nitya.k@cloud-icon.com", "Description__c":"Type your query here"}, {"attributes":{"type":"Allied_Healthcare_Courses__c", "referenceId":"12324"},"Student_Name__c":"NityaTest", "Contact_No__c":"1234567890","Course_Interested_In__c":"B.Sc. Medical Laboratory Technology","Preferred_Centre__c":"Max Healthcare Education, Vaishali","Email_Id__c":"nitya.k@cloud-icon.com","Description__c":"Type your query here" }]');
        
        RestContext.request = req;
        RestContext.response= res;
        test.startTest();
        AlliedHealthCourses_api.insertAlliedHealthcourses();
        test.stopTest();
    }
    @isTest
    public static void test2(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/AlliedHealthCoursesLeads';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody=blob.valueOf('[{"attributes":{"type":"Allied_Healthcare_Courses__c", "referenceId":"1234"},"Id":"a012345678909","Student_Name__c":"Nitya","Contact_No__c":"1234567890","Course_Interested_In__c":"B.Sc. Medical Laboratory Technology","Preferred_Centre__c":"Max Healthcare Education, Vaishali","Email_Id__c":"nitya.k@cloud-icon.com", "Description__c":"Type your query here"}, {"attributes":{"type":"Allied_Healthcare_Courses__c", "referenceId":"12324"},"Student_Name__c":"NityaTest", "Contact_No__c":"1234567890","Course_Interested_In__c":"B.Sc. Medical Laboratory Technology","Preferred_Centre__c":"Max Healthcare Education, Vaishali","Email_Id__c":"nitya.k@cloud-icon.com","Description__c":"Type your query here" }]');
        
        RestContext.request = req;
        RestContext.response= res;
        test.startTest();
        AlliedHealthCourses_api.insertAlliedHealthcourses();
        test.stopTest();
    }
    
}