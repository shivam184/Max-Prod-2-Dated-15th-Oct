@isTest
public class GetLocationApexTest {
 @isTest
    public static void runTest(){
        Account acc=new Account();
        acc.Name='TestAccount';
        insert acc;
        
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockClass());
        GetLocationApex.fetchLocationAddress(25.6666666,13.666666);
        GetLocationApex.saveLocationApex(acc.Id, 25.6666666, 13.666666,'Sector2');
        GetLocationApex.saveBillingLocationApex(acc.Id,25.6666666,13.666666,'Sector2','20','Noida','UP','India', '202002');
        //GetLocationApex.getLocationFromBillingAddress('Noida');
        test.stopTest();
    }
    @isTest
    public static void runTest1(){
        Account acc=new Account();
        acc.Name='TestAccount';
        insert acc;
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockClass());
        GetLocationApex.getLocationFromBillingAddress('Sector2');
        test.stopTest();
    }
}