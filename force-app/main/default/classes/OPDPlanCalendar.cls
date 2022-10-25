public class OPDPlanCalendar {
    
      //public List<SelectOption> specialityListSelectOption {get;set;}
    public String selectedSpeciality {get;set;}
    public String phoneNumber {get;set;}
    public List<Account> listDoctor {get;set;}
    public List<Beat_Plan_Detail__c> listBeatPlanDetail = new List<Beat_Plan_Detail__c>();
    public List<CalEvent> events {get;set;}
    public CalEvent singleEvent {get;set;}
    public String meeting {get;set;}
    public static Boolean success {get;set;}
    public Boolean mecpUser {get;set;}
    public string selectedchannel{get;set;}
    public boolean Self{get;set;}
    public boolean othersval{get;set;}
    public List<DataWrapper> listDataWrapper {get;set;}
    public Boolean checkAccount {get;set;}
    public Boolean checkContact {get;set;}
    
    public String selectedTerritory {get;set;}
    public String selectedSpecialty {get;set;}
    public String selectedName {get;set;}
    
    public Boolean checkLead {get;set;}
    public Boolean checkOpp {get;set;}
    
    
    
    public String locality {get;set;}
    public String name {get;set;}
    public Map<Id,Integer> mapIdToCount {get;set;}
    public static Boolean success1 {get;set;}
    public Account acc {get;set;}
    
    //Added by Prabhat
    public Integer monthInt {get;set;}
    public list<selectoption> monthOpts {get;set;}
    public Date selecteddate {get;set;}
    
    String profileName;
    String dummyAct;
    
    //added by uzair
    public Boolean isMemberOfGroup{get;set;}
  public List<SelectOption> AccountChannel
{
    get
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','Please Choose')); 
        Schema.DescribeFieldResult fieldResult =Account.Account_Channel__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

        for( Schema.PicklistEntry f : ple)
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        return options;
    }
}  
    
    
    public OPDPlanCalendar() {
        
        isMemberOfGroup = false;
            Self=true;
        othersval=false;
        success = false;
        success1 = false;
        meeting = '';
        selectedTerritory='';
        selectedSpecialty='';
        selectedName='';
        monthInt = system.today().month();
        list<String> strList = new list<String>(label.Months.split(';'));
        monthOpts = new list<selectOption>();
        if(strList!=null && strList.size()>0){
            Integer i=1;
            for(String str : strList){
                monthOpts.add(new selectOPtion(String.valueOf(i),str));
                i++;
            }
        }
        profileName = [SELECT Name FROM Profile WHERE Id = :UserInfo.getProfileId()].Name;
        
        fetchDataOnLoad();    
    }
    
    
    //Method to get called on load of the page
    public void fetchDataOnLoad() {
        mecpUser = false;
        checkAccount = true;
        checkContact = true;
        
        dummyAct='\'%' + String.escapeSingleQuotes('Max Dummy Account') + '%\'';
        set<String> mecpProfiles = new set<String>();
        
      
        set<String> InternationalOPDAutomation = new set<String>();

       
        InternationalOPDAutomation.addAll(label.International_OPD_Automation.split(';'));

      
        if(InternationalOPDAutomation.contains(profileName)){
            isMemberOfGroup = true;
            mecpUser = true;
            mecpinit();
        }
       
        
      
       
        eventsinit();
    }
    
    
    //For MECP Profiles
    public void mecpinit(){
        listDataWrapper = new list<DataWrapper>();
        system.debug('selectedchannel'+selectedchannel);
        system.debug('others'+othersval);
        system.debug('selectedTerritory'+selectedTerritory);
        if(checkAccount){
            

            String query = 'SELECT Id,Name,owner.name,Outreach_OPD_partners_terriotary__c,Outreach_OPD_partners_terriotary__r.Name,Total_Admission_Amount__c,(SELECT Id FROM Beat_Plan_Details__r)'; 
            if(mecpUser)
                query+='FROM Account WHERE RecordType.Name=\'International Outreach Partner\'';
            query+=' AND (NOT Name LIKE '+dummyAct+')';
            
            if(String.isNotBlank(selectedTerritory))
                query+=' AND Outreach_OPD_partners_terriotary__c=\''+selectedTerritory+'\'';
            if(othersval==false)
               query+=' AND owner.id=\''+UserInfo.getUserId()+'\''; 
            if(String.isNotBlank(selectedName)){
                selectedName = '\'%' + String.escapeSingleQuotes(selectedName) + '%\'';
                query+=' AND Name LIKE '+selectedName;
            }
            query+='ORDER BY Name';
            query+=' LIMIT '+label.QueryLimit;
            
            system.debug('Query-->'+query);
            system.debug('selectedTerritory-->'+selectedTerritory);
            //system.debug('selectedSpecialty-->'+selectedSpecialty);
            //system.debug('selectedName-->'+selectedName);
            
            system.debug('query-->'+Database.query(query));
        
            for(Account acc : Database.query(query)){
                DataWrapper dwrap = new DataWrapper();
                dwrap.recordId =acc.Id;
                dwrap.Name = acc.Name;
                if(acc.Outreach_OPD_partners_terriotary__c!=null)
                    dwrap.Name += '-'+acc.Outreach_OPD_partners_terriotary__r.Name;
                if(acc.Outreach_OPD_partners_terriotary__c!=null && acc.owner.id!=UserInfo.getUserId())
                    dwrap.Name += '-'+acc.owner.name;
                dwrap.revenue = acc.Total_Admission_Amount__c!=null ? acc.Total_Admission_Amount__c : 0;
                dwrap.visitCount = String.valueOf(0);
                if(acc.Beat_Plan_Details__r!=null && acc.Beat_Plan_Details__r.size()>0)
                    dwrap.visitCount = String.valueOf(acc.Beat_Plan_Details__r.size());
                
                listDataWrapper.add(dwrap);
                
            }
        }
        if(checkContact){
            
            String query = 'SELECT Id,Name,Contact_Territory__c,Contact_Territory__r.Name,(SELECT Id FROM Beat_Plan_Details__r)'; 
            query+='FROM Contact WHERE RecordType.Name=\'Doctor\'';
            
            if(String.isNotBlank(selectedTerritory))
                query+=' AND Contact_Territory__c=\''+selectedTerritory+'\'';
            if(String.isNotBlank(selectedSpecialty))
                query+=' AND Specialty__c=\''+selectedSpecialty+'\'';
            if(String.isNotBlank(selectedName)){
                selectedName = '\'%' + String.escapeSingleQuotes(selectedName) + '%\'';
                query+=' AND Name LIKE '+selectedName;
            }
            query+='ORDER BY Name';
            query+=' LIMIT '+label.QueryLimit;
            
            
            for(Contact con : Database.query(query)){
                DataWrapper dwrap = new DataWrapper();
                dwrap.recordId =con.Id;
                dwrap.Name = con.Name;
                if(con.Contact_Territory__c!=null)
                    dwrap.Name += con.Contact_Territory__r.Name;
                dwrap.revenue = 0;
                dwrap.visitCount = String.valueOf(0);
                if(con.Beat_Plan_Details__r!=null && con.Beat_Plan_Details__r.size()>0)
                    dwrap.visitCount = String.valueOf(con.Beat_Plan_Details__r.size());
                
                listDataWrapper.add(dwrap);
                
            }
        }
    }
    
    
    
    
    
    //Method For Max Labs Profiles
  /*  public Boolean maxLabsinit(){
       return getIsMemberOfGroup();
    }
    //added by uzair tmc
    public Boolean getIsMemberOfGroup()
    {
        if(UserInfo.getUserRoleId() != null)
        {
            set<String> roleRelatedGroupIds = new set<String>();
            
            for (Group g : [SELECT id, RelatedId, Type
                            FROM Group
                            WHERE RelatedId = :UserInfo.getUserRoleId()])
                roleRelatedGroupIds.add(g.id);
            
            for (GroupMember gm : [SELECT Id, group.id, group.name, group.type
                                   FROM GroupMember
                                   WHERE (UserOrGroupId = :UserInfo.getUserId() AND group.type='Regular')
                                   OR (UserOrGroupId IN :roleRelatedGroupIds AND group.type='Regular')]){
                                       if(gm.group.Name == label.Max_Lab_Beat_Plan)
                                           return true; 
                                   }
        }
        return false;
    } */
    
    //Method to search all meetings
    public void eventsinit(){
        selecteddate = Date.newInstance(System.today().year() , monthInt, 1);
        listBeatPlanDetail = new List<Beat_Plan_Detail__c>();
        events = new List<CalEvent>();
        listBeatPlanDetail = [SELECT Id,Expected_Date_of_Visit__c,Reschedule_Date__c,Status__c,Account__r.Name,Account__r.Outreach_OPD_partners_terriotary__r.Name,
                              Lead__c,Lead__r.Name,Contact__c,Contact__r.Name,Opportunity__c,Opportunity__r.Name FROM Beat_Plan_Detail__c
                              WHERE Beat_Plan__r.Agent__c =:UserInfo.getUserId() 
                              AND CALENDAR_MONTH(Expected_Date_of_Visit__c) = :monthInt 
                              AND CALENDAR_YEAR(Expected_Date_of_Visit__c) = :System.today().year() 
                              AND Status__c IN ('Scheduled','Completed','Re-scheduled','Cancelled')
                             ];
                             
         if(listBeatPlanDetail != NULL && listBeatPlanDetail.size() > 0) {
            for(Beat_Plan_Detail__c bpd : listBeatPlanDetail) {
                calEvent myEvent = new calEvent();
                if(bpd.Account__c != NULL) {
                    myEvent.title = bpd.Account__r.Name;
                    if(bpd.Account__r.Outreach_OPD_partners_terriotary__r.Name != NULL)
                        myEvent.title += ' - ' + bpd.Account__r.Outreach_OPD_partners_terriotary__r.Name;    
                }
                else if(bpd.Lead__c != NULL)
                    myEvent.title = bpd.Lead__r.Name;
                else if(bpd.Contact__c != NULL)
                    myEvent.title = bpd.Contact__r.Name;
                else if(bpd.Opportunity__c != NULL)
                    myEvent.title = bpd.Opportunity__r.Name;
                
                myEvent.expectedDate = bpd.Expected_Date_of_Visit__c;
                if(bpd.Status__c == 'Completed')
                    myEvent.colorName = 'green';
                else if(bpd.Status__c == 'Cancelled')
                    myEvent.colorName = 'red';
                else if(bpd.Status__c == 'Re-scheduled') {
                    myEvent.colorName = 'yellow';
                    myEvent.textColor = 'black';
                    
                }
                myEvent.url = '/'+bpd.Id;
                events.add(myEvent);
            }               
        }
    }
    
    
    
    public void callSaveApex() {
        success = success1 = false;
        meeting = meeting.removeEnd(',');
        List<String> listMeeting = meeting.split(',');
        Set<Date> setDate = new Set<Date>();
        
        for(String oneMeeting : listMeeting) {
            list<String> IdDate = oneMeeting.split('@');
            Date dt = Date.valueOf(IdDate[1]);
            setDate.add(dt);
            if(dt < System.today())
                success1 = true;
            System.debug('success1-->'+success1);
            if(success1)
                return;
            
        }
        
        List<Beat_Plan_Detail__c> listBeatPlanDetail = new List<Beat_Plan_Detail__c>();
        Set<String> setMonthName = new Set<String>();
        Set<String> setMonth = new Set<String>();
        Set<String> setYear = new Set<String>();
        Map<Integer,String> mapMonthNumberToName = new Map<Integer,String>{1=>'January',2=>'February',3=>'March',4=>'April',5=>'May',6=>'June',7=>'July',8=>'August',9=>'September',10=>'October',11=>'November',12=>'December'};
            
            for(Date dt : setDate){
                Integer month = dt.month();
                setMonth.add(mapMonthNumberToName.get(month));
                setYear.add(String.valueOf(dt.year()));
            }  
        
        List<Beat_Plan__c> listBeatPlan = [SELECT Id,Month__c,Year__c FROM Beat_Plan__c 
                                           WHERE Month__c IN :setMonth
                                           AND Year__c = :setYear
                                           AND Status__c = 'Scheduled'
                                           AND Agent__c = :UserInfo.getUserId()
                                           AND Month__c != NULL AND Year__c != NULL];
        Map<String,Beat_Plan__c> mapIdToBeatPlan = new Map<String,Beat_Plan__c>(); 
        if(listBeatPlan != NULL && listBeatPlan.size() > 0) {
            for(Beat_Plan__c bp: listBeatPlan) {
                mapIdToBeatPlan.put(bp.Month__c+'*'+bp.Year__c,bp);    
            }       
        }
        
        List<Beat_Plan__c> listBeatPlanNew = new List<Beat_Plan__c>();
        
        for(Date dt : setDate){
            Integer month = dt.month();
            String year = String.valueOf(dt.year());
            if(mapIdToBeatPlan != NULL && mapIdToBeatPlan.keySet().size() > 0 && mapIdToBeatPlan.containsKey(mapMonthNumberToName.get(month)+'*'+String.valueOf(year))) {
                
            }
            else {
                Beat_Plan__c beatPlan = new Beat_Plan__c();
                beatPlan.Name = UserInfo.getName() + '-'+mapMonthNumberToName.get(month)+'-'+year;
                beatPlan.Agent__c = UserInfo.getUserId();
                beatPlan.Month__c = mapMonthNumberToName.get(month);
                beatPlan.Year__c = year;
                beatPlan.Status__c = 'Scheduled';
                listBeatPlanNew.add(beatPlan);
                mapIdToBeatPlan.put(mapMonthNumberToName.get(month)+'*'+year,beatPlan);
            }
        } 
        
        if(listBeatPlanNew != NULL && listBeatPlanNew.size() > 0)
            insert listBeatPlanNew;
        
        for(String oneMeeting : listMeeting) {
            list<String> IdDate = oneMeeting.split('@');
            Date dt = Date.valueOf(IdDate[1]);
            Integer month = dt.month();
            String year = String.valueOf(dt.year());
            
            Beat_Plan_Detail__c beatPlanDetail = new Beat_Plan_Detail__c();
            beatPlanDetail.Beat_Plan__c = mapIdToBeatPlan.get(mapMonthNumberToName.get(month)+'*'+year).Id;
            beatPlanDetail.Expected_Date_of_Visit__c = Date.valueOf(IdDate[1]);
            beatPlanDetail.Status__c = 'Scheduled';
            system.debug(IdDate);
            system.debug((Id) IdDate[0]);
            if(IdDate !=NULL){
            Id recId = (Id) IdDate[0];
            
            String objName = recId.getSObjectType().getDescribe().getName();
            if(String.isNotBlank(objName) && objName == 'Account')
                beatPlanDetail.Account__c = recId;
            else if(String.isNotBlank(objName) && objName == 'Lead__c')
                beatPlanDetail.Lead__c = recId;
            else if(String.isNotBlank(objName) && objName == 'Contact')
                beatPlanDetail.Contact__c = recId;
            else if(String.isNotBlank(objName) && objName == 'Opportunity__c')
                beatPlanDetail.Opportunity__c = recId;
            listBeatPlanDetail.add(beatPlanDetail);
            }
        }
        
        if(listBeatPlanDetail != NULL && listBeatPlanDetail.size() > 0) {
            insert listBeatPlanDetail;
            
            success = true;
        }
    }
     
    
    @RemoteAction
    public static void toggleErrorFlag() {
        success1 = !success1;
    }
    
    @RemoteAction
    public static void toggleSuccessFlag() {
        success = !success;
    }
    
    
    //Class to hold calendar event data
    public class CalEvent {
        public String title {get;set;}
        public String url {get;set;}
        public Date expectedDate {get;set;}
        public String colorName {get;set;}
        public String textColor {get;set;}
    }
    
    public class DataWrapper {
        public String recordId {get;set;}
        public String name {get;set;}
        public Decimal revenue {get;set;}
        public String visitCount {get;set;}
    }

}