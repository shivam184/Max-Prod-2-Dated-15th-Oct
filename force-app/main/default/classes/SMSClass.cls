public class SMSClass {
    
    public static void sendSMS(String toNumber,String body) {
        system.debug('===sendSMSclass=====');
        Http http = new Http();
        HttpRequest request = new HttpRequest();  
        String endPoint = Label.SMSEndPoint;
        endpoint += 'feedid='+Label.FeedId+'&';
        endpoint += 'username='+Label.Username+'&';
        endpoint += 'password='+Label.Password+'&';
        endpoint += 'To='+toNumber+'&';
        endpoint += 'Text='+body+'&';
        endpoint += 'senderid='+Label.Senderid;
        request.setEndPoint(endpoint);
        request.setMethod('POST');
        HttpResponse response = Http.send(request);
        system.debug('====response='+response);
    }
}