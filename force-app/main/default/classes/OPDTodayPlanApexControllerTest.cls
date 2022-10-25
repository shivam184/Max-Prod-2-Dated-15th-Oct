@istest
public class OPDTodayPlanApexControllerTest {
    
    @isTest
    public static void OPDTodayPlanApexControllerTest() {
        
        OPDTodayPlanApexController.doInitApex();
                
        Beat_Plan__c beatPlan = new Beat_Plan__c();
        beatPlan.Agent__c = UserInfo.getUserId();
        beatPlan.Status__c = 'Scheduled';
        beatPlan.Month__c = 'March';
        beatPlan.Year__c = String.valueOf(Date.today().year());
        insert beatPlan;
        
        OPDTodayPlanApexController.doInitApex();
        
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
        
        OPDTodayPlanApexController.doInitApex();
        
        Beat_Day__c beatDay = new Beat_Day__c();
        beatDay.Agent__c = UserInfo.getUserId();
        beatDay.Beat_Plan__c = beatPlan.Id;
        insert beatDay;
        
        Test.setCreatedDate(beatDay.Id,System.today());
        
        OPDTodayPlanApexController.doInitApex();
        
        OPDTodayPlanApexController.createStartDayApex(beatPlan.Id,2.3333,2.3333);
        
        OPDTodayPlanApexController.createVisitToOfficeApex(beatPlan.Id);
        
        OPDTodayPlanApexController.createCheckIn(beatDay.Id, bpda.Id,2.3333,2.3333);
        
        OPDTodayPlanApexController.createCheckOut(bpda.Id, beatDay.Id,2.33333,2.3333,'testimg',true,true,'Call','Call',System.today(),System.today());
        
        OPDTodayPlanApexController.createEndDayApex(beatDay.Id,2.3333,2.3333);
        
        OPDTodayPlanApexController.createCancelApex(bpda.Id,'test');
        
        OPDTodayPlanApexController.createRescheduleApex(bpda.Id,'testing',String.valueOf(System.today().addDays(2)));
        
        OPDTodayPlanApexController.createRescheduleApex(bpda.Id,'testing',String.valueOf(System.today().addMonths(2)));
        
        OPDTodayPlanApexController.getLocationApex(bpda.Id,2.2222,2.222); 
        
        OPDTodayPlanApexController.getLocationApex(bpdb.Id,2.2222,2.222); 
        
        OPDTodayPlanApexController.confirmConvertApex(bpdb.id);
        
        Beat_Visit__c beatVisit = new Beat_Visit__c();
        beatVisit.Beat_Day__c = beatDay.id;
        beatVisit.Beat_Plan_Detail__c = bpda.Id;
        beatVisit.Account__c = acc.Id;
        beatVisit.Checkin_Location__Latitude__s = 2.3333;
        beatVisit.Checkin_Location__Longitude__s =  2.3333;
        beatVisit.Visit_Sequence__c = 1;
        insert beatVisit;
        
        //OPDTodayPlanApexController.createEndDayApex(beatDay.Id,2.3333,2.3333);
        //
        OPDTodayPlanApexController.createCheckIn(beatDay.Id, bpda.Id,2.3333,2.3333);
        
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
            OPDTodayPlanApexController.doInitApex();    
        }
        
        Profile p2 = [SELECT Id FROM Profile WHERE Name LIKE '%MECP - Sales%' limit 1]; 
        User u2 = new User(Alias = 'srj',
                           Email='srj@storg.com', 
                           EmailEncodingKey='UTF-8',
                           LastName='grg',
                           LanguageLocaleKey='en_US', 
                           LocaleSidKey='en_US',
                           ProfileId = p2.Id, 
                           TimeZoneSidKey='America/Los_Angeles',
                           UserName='srj@te.com');        
        Insert u2;
        
        System.runAs(u2) {
            OPDTodayPlanApexController.doInitApex();
            OPDTodayPlanApexController.coverage();
        }
        
        
    }
}