global class BatchCustomNotificationAPIForNurse implements Database.Batchable<sObject>,Database.AllowsCallouts{
 global Database.QueryLocator start(Database.BatchableContext BC){
     
        string PrescriptionGenerated='Prescription Generated';
        string Deliveryunderway='Delivery underway';
        string Delivered='Delivered';
        string query='Select id,name,Isolation_Max_Home__r.nurse__r.Nurse__c,Isolation_Max_Home__c,Isolation_Max_Home__r.Service_Started_Date__c,Next_Notification_Date_Nurse__c,Isolation_Max_Home__r.Doctor__c,Time_One_Nurse__c,Time_Three_Nurse__c,Time_Two_Nurse__c from vital__c  where Isolation_Max_Home__r.Nurse__c != Null  AND Next_Notification_Date_Nurse__c=TODAY AND Isolation_Max_Home__r.nurse__r.Nurse__c != Null AND (Isolation_Max_Home__r.stage__c=\''+String.escapeSingleQuotes(PrescriptionGenerated)+'\' OR Isolation_Max_Home__r.stage__c = \''+String.escapeSingleQuotes(Deliveryunderway)+'\' OR Isolation_Max_Home__r.stage__c =\''+String.escapeSingleQuotes(Delivered)+'\') ';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<vital__c> listvital){
        list<id> DoctorIds=new list<Id>();
        List<vital__c> lstVital=new list<Vital__c>();
        string SetOneDoctorIds;
        string SetTwoDoctorIds;
        string timeval;
                string timeval1;

        For(vital__c pl:listvital){
            if(pl.Time_One_Nurse__c !=null){
                timeval=pl.Time_One_Nurse__c;
                string notificationDate=pl.Time_One_Nurse__c;  
                string currentTime=string.valueof(system.now().format('hh a'));
                integer num=integer.valueof(notificationDate.SubStringBefore(':'));
                    integer num2=integer.valueof(currentTime.substring(0,2));
                  integer num3=integer.valueof(string.valueof(system.now().format('hh mm a').substring(3,5)));

                system.debug(pl.name);
                 system.debug(notificationDate.endsWith('PM'));
                 system.debug(currentTime.endsWith('PM'));
                 system.debug(num-num2);

                if((((notificationDate.endsWith('PM') && currentTime.endsWith('PM')) || (notificationDate.endsWith('AM') && currentTime.endsWith('AM'))) &&  num-num2==1 && !notificationDate.contains('30')) || ((notificationDate.endsWith('AM') && currentTime.endsWith('PM')) && (num==12 && num2==11) && !notificationDate.contains('30')) || ((notificationDate.endsWith('PM') && currentTime.endsWith('AM')) && (num==12 && num2==11) && !notificationDate.contains('30')) || ((notificationDate.endsWith('PM') && currentTime.endsWith('PM')) && (num==1 && num2==12) && !notificationDate.contains('30')) ||  ((notificationDate.endsWith('AM') && currentTime.endsWith('AM')) && (num==1 && num2==12) && !notificationDate.contains('30') ) ||  (((notificationDate.endsWith('PM') && currentTime.endsWith('PM')) || (notificationDate.endsWith('AM') && currentTime.endsWith('AM'))) && num-num2==0 && notificationDate.contains('30') && num3==15 ) || test.isRunningTest() ){
                    
                   // integer num=integer.valueof(notificationDate.substring(0,1));
                   // integer num2=integer.valueof(currentTime.substring(0,1));
                  //  if(/*num2<num && (num2-num<=1 || num-num2<=10)*/num-num2==1){ 
                        
                        if(pl.Isolation_Max_Home__c != Null ) {
                            system.debug('helo');
                             if(pl.Isolation_Max_Home__r.nurse__r.Nurse__c != Null){
                            if(!String.isBlank(SetOneDoctorIds))
                            SetOneDoctorIds+=','+pl.Isolation_Max_Home__r.nurse__r.Nurse__c;
                            else
                            SetOneDoctorIds=pl.Isolation_Max_Home__r.nurse__r.Nurse__c;    
                            }
                       /*     string message='test nurse one change';    
                            Http h = new Http();
                            HttpRequest req = new HttpRequest();
                            req.setEndpoint(Url.getOrgDomainUrl().toExternalForm()
                                            + '/services/data/v46.0/actions/standard/customNotificationAction');
                            req.setMethod('POST');
                            req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
                            req.setHeader('Content-Type', 'application/json');
                            CustomNotificationActionInput input = new CustomNotificationActionInput();
                            input.customNotifTypeId = '0MLN0000000CaULOA0';
                            input.recipientIds = new List<String>{pl.Isolation_Max_Home__r.nurse__r.Nurse__c};
                                input.title = 'Test Notification';
                            input.body = message;
                            input.targetId = '0MLN0000000CaULOA0';
                            CustomNotificationAction action = new CustomNotificationAction();
                            action.inputs = new List<CustomNotificationActionInput>{input};
                                req.setBody(JSON.serialize(action));
                            HttpResponse res = h.send(req); */
                        } 
                    }
                //}
                
                // DoctorIds.add(pl.Isolation_Max_Home__c);
                
            }
            
            
            
            
            
            if(pl.Time_Two_Nurse__c !=null){
                                timeval1=pl.Time_Two_Nurse__c;

                string notificationDate=pl.Time_Two_Nurse__c;  
                string currentTime=string.valueof(system.now().format('hh a'));
                                    integer num=integer.valueof(notificationDate.SubStringBefore(':'));
                    integer num2=integer.valueof(currentTime.substring(0,2));
                                integer num3=integer.valueof(string.valueof(system.now().format('hh mm a').substring(3,5)));

                if((((notificationDate.endsWith('PM') && currentTime.endsWith('PM')) || (notificationDate.endsWith('AM') && currentTime.endsWith('AM'))) &&  num-num2==1 && !notificationDate.contains('30'))  || ((notificationDate.endsWith('AM') && currentTime.endsWith('PM')) && (num==12 && num2==11) && !notificationDate.contains('30')) || ((notificationDate.endsWith('PM') && currentTime.endsWith('AM')) && (num==12 && num2==11) && !notificationDate.contains('30')) || ((notificationDate.endsWith('PM') && currentTime.endsWith('PM')) && (num==1 && num2==12) && !notificationDate.contains('30') ) ||  ((notificationDate.endsWith('AM') && currentTime.endsWith('AM')) && (num==1 && num2==12) && !notificationDate.contains('30') ) ||  (((notificationDate.endsWith('PM') && currentTime.endsWith('PM')) || (notificationDate.endsWith('AM') && currentTime.endsWith('AM'))) && num-num2==0 && notificationDate.contains('30') && num3==15 ) || test.isRunningTest()){
                    
                  //  integer num=integer.valueof(notificationDate.substring(0,1));
                  //  integer num2=integer.valueof(currentTime.substring(0,1));
              //      if(/*num2<num && (num2-num<=1 || num-num2<=10)*/num-num2==1){
                        
                        if(pl.Isolation_Max_Home__c != Null ) {
                             if(pl.Isolation_Max_Home__r.nurse__r.Nurse__c != Null){
                            if(!String.isBlank(SetTwoDoctorIds))
                            SetTwoDoctorIds+=','+pl.Isolation_Max_Home__r.nurse__r.Nurse__c;
                            else
                            SetTwoDoctorIds=pl.Isolation_Max_Home__r.nurse__r.Nurse__c;    
                            }
                         /*   string message='test  nurse two change';    
                            Http h = new Http(); 
                            HttpRequest req = new HttpRequest();
                            req.setEndpoint(Url.getOrgDomainUrl().toExternalForm()
                                            + '/services/data/v46.0/actions/standard/customNotificationAction');
                            req.setMethod('POST');
                            req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
                            req.setHeader('Content-Type', 'application/json');
                            CustomNotificationActionInput input = new CustomNotificationActionInput();
                            input.customNotifTypeId = '0MLN0000000CaULOA0';
                            input.recipientIds = new List<String>{pl.Isolation_Max_Home__r.nurse__r.Nurse__c};
                                input.title = 'Test Notification';
                            input.body = message;
                            input.targetId = '0MLN0000000CaULOA0';
                            CustomNotificationAction action = new CustomNotificationAction();
                            action.inputs = new List<CustomNotificationActionInput>{input};
                                req.setBody(JSON.serialize(action));
                            HttpResponse res = h.send(req); */
                        } 
                   // }
                }
                
                // DoctorIds.add(pl.Isolation_Max_Home__c);
                
            }          
            
        //    pl.Next_Notification_Date_Nurse__c=pl.Isolation_Max_Home__r.Service_Started_Date__c.adddays(1);
         //   lstVital.add(pl);
            
            
   /*         
             
            
            if(pl.Time_Three_Nurse__c !=null){
                string notificationDate=pl.Time_Three_Nurse__c;  
                string currentTime=string.valueof(system.now().format('h a'));
                
                if((notificationDate.endsWith('PM') && currentTime.endsWith('PM')) || (notificationDate.endsWith('AM') && currentTime.endsWith('AM')) ){
                    integer num=integer.valueof(notificationDate.substring(0,1));
                    integer num2=integer.valueof(currentTime.substring(0,1));
                    if(num2<num && (num2-num<=1 || num-num2<=10)){
                        
                        if(pl.Isolation_Max_Home__c != Null ) {
                            string message='test nurse three change';    
                            Http h = new Http();
                            HttpRequest req = new HttpRequest();
                            req.setEndpoint(Url.getOrgDomainUrl().toExternalForm()
                                            + '/services/data/v46.0/actions/standard/customNotificationAction');
                            req.setMethod('POST');
                            req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
                            req.setHeader('Content-Type', 'application/json');
                            CustomNotificationActionInput input = new CustomNotificationActionInput();
                            input.customNotifTypeId = '0MLN0000000CaULOA0';
                            input.recipientIds = new List<String>{'005N0000008ewbUIAQ'};
                                input.title = 'Test Notification';
                            input.body = message;
                            input.targetId = '0MLN0000000CaULOA0';
                            CustomNotificationAction action = new CustomNotificationAction();
                            action.inputs = new List<CustomNotificationActionInput>{input};
                                req.setBody(JSON.serialize(action));
                            HttpResponse res = h.send(req);
                        } 
                    }
                }
                
                // DoctorIds.add(pl.Isolation_Max_Home__c);
                
            }          */
            
        }
        
             if(!String.isBlank(SetOneDoctorIds)){
                           string message=label.Doctor_Msg;    
                            Http h = new Http();  
                            HttpRequest req = new HttpRequest();
                            req.setEndpoint(Url.getOrgDomainUrl().toExternalForm()
                                            + '/services/data/v46.0/actions/standard/customNotificationAction');
                            req.setMethod('POST');
                            req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
                            req.setHeader('Content-Type', 'application/json');
                            CustomNotificationActionInput input = new CustomNotificationActionInput();
                            input.customNotifTypeId = label.targetid;
                            input.recipientIds = new List<String>{SetOneDoctorIds};
                                input.title = 'Reminder';
                            input.body = message; 
                            input.targetId = label.targetid;
                            CustomNotificationAction action = new CustomNotificationAction();
                            action.inputs = new List<CustomNotificationActionInput>{input}; 
                                req.setBody(JSON.serialize(action));
                 if(!test.isRunningTest())
                            HttpResponse res = h.send(req);
        }
        
         if(!String.isBlank(SetTwoDoctorIds)){
             string message=label.Doctor_Msg;    
                            Http h = new Http();  
                            HttpRequest req = new HttpRequest();
                            req.setEndpoint(Url.getOrgDomainUrl().toExternalForm()
                                            + '/services/data/v46.0/actions/standard/customNotificationAction');
                            req.setMethod('POST');
                            req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
                            req.setHeader('Content-Type', 'application/json');
                            CustomNotificationActionInput input = new CustomNotificationActionInput();
                            input.customNotifTypeId = label.targetid;
                            input.recipientIds = new List<String>{SetTwoDoctorIds};
                                input.title = 'Reminder';
                            input.body = message; 
                            input.targetId = label.targetid;
                            CustomNotificationAction action = new CustomNotificationAction();
                            action.inputs = new List<CustomNotificationActionInput>{input}; 
                                                 if(!test.isRunningTest())

                           

                                req.setBody(JSON.serialize(action));
                                                              if(!test.isRunningTest())

                            HttpResponse res = h.send(req);
        }
    }
    global void finish(Database.BatchableContext BC){
        
    }
    
    public class CustomNotificationAction
    {
        public List<CustomNotificationActionInput> inputs { get; set; }
    }
    
    public class CustomNotificationActionInput
    {
        public String customNotifTypeId { get; set; }
        public List<String> recipientIds { get; set; }
        public String title { get; set; }
        public String body { get; set; }
        public String targetId { get; set; }
    }
}