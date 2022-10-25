/*
 * This is used to Trigger an SMS on creation of Max Lab Customer Lead Record
 * Used in leadTrigger
 * Written By: Shivam Gupta 6th Oct 2022
 * 
 * 
 * */
public class SMSQRCode {
    
    @AuraEnabled
    public static String sendSMS2(string leadid) {
        system.debug('ID'+leadid);
        string toNumber;
        list<lead__c> Leadlist = new list<lead__c>();
        Leadlist= [Select id,name,Mobile_Phone__c  from lead__c where id=:leadid LIMIT 1];
        system.debug('Leadlist'+Leadlist );
        for(lead__c lc:Leadlist){
            toNumber = lc.Mobile_Phone__c;
        }
        
        
        system.debug('toNumber-->'+toNumber);
        if(toNumber!=null){
            Http http = new Http();
            
         
            string htmlBody = 'Dear MaxLab Customer,We got your test booking request through QR code Scanning, our team will connect with you soon or you can call on '+label.QR_Code_Working_Number+'. Thanks Max Lab.';
            htmlBody = EncodingUtil.urlEncode(htmlBody, 'UTF-8');  
            system.debug(htmlBody);             
            HttpRequest request = new HttpRequest();  
            system.debug('toNumber --> '+toNumber);
            String endPoint = 'https://bulkpush.mytoday.com/BulkSms/SingleMsgApi?';
           
            endpoint += 'feedid=371059&'; 
            endpoint += 'username=9818160065&';
            endpoint += 'password=Max@1234567&';
            endpoint += 'To='+toNumber+'&';
            endpoint += 'Text='+htmlBody+'&';
            endpoint += 'senderid='+Label.Senderid2;
            
            request.setEndPoint(endpoint);
            system.debug(endpoint);
            request.setMethod('POST');
            if(!Test.isRunningTest()){
                HttpResponse response = Http.send(request);
                system.debug('====response='+response.getstatuscode());
                integer stats=200;
                if(response.getstatuscode()==stats){
                   return 'Success';  
                }
            }
            
           
            
        }
        return 'Error';
    }
    
     @future(callout=true)
    public static void sendSMS3(string toNumber,string CompliantNumber){
        system.debug('toNumber-->'+toNumber);
        system.debug('Complaint-->'+CompliantNumber);
        if(toNumber!=null){
            Http http = new Http();
            string lg='https://bulkpush.mytoday.com/BulkSms/SingleMsgApi?feedid=345337&username=9818160065&password=Max@1234567&To=7508447594&Text=Dear%20Max%20Lab%20Customer,%20your%20Complaint%20with%20Ref.%20C-1010170517%20has%20been%20logged%20in%20system.%20For%20more%20query,%20call%207982100200&senderid=MAXCRM ';
            
            string htmlBody='Dear%20Max%20Lab%20Customer,%20your%20Complaint%20with%20Ref.%20'+CompliantNumber+'%20has%20been%20logged%20in%20system.%20For%20more%20query,%20call%207982100200';
            system.debug(htmlBody);             
            HttpRequest request = new HttpRequest();  
            system.debug('toNumber --> '+toNumber);
            String endPoint = 'https://bulkpush.mytoday.com/BulkSms/SingleMsgApi?';
            endpoint += 'feedid=345337&';
            endpoint += 'username=9818160065&';
            endpoint += 'password=Max@1234567&';
            endpoint += 'To='+toNumber+'&';
            endpoint += 'Text='+htmlBody+'&';
            endpoint += 'senderid=MAXCRM';
            
            request.setEndPoint(endpoint);
            system.debug(endpoint);
            request.setMethod('POST');
            if(!Test.isRunningTest()){
                HttpResponse response = Http.send(request);
                system.debug('====response='+response.getstatuscode());
            }
        }
    }
            
            
     @future(callout=true)
    public static void sendSMS4(string toNumber,string CompliantNumber){
        system.debug('toNumber-->'+toNumber);
        system.debug('Complaint-->'+CompliantNumber);
        if(toNumber!=null){
            Http http = new Http();
            string htmlBody='Dear Max Lab Customer, your Complaint with Ref.'+CompliantNumber+' has been closed. Thank you for providing us an opportunity to serve you. For query, call 7982100200';
           //string htmlBody='Dear Max Lab Customer, your Complaint with Ref. '+CompliantNumber+' has been logged in system. For more query, call 7982100200';
            htmlBody = EncodingUtil.urlEncode(htmlBody, 'UTF-8');  
            system.debug(htmlBody);             
            HttpRequest request = new HttpRequest();  
            system.debug('toNumber --> '+toNumber);
            String endPoint = 'https://bulkpush.mytoday.com/BulkSms/SingleMsgApi?';
            endpoint += 'feedid=345337&';
            endpoint += 'username=9818160065&';
            endpoint += 'password=Max@1234567&';
            endpoint += 'To='+toNumber+'&';
            endpoint += 'Text='+htmlBody+'&';
            endpoint += 'senderid=MAXCRM';
            
            request.setEndPoint(endpoint);
            system.debug(endpoint);
            request.setMethod('POST');
            if(!Test.isRunningTest()){
                HttpResponse response = Http.send(request);
                system.debug('====response='+response.getstatuscode());
                
                
            }
        }
    }
    
    
    
    
}