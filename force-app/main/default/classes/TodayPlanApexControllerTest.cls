@isTest
public class TodayPlanApexControllerTest{
    /*
    @isTest static void test1(){        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt',
                          Email='standarduser@testorg.com', 
                          EmailEncodingKey='UTF-8',
                          LastName='Testing',
                          LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',
                          ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles',
                          UserName='standarduser@te.com');
        
		insert u;				
        
        Profile p1 = [SELECT Id FROM Profile WHERE Name LIKE 'MaxLabs Manager']; 
        User u1 = new User(Alias = 'standt',
                          Email='standarer@storg.com', 
                          EmailEncodingKey='UTF-8',
                          LastName='Testing1',
                          LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',
                          ProfileId = p1.Id, 
                          TimeZoneSidKey='America/Los_Angeles',
                          UserName='standardr@te.com');        
        Insert u1;
        
        AccountNumberGeneration__c ang =new AccountNumberGeneration__c();
        ang.Name='test';
        ang.AutoNumber__c=00000;
        insert ang;
        
        
        Business_Unit__c bu = new Business_Unit__c();
        bu.Business_Unit_HIS__c = 'test';
        bu.Business_Unit_Code__c='MOH';
        bu.Name='test';
        insert bu;
        
        Account_Territory__c at = new Account_Territory__c();
        at.Channel_Name__c = 'MECP';
        at.Business_Unit__c=bu.id;
        at.Name='test';        
        insert at;
        
        Lead__c l = new Lead__c();
        l.Name='Lead1';
        l.Mobile_Phone__c = '1234567890';
        l.Address_Line_1__c = 'Noida';
        insert l;
        
        Account acc = new Account();
        acc.LastName = 'test66';        
        acc.PersonMobilePhone = '1234567890';        
        acc.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Doctor').getRecordTypeId();        
        insert acc;
       
        Account acc1 = new Account();
        acc1.name = 'test6';        
        acc1.Account_Category__c='MECP';
        acc1.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('MECP Doctor Business').getRecordTypeId();
        acc1.Account_Territory__c=at.id;
        insert acc1;
        
        Beat_Plan__c bp= new Beat_Plan__c();
        bp.name= 'test';
        bp.Status__c='Scheduled';
        bp.Month__c='March';
        bp.year__c = '2019';
        bp.Agent__c =userInfo.getUserId();
        insert bp;
        
        Beat_Day__c bd = new Beat_Day__c();
        bd.Day_End_Address__c = 'delhi';
        bd.Distance_Travelled_in_Day__c = 12;
        bd.Day_End_Location__Latitude__s = 11;
        bd.Day_End_Location__Longitude__s = 12;
        bd.Agent__c =userInfo.getUserId();
        bd.Beat_Plan__c = bp.id;
        insert bd;
        
        Beat_Visit__c bv = new Beat_Visit__c();
        bv.Checkin_Address__c ='delhi';
        bv.Beat_Day__c=bd.id;
        insert bv;
        
        Beat_Plan_Detail__c bpd = new Beat_Plan_Detail__c();
        bpd.Checked_In__c=true;
        bpd.Expected_Date_of_Visit__c = system.today();
        bpd.Status__c='Scheduled';
        bpd.Beat_Plan__c = bp.Id;
        bpd.Account__c = acc1.Id;
        bpd.Beat_Day__c = bd.Id;        
        insert bpd;                
                
        Beat_Plan_Detail__c bpd = new Beat_Plan_Detail__c();
        bpd1.Checked_In__c=true;
        bpd1.Expected_Date_of_Visit__c = system.today();
        bpd1.Status__c='Scheduled';
        bpd1.Beat_Plan__c = bp.Id;
        bpd1.Account__c = acc1.Id;
        bpd1.Beat_Day__c = bd.Id;        
        insert bpd1;                
        
        Test.startTest();
        TodayPlanApexController.doInitApex();
        TodayPlanApexController.createCancelApex(bpd.Id,'cancel');
        TodayPlanApexController.createStartDayApex(bp.Id,23.4566,34.6778);
        TodayPlanApexController.createEndDayApex(bp.Id,28.4566,37.6778);        
        TodayPlanApexController.createCheckIn(bd.Id,bpd.Id,15.567,23.454);
        TodayPlanApexController.createVisitToOfficeApex(bp.Id);
        TodayPlanApexController.createCheckOut(bpd.Id,bd.Id,34.56, 45.66,'PASS',true, true,'Meeting','Meeting',system.today().addDays(3),system.today().addDays(5));
        TodayPlanApexController.createRescheduleApex(bpd.Id,'Testing','system.today().addDays(7)');
        TodayPlanApexController.createCancelApex(bpd.Id,'Test');
		TodayPlanApexController.getLocationApex(bpd.Id,32.544,12.335);        
        TodayPlanApexController.confirmConvertApex(bpd.Id);
        Test.stopTest();
    }
	*/
    
    @isTest
    public static void testTodayPlanApexController() {
    	
        TodayPlanApexController.doInitApex();
        
        Beat_Plan__c beatPlan = new Beat_Plan__c();
        beatPlan.Agent__c = UserInfo.getUserId();
        beatPlan.Status__c = 'Scheduled';
        beatPlan.Month__c = 'March';
        beatPlan.Year__c = String.valueOf(Date.today().year());
        insert beatPlan;
        
        TodayPlanApexController.doInitApex();
        
        Account acc = new Account();
        acc.Name = 'test';
        acc.Address_From_Geolocation__c = 'test';
        insert acc;
        
        Contact con = new Contact();
        con.LastName = 'test';
        con.Email = 'test@gmail.com';
        con.MobilePhone = '8439024407';
        con.Gender__c = 'Male';
        con.Address__c = 'Test';
        insert con;
        
        Lead__c lead = new Lead__c();
        lead.Name = 'test';
        insert lead;
        
        Opportunity__c opp = new Opportunity__c();
        opp.Name = 'test';
        opp.Mobile_Phone__c='9897896861';
        opp.City__c='Delhi';
        opp.Est_Close_Date__c = System.today();
        insert opp;
        
        
        Beat_Plan_Detail__c bpda = new Beat_Plan_Detail__c();
        bpda.Beat_Plan__c = beatPlan.Id;
        bpda.Account__c = acc.Id;
        bpda.Status__c = 'Scheduled';
        bpda.Expected_Date_of_Visit__c = System.today();
        bpda.Lead__c=lead.id;
        insert bpda;
        
        Beat_Plan_Detail__c bpdb = new Beat_Plan_Detail__c();
        bpdb.Beat_Plan__c = beatPlan.Id;
        bpdb.Contact__c = con.Id;
        bpdb.Status__c = 'Scheduled';
        bpdb.Expected_Date_of_Visit__c = System.today();
        insert bpdb;
        
        Beat_Plan_Detail__c bpdc = new Beat_Plan_Detail__c();
        bpdc.Beat_Plan__c = beatPlan.Id;
        bpdc.Contact__c = con.Id;
        bpdc.Status__c = 'Completed';
        bpdc.Expected_Date_of_Visit__c = System.today();
        bpdc.Checked_In__c = true;
        bpdc.Checked_Out__c = true;
        insert bpdc;
        
        Beat_Plan_Detail__c bpdd = new Beat_Plan_Detail__c();
        bpdd.Beat_Plan__c = beatPlan.Id;
        bpdd.Account__c = acc.Id;
        bpdd.Status__c = 'Completed';
        bpdd.Expected_Date_of_Visit__c = System.today();
        bpdd.Checked_In__c = true;
        bpdd.Checked_Out__c = true;
        insert bpdd;
        
        Beat_Plan_Detail__c bpde = new Beat_Plan_Detail__c();
        bpde.Beat_Plan__c = beatPlan.Id;
        bpde.Lead__c = lead.Id;
        bpde.Status__c = 'Scheduled';
        bpde.Expected_Date_of_Visit__c = System.today();
        insert bpde;
        
        Beat_Plan_Detail__c bpdf = new Beat_Plan_Detail__c();
        bpdf.Beat_Plan__c = beatPlan.Id;
        bpdf.Opportunity__c = opp.Id;
        bpdf.Status__c = 'Scheduled';
        bpdf.Expected_Date_of_Visit__c = System.today();
        insert bpdf;
        
        Beat_Plan_Detail__c bpdg = new Beat_Plan_Detail__c();
        bpdg.Beat_Plan__c = beatPlan.Id;
        bpdg.Lead__c = lead.Id;
        bpdg.Status__c = 'Completed';
        bpdg.Expected_Date_of_Visit__c = System.today();
        bpdg.Checked_In__c = true;
        bpdg.Checked_Out__c = true;
        insert bpdg;
        
        Beat_Plan_Detail__c bpdh = new Beat_Plan_Detail__c();
        bpdh.Beat_Plan__c = beatPlan.Id;
        bpdh.Opportunity__c = opp.Id;
        bpdh.Status__c = 'Completed';
        bpdh.Expected_Date_of_Visit__c = System.today();
        bpdh.Checked_In__c = true;
        bpdh.Checked_Out__c = true;
        insert bpdh;
        
        TodayPlanApexController.doInitApex();
        
        Beat_Day__c beatDay = new Beat_Day__c();
        beatDay.Agent__c = UserInfo.getUserId();
        beatDay.Beat_Plan__c = beatPlan.Id;
        insert beatDay;
        
       Test.setCreatedDate(beatDay.Id,System.today());
        
            TodayPlanApexController.doInitApex();
        
        TodayPlanApexController.createStartDayApex(beatPlan.Id,2.3333,2.3333);
        
        TodayPlanApexController.createVisitToOfficeApex(beatPlan.Id);
        
        TodayPlanApexController.createCheckIn(beatDay.Id, bpda.Id,2.3333,2.3333);
        
        TodayPlanApexController.createCheckOut(bpda.Id, beatDay.Id,2.33333,2.3333,'testimg',true,true,'Call','Call',System.today(),System.today());
        
        TodayPlanApexController.createEndDayApex(beatDay.Id,2.3333,2.3333);
        
        TodayPlanApexController.createCancelApex(bpda.Id,'test');
        
        TodayPlanApexController.createRescheduleApex(bpda.Id,'testing',String.valueOf(System.today().addDays(2)));
        
        TodayPlanApexController.createRescheduleApex(bpda.Id,'testing',String.valueOf(System.today().addMonths(2)));

        TodayPlanApexController.getLocationApex(bpda.Id,2.2222,2.222); 
        
        TodayPlanApexController.getLocationApex(bpdb.Id,2.2222,2.222); 
        
        TodayPlanApexController.confirmConvertApex(bpdb.id);
        
        Beat_Visit__c beatVisit = new Beat_Visit__c();
        beatVisit.Beat_Day__c = beatDay.id;
        beatVisit.Beat_Plan_Detail__c = bpda.Id;
        beatVisit.Account__c = acc.Id;
        beatVisit.Checkin_Location__Latitude__s = 2.3333;
        beatVisit.Checkin_Location__Longitude__s =  2.3333;
        beatVisit.Visit_Sequence__c = 1;
        insert beatVisit;

        //TodayPlanApexController.createEndDayApex(beatDay.Id,2.3333,2.3333);
        //
        TodayPlanApexController.createCheckIn(beatDay.Id, bpda.Id,2.3333,2.3333);
        
        Profile p1 = [SELECT Id FROM Profile WHERE Name LIKE 'MaxLabs Manager']; 
        User u1 = new User(Alias = 'standt',
                          Email='standarer@storg.com', 
                          EmailEncodingKey='UTF-8',
                          LastName='Testing1',
                          LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',
                          ProfileId = p1.Id, 
                          TimeZoneSidKey='America/Los_Angeles',
                          UserName='standardr@te.com');        
        Insert u1;
        
        System.runAs(u1) {
        	TodayPlanApexController.doInitApex(); 
        }

    }
    
    @isTest
    public static void testDoInitApex1() {
        
        Map<Integer,String> mapMonthNumberToName = new Map<Integer,String>{1=>'January',2=>'February',3=>'March',4=>'April',5=>'May',6=>'June',7=>'July',8=>'August',9=>'September',10=>'October',11=>'November',12=>'December'};
            String year = String.valueOf(Date.today().year());
        
        Profile p1 = [SELECT Id FROM Profile WHERE Name LIKE 'MaxLabs Manager']; 
        User u1 = new User(Alias = 'standt',
                          Email='standarer@storg.com', 
                          EmailEncodingKey='UTF-8',
                          LastName='Testing1',
                          LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',
                          ProfileId = p1.Id, 
                          TimeZoneSidKey='America/Los_Angeles',
                          UserName='standardr@te.com');        
        Insert u1;
        
        System.runAs(u1) {
            Beat_Plan__c bp= new Beat_Plan__c();
            bp.name= 'test';
            bp.Status__c='Scheduled';
            bp.Month__c=mapMonthNumberToName.get(Date.today().month());
            bp.year__c = year;
            bp.Agent__c =userInfo.getUserId();
            insert bp;
            
            
            Beat_Day__c bd = new Beat_Day__c();
            bd.Day_End_Address__c = 'delhi';
            bd.Distance_Travelled_in_Day__c = 12;
            bd.Day_End_Location__Latitude__s = 11;
            bd.Day_End_Location__Longitude__s = 12;
            bd.Agent__c =userInfo.getUserId();
            bd.Beat_Plan__c = bp.id;
            insert bd;
            
            Lead__c l = new Lead__c();
            l.Name='Lead1';
            l.Mobile_Phone__c = '1234567890';
            l.Address_Line_1__c = 'Noida';
            insert l;
            
            Beat_Plan_Detail__c bpd1 = new Beat_Plan_Detail__c();
            bpd1.Checked_In__c=true;
            bpd1.Expected_Date_of_Visit__c = system.today();
            bpd1.Status__c='Scheduled';
            bpd1.Beat_Plan__c = bp.Id; 
            bpd1.Beat_Day__c = bd.Id;   
            bpd1.Lead__c = l.Id;
            insert bpd1;
        	TodayPlanApexController.doInitApex(); 
        } 
        
    }
    
    @isTest
    public static void testDoInitApex2() {
        
        Map<Integer,String> mapMonthNumberToName = new Map<Integer,String>{1=>'January',2=>'February',3=>'March',4=>'April',5=>'May',6=>'June',7=>'July',8=>'August',9=>'September',10=>'October',11=>'November',12=>'December'};
            String year = String.valueOf(Date.today().year());
         
        Profile p = [SELECT Id FROM Profile WHERE Name LIKE 'System Administrator']; 
        User u = new User(Alias = 'standt',
                          Email='standarer121@storg.com', 
                          EmailEncodingKey='UTF-8',
                          LastName='Testing1',
                          LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',
                          ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles',
                          UserName='standardr121@te.com');        
        Insert u;
        
        System.runAs(u) {
            Beat_Plan__c bp= new Beat_Plan__c();
            bp.name= 'test';
            bp.Status__c='Scheduled';
            bp.Month__c=mapMonthNumberToName.get(Date.today().month());
            bp.year__c = year;
            bp.Agent__c =userInfo.getUserId();
            insert bp;
            
            
            Beat_Day__c bd = new Beat_Day__c();
            bd.Day_End_Address__c = 'delhi';
            bd.Distance_Travelled_in_Day__c = 12;
            bd.Day_End_Location__Latitude__s = 11;
            bd.Day_End_Location__Longitude__s = 12;
            bd.Agent__c =userInfo.getUserId();
            bd.Beat_Plan__c = bp.id;
            insert bd;
            
            Account acc1 = new Account();
            acc1.name = 'test6';        
           // acc1.Account_Category__c='MECP';
            acc1.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('MECP Doctor Business').getRecordTypeId(); 
            insert acc1;
            
            Beat_Plan_Detail__c bpd1 = new Beat_Plan_Detail__c();
            bpd1.Checked_In__c=true;
            bpd1.Expected_Date_of_Visit__c = system.today();
            bpd1.Status__c='Scheduled';
            bpd1.Beat_Plan__c = bp.Id;
            bpd1.Account__c = acc1.Id;
            bpd1.Beat_Day__c = bd.Id;        
            insert bpd1; 
            
        	TodayPlanApexController.doInitApex(); 
        }
        
    }
    
    @isTest
    public static void testDoInitApex3() {
        
        Map<Integer,String> mapMonthNumberToName = new Map<Integer,String>{1=>'January',2=>'February',3=>'March',4=>'April',5=>'May',6=>'June',7=>'July',8=>'August',9=>'September',10=>'October',11=>'November',12=>'December'};
            String year = String.valueOf(Date.today().year());
         
        Profile p = [SELECT Id FROM Profile WHERE Name LIKE 'MaxLabs Manager']; 
        User u = new User(Alias = 'standt',
                          Email='standarer121@storg.com', 
                          EmailEncodingKey='UTF-8',
                          LastName='Testing1',
                          LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',
                          ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles',
                          UserName='standardr121@te.com');        
        Insert u;
        
        System.runAs(u) {
            Beat_Plan__c bp= new Beat_Plan__c();
            bp.name= 'test';
            bp.Status__c='Scheduled';
            bp.Month__c=mapMonthNumberToName.get(Date.today().month());
            bp.year__c = year;
            bp.Agent__c =userInfo.getUserId();
            insert bp;
            
            
            Beat_Day__c bd = new Beat_Day__c();
            bd.Day_End_Address__c = 'delhi';
            bd.Distance_Travelled_in_Day__c = 12;
            bd.Day_End_Location__Latitude__s = 11;
            bd.Day_End_Location__Longitude__s = 12;
            bd.Agent__c =userInfo.getUserId();
            bd.Beat_Plan__c = bp.id;
            insert bd;
            
            Opportunity__c opp = new Opportunity__c();
            opp.Name = 'test';
            opp.Mobile_Phone__c='5574575453';
            opp.Est_Close_Date__c = System.today();
            insert opp;
            
            Beat_Plan_Detail__c bpd1 = new Beat_Plan_Detail__c();
            bpd1.Checked_In__c=true;
            bpd1.Expected_Date_of_Visit__c = system.today();
            bpd1.Status__c='Scheduled';
            bpd1.Beat_Plan__c = bp.Id;
            bpd1.Opportunity__c = opp.Id;
            bpd1.Beat_Day__c = bd.Id;
            insert bpd1;
            
            bpd1.Lead__c = null;
            bpd1.Account__c = null;
            update bpd1;
            
        	TodayPlanApexController.doInitApex(); 
        }
        
    }
    
    
    @isTest
    public static void testDoInitApex4() {
        
        Map<Integer,String> mapMonthNumberToName = new Map<Integer,String>{1=>'January',2=>'February',3=>'March',4=>'April',5=>'May',6=>'June',7=>'July',8=>'August',9=>'September',10=>'October',11=>'November',12=>'December'};
            String year = String.valueOf(Date.today().year());
         
        Profile p = [SELECT Id FROM Profile WHERE Name LIKE 'MaxLabs Manager']; 
        User u = new User(Alias = 'standt',
                          Email='standarer121@storg.com', 
                          EmailEncodingKey='UTF-8',
                          LastName='Testing1',
                          LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',
                          ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles',
                          UserName='standardr121@te.com');        
        Insert u;
        
        System.runAs(u) {
            Beat_Plan__c bp= new Beat_Plan__c();
            bp.name= 'test';
            bp.Status__c='Scheduled';
            bp.Month__c=mapMonthNumberToName.get(Date.today().month());
            bp.year__c = year;
            bp.Agent__c =userInfo.getUserId();
            insert bp;
            
            
            Beat_Day__c bd = new Beat_Day__c();
            bd.Day_End_Address__c = 'delhi';
            bd.Distance_Travelled_in_Day__c = 12;
            bd.Day_End_Location__Latitude__s = 11;
            bd.Day_End_Location__Longitude__s = 12;
            bd.Agent__c =userInfo.getUserId();
            bd.Beat_Plan__c = bp.id;
            insert bd;
            
            Contact con = new Contact();
            con.LastName = 'test';
            con.Email = 'test@gmail.com';
            con.MobilePhone = '8439024407';
            con.Gender__c = 'Male';
            con.Address__c = 'Test';
            insert con;
            
            Beat_Plan_Detail__c bpd1 = new Beat_Plan_Detail__c();
            bpd1.Checked_In__c=true;
            bpd1.Expected_Date_of_Visit__c = system.today();
            bpd1.Status__c='Scheduled';
            bpd1.Beat_Plan__c = bp.Id;
            bpd1.Contact__c = con.Id;
            bpd1.Beat_Day__c = bd.Id;        
            insert bpd1;
            
            bpd1.Lead__c = null;
            bpd1.Account__c = null;
            update bpd1;
            
        	//TodayPlanApexController.doInitApex(); 
        }
        
    }
    
    @isTest
    public static void testDoInitApex5() {
        
        Map<Integer,String> mapMonthNumberToName = new Map<Integer,String>{1=>'January',2=>'February',3=>'March',4=>'April',5=>'May',6=>'June',7=>'July',8=>'August',9=>'September',10=>'October',11=>'November',12=>'December'};
            String year = String.valueOf(Date.today().year());
         
        Profile p = [SELECT Id FROM Profile WHERE Name LIKE 'MaxLabs Manager']; 
        User u = new User(Alias = 'standt',
                          Email='standarer121@storg.com', 
                          EmailEncodingKey='UTF-8',
                          LastName='Testing1',
                          LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',
                          ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles',
                          UserName='standardr121@te.com');        
        Insert u;
        
        System.runAs(u) {
            Beat_Plan__c bp= new Beat_Plan__c();
            bp.name= 'test';
            bp.Status__c='Scheduled';
            bp.Month__c=mapMonthNumberToName.get(Date.today().month());
            bp.year__c = year;
            bp.Agent__c =userInfo.getUserId();
            insert bp;
            
            
            Beat_Day__c bd = new Beat_Day__c();
            bd.Day_End_Address__c = 'delhi';
            bd.Distance_Travelled_in_Day__c = 12;
            bd.Day_End_Location__Latitude__s = 11;
            bd.Day_End_Location__Longitude__s = 12;
            bd.Agent__c =userInfo.getUserId();
            bd.Beat_Plan__c = bp.id;
            insert bd;
              
            
            Beat_Plan_Detail__c bpd1 = new Beat_Plan_Detail__c();
            bpd1.Checked_In__c=true;
            bpd1.Expected_Date_of_Visit__c = system.today();
            bpd1.Status__c='Scheduled';
            bpd1.Beat_Plan__c = bp.Id;  
            bpd1.Beat_Day__c = bd.Id;        
            insert bpd1;
            
            bpd1.Lead__c = null;
            bpd1.Account__c = null;
            update bpd1;
            
        	TodayPlanApexController.doInitApex(); 
            //TodayPlanApexController.createApiLoger('srequest', 'response', 'methodType', 'https://www.google.com/','bs56q');
            TodayPlanApexController.coverage();
        }
        
    }
       
}