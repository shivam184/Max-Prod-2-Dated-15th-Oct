public class CovidSMSClass {
    
    
    @AuraEnabled  
    public static string sendSMS(String recId) {
        system.debug('recId'+recId);
        // list<Max_at_Home_Enquiry_Page__c> lstMaxatHome = [SELECT Name,Phone_No__c,(select id from vital__r),(select id from E_Prescription__r) FROM Max_at_Home_Enquiry_Page__c WHERE Id =: recId AND Phone_No__c != null];
        
        list<Max_at_Home_Enquiry_Page__c> lstMaxatHome = [SELECT Name,Phone_No__c,(select id from E_Prescription__r) FROM Max_at_Home_Enquiry_Page__c WHERE Id =: recId AND Phone_No__c != null];
        
        if(lstMaxatHome.size()>0){
            
            if(lstMaxatHome[0].E_Prescription__r.size()>0){
                string toNumber=lstMaxatHome[0].Phone_No__c;             
                Http http = new Http();
                string body=Label.PrescriptionandVitalPage+lstMaxatHome[0].id;
                String bodyURL = BitlyService.shorten(body);
                // string htmlBody ='Thank you for choosing Isolation at home services from MAX at HOME. You can now view your prescription from the below link '+body;
                system.debug('body --> '+body);
                system.debug('bodyURL --> '+bodyURL);
                
                string htmlBody ='Thank you for choosing Isolation at home services from MAX at HOME. You can now view your prescription from the below link ' +bodyURL + '';
                htmlBody = EncodingUtil.urlEncode(htmlBody, 'UTF-8');               
                HttpRequest request = new HttpRequest();  
                system.debug('toNumber --> '+toNumber);
                String endPoint = 'https://bulkpush.mytoday.com/BulkSms/SingleMsgApi?';
                endpoint += 'feedid=345337&';
                endpoint += 'username=9818160065&';
                endpoint += 'password=Max@1234567&';
                endpoint += 'To='+toNumber+'&';
                endpoint += 'Text='+htmlBody+'&';
                endpoint += 'senderid='+Label.Senderid;
                
                request.setEndPoint(endpoint);
                request.setMethod('POST');
                if(!Test.isRunningTest()){
                    HttpResponse response = Http.send(request);
                    system.debug('====response='+response.getstatuscode());
                }
                return 'SMS send successfully';
            }
            else
                return 'Prescription not found';    
        }
        else
            return 'Record not found';
        
        
    }
}