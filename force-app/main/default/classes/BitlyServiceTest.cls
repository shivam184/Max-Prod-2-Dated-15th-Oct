@IsTest
public with sharing class BitlyServiceTest {

    @IsTest
    public static void test_shorten() {

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new BitlyHttpCalloutMock());

        String longURL = 'https://this-is-a-test.example.com';
        String shortURL = BitlyService.shorten(longURL);
		System.debug('shortURL >>> ' + shortURL);
        System.assertEquals('https://www.salesforce.com', shortURL);
        Test.stopTest();
    }
}