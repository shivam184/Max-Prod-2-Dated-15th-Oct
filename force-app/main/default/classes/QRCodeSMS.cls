public class QRCodeSMS {
  
    @AuraEnabled
    public static String sendSMS2(string leadid) {
        system.debug('ID'+leadid);
        string toNumber;
        //string user= 'QR Site Guest User' ;
       // string user = 'TMC Admin';
        string createdby;
        list<lead__c> Leadlist = new list<lead__c>();
        Leadlist= [Select id,name,Mobile_Phone__c ,createdby.Name from lead__c where id=:leadid LIMIT 1];
        system.debug('Leadlist'+Leadlist );
        if(Leadlist.size()>0){
        for(lead__c lc:Leadlist){
            toNumber = lc.Mobile_Phone__c;
            createdby =lc.createdby.Name;
          
        }
        }
        system.debug('created By-->'+createdby);
        system.debug('toNumber-->'+toNumber);
        if(toNumber!=null ){
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
            
                HttpResponse response = Http.send(request);
                system.debug('====response='+response.getstatuscode());
                integer stats=200;
                if(response.getstatuscode()==stats){
                   return 'Success';  
                }
            
            
           
            
        }
        return 'Error';
    }
}