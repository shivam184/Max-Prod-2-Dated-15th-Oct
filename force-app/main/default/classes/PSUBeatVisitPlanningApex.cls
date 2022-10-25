public class PSUBeatVisitPlanningApex {
    
    @auraEnabled
    public static WrapperClass getDataFromApex() {
        WrapperClass wrpCls = new WrapperClass();
        wrpCls.today = Date.today();
        Integer numberOfDays = Date.daysInMonth(Date.today().year(), Date.today().month());
        Date lastDayOfMonth = Date.newInstance(Date.today().year(), Date.today().month(), numberOfDays);
        wrpCls.lastDate = lastDayOfMonth;
        Map<Integer,String> mapMonthNumberToName = new Map<Integer,String>{1=>'January',2=>'February',3=>'March',4=>'April',5=>'May',6=>'June',7=>'July',8=>'August',9=>'September',10=>'October',11=>'November',12=>'December'};
            //if(Date.today().month() == 12) {
            //wrpCls.nextMonthName = mapMonthNumberToName.get(1);
            //wrpCls.year = String.valueOf(Date.today().(addYears1));
            //}
            // else {
            wrpCls.nextMonthName = mapMonthNumberToName.get(Date.today().month());
        wrpCls.year = String.valueOf(Date.today().year());
        //}
        
        for(Account acc : [SELECT Id,Name,Phone,Address_From_Geolocation__c,SF_Speciality__c,SF_Speciality__r.Name FROM Account WHERE RecordType.Name = 'Corporate PSU' AND owner.id=:UserInfo.getUserId()]) {
            AccountWrapperClass wrpClsInner = new AccountWrapperClass(acc);
            wrpCls.listAccountWrapperClass.add(wrpClsInner);
        }
        
        for(Contact con : [SELECT Id,Name,MobilePhone FROM Contact WHERE RecordType.Name = 'Corporate PSU Contact' AND Converted__c = false]) {
            ContactWrapperClass wrpClsInner = new ContactWrapperClass(con);
            wrpCls.listContactWrapperClass.add(wrpClsInner);    
        }
        
        //wrpCls.listSpeciality = [SELECT Id,Name FROM Speciality__c];
        return wrpCls;
    }
    
    @auraEnabled
    public static String createBeatDetailsApex(String listAccount,Date visitDate,String listContact) {
        Savepoint sp = Database.setSavepoint();
        try{
            
            List<AccountWrapperClass> listAccountWrapperClass = (List<AccountWrapperClass>)System.JSON.deserialize(listAccount,List<AccountWrapperClass>.class);            
            List<ContactWrapperClass> listContactWrapperClass = (List<ContactWrapperClass>)System.JSON.deserialize(listContact,List<ContactWrapperClass>.class);            
            Map<Integer,String> mapMonthNumberToName = new Map<Integer,String>{1=>'January',2=>'February',3=>'March',4=>'April',5=>'May',6=>'June',7=>'July',8=>'August',9=>'September',10=>'October',11=>'November',12=>'December'};
                
            String year = String.valueOf(visitDate.year());
            String monthName = mapMonthNumberToName.get(visitDate.month());
            
            List<Beat_Plan__c> listBeatPlan = [SELECT Id FROM Beat_Plan__c 
                                               WHERE Month__c = :monthName
                                               AND Year__c = :year
                                               AND Status__c = 'Scheduled'
                                               AND Agent__c = :UserInfo.getUserId()];
            String beatPlanId = '';
            if(listBeatPlan != NULL && listBeatPlan.size() > 0) {
                beatPlanId = listBeatPlan[0].Id;
            }
            else {
                Beat_Plan__c beatPlan = new Beat_Plan__c();
                beatPlan.Name = UserInfo.getName() + '-'+monthName+'-'+year;
                beatPlan.Agent__c = UserInfo.getUserId();
                beatPlan.Month__c = monthName;
                beatPlan.Year__c = year;
                beatPlan.Status__c = 'Scheduled';
                insert beatPlan;
                
                beatPlanId = beatPlan.id;
            }
            List<Beat_Plan_Detail__c> listBeatPlanDetails = new List<Beat_Plan_Detail__c>();
            if(listAccountWrapperClass != NULL && listAccountWrapperClass.size() > 0) {
                for(AccountWrapperClass wrpClsInner : listAccountWrapperClass) {
                    if(wrpClsInner.isSelected) {
                        Beat_Plan_Detail__c beatPlanDetail = new Beat_Plan_Detail__c();
                        beatPlanDetail.Beat_Plan__c = beatPlanId;
                        beatPlanDetail.Account__c = wrpClsInner.acc.Id;
                        beatPlanDetail.Expected_Date_of_Visit__c = visitDate;
                        beatPlanDetail.Status__c = 'Scheduled';
                        listBeatPlanDetails.add(beatPlanDetail);	                
                    }
                }    
            }
            
            if(listContactWrapperClass != NULL && listContactWrapperClass.size() > 0) {
                for(ContactWrapperClass wrpClsInner : listContactWrapperClass) {
                    if(wrpClsInner.isSelected) {
                        Beat_Plan_Detail__c beatPlanDetail = new Beat_Plan_Detail__c();
                        beatPlanDetail.Beat_Plan__c = beatPlanId;
                        beatPlanDetail.Contact__c = wrpClsInner.con.Id;
                        beatPlanDetail.Expected_Date_of_Visit__c = visitDate;
                        beatPlanDetail.Status__c = 'Scheduled';
                        listBeatPlanDetails.add(beatPlanDetail);	                
                    }
                }
                
            }
            if(listBeatPlanDetails != NULL && listBeatPlanDetails.size() > 0) 
                insert listBeatPlanDetails;
            
            return 'SUCCESS';
        } 
        catch(Exception e) {
            Database.rollback(sp);
            return 'ERROR : '+e.getMessage();
        }
        
    }
    
    @auraEnabled
    public static WrapperClass doSearchApex(Boolean Self,Boolean Others,Boolean checkAccount, Boolean checkContact,String selectedSpeciality,String searchName,String selectedTerritory) {
        WrapperClass wrpCls = new WrapperClass();
        if(checkAccount){
            system.debug('===Others='+Others);
            String query = 'SELECT Id,Name,Phone,PSU_Corporate_Territory__c,Address_From_Geolocation__c,Account_Channel__c,SF_Speciality__c,SF_Speciality__r.Name FROM Account WHERE RecordType.Name = \'Corporate PSU\'';
            if(Others== Null || Others==false)
               query+=' AND owner.id=\''+UserInfo.getUserId()+'\''; 
            if(String.isNotBlank(selectedSpeciality))
                query += ' AND Account_Channel__c =: selectedSpeciality';
            if(String.isNotBlank(searchName))
                query += ' AND Name LIKE \'%' + searchName + '%\'';
            if(String.isNotBlank(selectedTerritory))
                query += ' AND PSU_Corporate_Territory__c = :selectedTerritory';
            for(Account acc : Database.query(query)) {
                AccountWrapperClass wrpClsInner = new AccountWrapperClass(acc);
                wrpCls.listAccountWrapperClass.add(wrpClsInner);    
            }
         
        }
        
        if(checkContact) {
            String query = 'SELECT Id,Name,PSU_Corporate_Territory__c,PSU_Corporate_Territory__r.Name,MobilePhone FROM Contact WHERE RecordType.Name = \'Corporate PSU Contact\' AND Converted__c = false';
            if(String.isNotBlank(searchName))
                query += ' AND Name LIKE \'%' + searchName + '%\'';
            if(String.isNotBlank(selectedSpeciality))
                query += ' AND Specialty__c =:selectedSpeciality';
            if(String.isNotBlank(selectedTerritory))
                query += ' AND PSU_Corporate_Territory__c =:selectedTerritory';
            for(Contact con : Database.query(query)) {
                ContactWrapperClass wrpClsInner = new ContactWrapperClass(con);
                wrpCls.listContactWrapperClass.add(wrpClsInner);    
            }
        }
        return wrpCls;
    }
    
    public class WrapperClass {
        
        @auraEnabled 
        public Date today;
        @auraEnabled
        public String nextMonthName;
        @auraEnabled 
        public String year;
        @auraEnabled
        public Date lastDate;
        @auraEnabled
        public List<AccountWrapperClass> listAccountWrapperClass;
        @auraEnabled
        public List<ContactWrapperClass> listContactWrapperClass;
        @auraEnabled
        public List<Speciality__c> listSpeciality;
        
        public WrapperClass() {
            listAccountWrapperClass = new List<AccountWrapperClass>();   
            listContactWrapperClass = new List<ContactWrapperClass>();
            listSpeciality = new List<Speciality__c>();
        }
    }
    
    public class AccountWrapperClass {
        @auraEnabled
        public Boolean isSelected;
        @auraEnabled
        public Account acc;
        
        public AccountWrapperClass(Account acc) {
            isSelected = false;
            this.acc = acc;
        }
    }
    
    public class ContactWrapperClass {
        @auraEnabled
        public Boolean isSelected;
        @auraEnabled
        public Contact con;	   
        
        public ContactWrapperClass(Contact con) {
            isSelected = false;
            this.con = con;
        }
    }
}