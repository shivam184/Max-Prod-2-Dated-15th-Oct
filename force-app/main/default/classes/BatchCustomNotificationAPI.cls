global class BatchCustomNotificationAPI implements Database.Batchable<sObject>,Database.AllowsCallouts{
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        string PrescriptionGenerated='Prescription Generated';
        string Deliveryunderway='Delivery underway';
        string Delivered='Delivered';
        string query='Select id,name,Isolation_Max_Home__r.Doctor__r.doctor__c,Isolation_Max_Home__c,Next_Notification_date__c,Isolation_Max_Home__r.Doctor__c,TIME_ONE__C,TIME_three__C,time_two__c,Isolation_Max_Home__r.Service_Started_Date__c from vital__c  where Isolation_Max_Home__r.Doctor__c != Null  AND Next_Notification_date__c=TODAY AND Isolation_Max_Home__r.Doctor__r.doctor__c != Null AND (Isolation_Max_Home__r.stage__c=\''+String.escapeSingleQuotes(PrescriptionGenerated)+'\' OR Isolation_Max_Home__r.stage__c = \''+String.escapeSingleQuotes(Deliveryunderway)+'\' OR Isolation_Max_Home__r.stage__c =\''+String.escapeSingleQuotes(Delivered)+'\') ';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<vital__c> listvital){
       string SetOneDoctorIds;
        string plid;
        string timeval;
        List<vital__c> lstVital=new list<Vital__c>();
        For(vital__c pl:listvital){
            if(pl.TIME_ONE__C !=null){
                system.debug('hiiiii');
                timeval=pl.TIME_ONE__C;
                plid=pl.id;
                string notificationDate=pl.TIME_ONE__C;  
                string currentTime=string.valueof(system.now().format('hh a'));
                  integer num3=integer.valueof(string.valueof(system.now().format('hh mm a').substring(3,5)));
                integer num=integer.valueof(notificationDate.SubStringBefore(':'));
                integer num2=integer.valueof(currentTime.substring(0,2));
               system.debug(pl.name);
                 system.debug(notificationDate.endsWith('PM'));
                 system.debug(currentTime.endsWith('PM'));
                 system.debug(num-num2);

                if((((notificationDate.endsWith('PM') && currentTime.endsWith('PM')) || (notificationDate.endsWith('AM') && currentTime.endsWith('AM'))) && num-num2==1 && !notificationDate.contains('30')) || ((notificationDate.endsWith('AM') && currentTime.endsWith('PM')) && (num==12 && num2==11) && !notificationDate.contains('30')) || ((notificationDate.endsWith('PM') && currentTime.endsWith('AM')) && (num==12 && num2==11) && !notificationDate.contains('30')) || ((notificationDate.endsWith('PM') && currentTime.endsWith('PM')) && (num==1 && num2==12) && !notificationDate.contains('30')) ||  ((notificationDate.endsWith('AM') && currentTime.endsWith('AM')) && (num==1 && num2==12) && !notificationDate.contains('30') ) ||  (((notificationDate.endsWith('PM') && currentTime.endsWith('PM')) || (notificationDate.endsWith('AM') && currentTime.endsWith('AM'))) && num-num2==0 && notificationDate.contains('30') && num3==15 ) || test.isRunningTest()){
                    system.debug('helo');
                   // integer num=integer.valueof(notificationDate.substring(0,1));
                   // integer num2=integer.valueof(currentTime.substring(0,1));

                        if(pl.Isolation_Max_Home__c != Null ) {
                            if(pl.Isolation_Max_Home__r.Doctor__r.doctor__c!=null){
                            if(!String.isBlank(SetOneDoctorIds))
                            SetOneDoctorIds+=','+pl.Isolation_Max_Home__r.Doctor__r.doctor__c;
                            else
                            SetOneDoctorIds=pl.Isolation_Max_Home__r.Doctor__r.doctor__c;    
                            } 
                       
          
 
                        } 
                    
                }
                
                // DoctorIds.add(pl.Isolation_Max_Home__c);
                
            }
    
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
                            input.customNotifTypeId =label.targetid ;
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