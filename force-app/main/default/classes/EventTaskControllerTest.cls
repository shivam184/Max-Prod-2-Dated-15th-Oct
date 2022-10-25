@isTest
public class EventTaskControllerTest {
    @isTest
    public static void test1(){
        lead__c ld = new lead__c();
        ld.name='test lead';
        ld.Last_Name__c='lead';
        insert ld;
        
        Event even = new Event();
        even.WhatId=ld.id;
        even.ActivityDate=system.today();
        even.Subject='Call';
        even.DurationInMinutes=5;
        even.ActivityDateTime=system.now();
        insert even;
        
        Task tas = new Task();
        tas.WhatId=ld.id;
        tas.ActivityDate=system.today();
        tas.Subject='Call';
        insert tas;
        
        EventTaskController.onComLoad();
        EventTaskController.save(system.today());
        
        
    }

}