global class BatchCovidSMSNotification implements Database.Batchable<sObject>,Database.AllowsCallouts{
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        string PrescriptionGenerated='Prescription Generated';
        string Deliveryunderway='Delivery underway'; 
        string Delivered='Delivered';
        string query='Select id,name,Isolation_Max_Home__r.Phone_No__c,Isolation_Max_Home__r.Doctor__r.doctor__c,Isolation_Max_Home__r.Doctor__r.doctor__r.MobilePhone,Isolation_Max_Home__c,Next_Notification_date__c,Isolation_Max_Home__r.Doctor__c,TIME_ONE__C,TIME_three__C,time_two__c,Isolation_Max_Home__r.Service_Started_Date__c from vital__c  where Next_Notification_Date_Nurse__c =TODAY AND Isolation_Max_Home__r.Phone_No__c!= Null AND (Isolation_Max_Home__r.stage__c=\''+String.escapeSingleQuotes(PrescriptionGenerated)+'\' OR Isolation_Max_Home__r.stage__c = \''+String.escapeSingleQuotes(Deliveryunderway)+'\' OR Isolation_Max_Home__r.stage__c =\''+String.escapeSingleQuotes(Delivered)+'\') ';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<vital__c> listvital){
        For(vital__c pl:listvital){
            
            string toNumber=pl.Isolation_Max_Home__r.Phone_No__c;
            Http http = new Http();
           // string body='https://maxhealthcare--maxdev.lightning.force.com/lightning/r/Vital__c/'+pl.id+'/view';
            string htmlBody ='Your isolation at home services have been initiated. Please enter your vitals on a daily basis in the below link ';
            htmlBody = EncodingUtil.urlEncode(htmlBody, 'UTF-8');               
            HttpRequest request = new HttpRequest();  
            String endPoint = 'http://bulkpush.mytoday.com/BulkSms/SingleMsgApi?';
            endpoint += 'feedid=345337&';
            endpoint += 'username=9818160065&';
            endpoint += 'password=Max@1234567&';
            endpoint += 'To='+toNumber+'&';
            endpoint += 'Text='+htmlBody+'';
            endpoint += 'senderid='+Label.Senderid;
            request.setEndPoint(endpoint);
            request.setMethod('POST');
            if(!Test.isRunningTest()){
                HttpResponse response = Http.send(request);
                system.debug('====response='+response.getstatuscode());
            }
        }
        
    }
    global void finish(Database.BatchableContext BC){
        
    }
    
    
    
    
}