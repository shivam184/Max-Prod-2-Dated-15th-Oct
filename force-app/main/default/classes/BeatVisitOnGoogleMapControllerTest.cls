@isTest
public class BeatVisitOnGoogleMapControllerTest {
    @isTest
    static void test1(){
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        List<User> uList = new List<User>();
        
        User u1 = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                           EmailEncodingKey='UTF-8', LastName='Test1', LanguageLocaleKey='en_US', 
                           LocaleSidKey='en_US', ProfileId = p.Id, 
                           TimeZoneSidKey='America/Los_Angeles', UserName='asa@ty.com');
        
       insert u1;
        System.runAs(u1){
            User u2 = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                               EmailEncodingKey='UTF-8', LastName='Test2', LanguageLocaleKey='en_US', 
                               LocaleSidKey='en_US', ProfileId = p.Id, 
                               TimeZoneSidKey='America/Los_Angeles', UserName='sasac@mde.com',managerId = u1.Id);
            
            uList.add(u2);
            insert uList;
            
            Account acc = new Account();
            acc.Name ='test';
            acc.Country__c='India';
            acc.City__c='Noida';
            acc.OwnerId=u1.Id;            
            insert acc;
            
            Beat_Day__c bd = new Beat_Day__c();  
            bd.Day_Start_Address__c='sector 2,Noida';
            bd.Day_End_Address__c = 'Sector 15,Noida';        
            insert bd;                                
            
            Beat_Visit__c beat = new Beat_Visit__c();
            beat.Checkin_Date_Time__c=system.today();
            beat.Beat_Day__c=bd.Id;    
            beat.Account__c=acc.Id;
            beat.Checkin_Location__Latitude__s=28.535517;
            beat.Checkin_Location__Longitude__s=77.391029;
            beat.Checkin_Address__c='sector 16,Noida';
            beat.Checkout_Date_Time__c=system.today();
            insert beat;
            
            date sdate=system.today().addDays(-7);
            date edate=system.today().addDays(7);
            String startdate=String.valueOf(sdate);
            String enddate=String.valueOf(edate);     
            
            String u=String.valueOf(uList.indexOf(u1));
            String v=String.valueOf(uList.indexOf(u2));
            
            BeatVisitOnGoogleMapController.fetchUserList();       
            BeatVisitOnGoogleMapController.getUserAndDateDetails(u,startdate,enddate);
            BeatVisitOnGoogleMapController.getUserAndDateDetails(v,startdate,enddate);
        }
        
    }
}