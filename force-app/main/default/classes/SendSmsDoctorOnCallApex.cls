/*created By Nitya IRT on 18th July 2022
 * */
public class SendSmsDoctorOnCallApex {
    @AuraEnabled  
    public static string sendSMS(String recId) {
        system.debug('recId'+recId);
        list<Max_at_Home_Enquiry_Page__c> lstMaxatHome = [SELECT Name,Phone_No__c,Patient_name__c,(select id from E_Prescription__r) FROM Max_at_Home_Enquiry_Page__c WHERE Id =: recId AND Phone_No__c != null];
        if(lstMaxatHome.size()>0){
            if(lstMaxatHome[0].E_Prescription__r.size()>0){
                string toNumber=lstMaxatHome[0].Phone_No__c;             
                Http http = new Http();
                string body=Label.DoctorOnCallLink+lstMaxatHome[0].id;
                String bodyURL = BitlyService.shorten(body);
                //  system.debug('body --> '+body);
                system.debug('bodyURL --> '+bodyURL);
                
                // string htmlBody ='Thank you for choosing Isolation at home services from MAX at HOME. You can now view your prescription from the below link ' +bodyURL + '';
                string htmlBody ='Dear '+lstMaxatHome[0].Patient_name__c+', Thank You for choosing Max@Home. Please click on the following link ' +bodyURL+' to view your prescription. To order your prescribed medicines, blood tests or any other service@home, call or WhatsApp us on +91 8744888888. Avail attractive offers, TnC apply';
                htmlBody = EncodingUtil.urlEncode(htmlBody, 'UTF-8');  
                system.debug(htmlBody);             
                HttpRequest request = new HttpRequest();  
                //  system.debug('toNumber --> '+toNumber);
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