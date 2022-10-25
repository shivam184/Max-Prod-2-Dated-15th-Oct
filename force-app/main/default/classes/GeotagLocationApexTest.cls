@isTest
public class GeotagLocationApexTest {
    
    @isTest static void testMe(){
        Customer_Activation__c ca = new Customer_Activation__c();
        ca.Location1__Latitude__s = 15;
        ca.Location1__Longitude__s = 20;        
        insert ca;
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new GeotagLocationMock());        
        GeotagLocationApex.saveDataApex(15.5,20.2,ca.Id);               
        
        Test.setMock(HttpCalloutMock.class, new GeotagLocationMock());        
        GeotagLocationApex.saveDataApex(15.5,20.2,'0');               
        test.stoptest();
        
        
    }
}