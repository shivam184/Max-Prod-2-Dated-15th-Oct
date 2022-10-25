@isTest
public class PSUTodaysPlantest {
    @isTest
    public static void testTodayPlanApexController() {
    	
        PSUTodayPlanApexController.doInitApex();
                PSUTodayPlanApexController.WrapperClass pws=new PSUTodayPlanApexController.WrapperClass();
        pws.showTodayPlan=true;
        Beat_Plan__c beatPlan = new Beat_Plan__c();
        beatPlan.Agent__c = UserInfo.getUserId();
        beatPlan.Status__c = 'Scheduled';
        beatPlan.Month__c = 'August';
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
        con.MailingStreet='noida';
        con.MailingCity='noida';
        con.MailingCountry='India';
        con.MailingState='up';
        insert con;
        
        Lead__c lead = new Lead__c();
        lead.Name = 'test';
        insert lead;
        
        Opportunity__c opp = new Opportunity__c();
        opp.Name = 'test';
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
        
        PSUTodayPlanApexController.doInitApex();
        
        Beat_Day__c beatDay = new Beat_Day__c();
        beatDay.Agent__c = UserInfo.getUserId();
        beatDay.Beat_Plan__c = beatPlan.Id;
        insert beatDay;
        
       Test.setCreatedDate(beatDay.Id,System.today());
        
            PSUTodayPlanApexController.doInitApex();
        
        PSUTodayPlanApexController.createStartDayApex(beatPlan.Id,2.3333,2.3333);
        
        PSUTodayPlanApexController.createVisitToOfficeApex(beatPlan.Id);
        
        PSUTodayPlanApexController.createCheckIn(beatDay.Id, bpda.Id,2.3333,2.3333);
        
        PSUTodayPlanApexController.createCheckOut(bpda.Id, beatDay.Id,2.33333,2.3333,'testimg',true,true,'Call','Call',System.today(),System.today());
        
        PSUTodayPlanApexController.createEndDayApex(beatDay.Id,2.3333,2.3333);
        
        PSUTodayPlanApexController.createCancelApex(bpda.Id,'test');
        
        PSUTodayPlanApexController.createRescheduleApex(bpda.Id,'testing',String.valueOf(System.today().addDays(2)));
        
        PSUTodayPlanApexController.createRescheduleApex(bpda.Id,'testing',String.valueOf(System.today().addMonths(2)));

        PSUTodayPlanApexController.getLocationApex(bpda.Id,2.2222,2.222); 
        
        PSUTodayPlanApexController.getLocationApex(bpdb.Id,2.2222,2.222); 
        
        PSUTodayPlanApexController.confirmConvertApex(bpdb.id);
        
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
        PSUTodayPlanApexController.createCheckIn(beatDay.Id, bpda.Id,2.3333,2.3333);
        
        Profile p1 = [SELECT Id FROM Profile WHERE Name LIKE 'MaxLabs Manager'];
        //PSU Corporate
        //
       // Profile p1 = [SELECT Id FROM Profile WHERE Name LIKE 'PSU Corporate'];
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
        	PSUTodayPlanApexController.doInitApex();    
        }
        
        PSUTodayPlanApexController.WrapperClass pw=new PSUTodayPlanApexController.WrapperClass();
        pw.showTodayPlan=true;
        pw.showStartDay=true;
        pw.showEndDay=true;
        pw.endDay=true;
        pw.officeVisit=true;
        pw.disabledCheckIn=true;
        
        
        PSUTodayPlanApexController.BeatPlanDetailWrapperClass bpd = new PSUTodayPlanApexController.BeatPlanDetailWrapperClass();
        bpd.name='Test';
        bpd.phoneNo='5857569857';
        bpd.showGeoTagButton=false;
        bpd.showCheckedIn=false;
        bpd.convertToAccount=false;
        
        PSUTodayPlanApexController.CompletedBeatPlanDetailWrapperClass cpdw = new PSUTodayPlanApexController.CompletedBeatPlanDetailWrapperClass();
        cpdw.name='Test';
        cpdw.phoneNo='9696576757';
        cpdw.address='Noida';
        
        PSUTodayPlanApexController.coverage();

    }
    
}