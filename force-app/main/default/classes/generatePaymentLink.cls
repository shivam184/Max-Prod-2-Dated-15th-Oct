public class generatePaymentLink {
    
    @AuraEnabled
    public static String sendPaymentLink(String LeadId){
        // System.debug('LeadId >>>> ' + LeadId);
        
        Max_at_Home_Enquiry_Page__c isoLead = [SELECT id, Transaction_ID__c, Patient_Name__c, Patient_Max_id__c, Amount__c, Phone_No__c, Age__c, 
                                               Gender__c, Patient_DOB__c, Stage__c, Service_Item_Id__c, Address__c, Service_Amount__c, Net_Price__c,No_of_Visit__c,First_Name__c, 
                                               Last_Name__c, Discount__c,Email_Id__c, Payment_Mode__c FROM Max_at_Home_Enquiry_Page__c WHERE id=:LeadId];
        
        if(isoLead.Stage__c == 'Open'){
            return 'Open';
        }
        
        else if(isoLead.Payment_Mode__c == 'Online' && isoLead.Stage__c != 'Open'){
            HttpRequest request = new HttpRequest();
            request.setEndpoint('callout:SaveLeadPatientDet/MaxHomeApi/api/CRM/SaveLeadPatientDetailsForPaymentAndBillGeneration');
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('Authorization', 'Basic TTAyMjQzMzpNYXhAMTIzNDU=');
            
            GeneratePaymentLinkWrapper gPLW = new GeneratePaymentLinkWrapper();
            
            Date d = isoLead.Patient_DOB__c;
            //system.debug(string.valueof(d).removeEnd(' 00:00:00'));
            gPLW.LeadId = isoLead.id;
            gPLW.TransactionId = isoLead.Transaction_ID__c;
            gPLW.FirstName = isoLead.First_Name__c;
            gPLW.LastName = isoLead.Last_Name__c;
            ///Added by Shivam Gupta
            gPLW.Amount = isoLead.Net_Price__c;
            gPLW.EmailId = isoLead.Email_Id__c;
            gPLW.MobileNumber = isoLead.Phone_No__c;
            gPLW.ServiceId = '92';
            gPLW.Age = isoLead.Age__c;
            gPLW.Gender = isoLead.Gender__c;
            gPLW.CityId = '1';
            gPLW.StateId = '1';
            gPLW.LocationId = '1';
            if(d!=null)
                gPLW.DOB = date.valueOf(string.valueof(d).removeEnd(' 00:00:00'));
            gPLW.Userid = '0';
            gPLW.MaxId = isoLead.Patient_Max_id__c;
            gPLW.PatientId = '0';
            gPLW.DeliveryAddress = isoLead.Address__c;
            gPLW.ServiceItemID = isoLead.Service_Item_Id__c;
            gPLW.DiscountID = '0';
            gPLW.DiscountAmount = '0';
            gPLW.OrderQty = '1';
            gPLW.RefDoctorID = '2015';
            gPLW.CompanyID = '0';
            gPLW.PackageID = '0';
            gPLW.IsDiscountApplicable = '0';
            gPLW.IsAdvance = '0';
            gPLW.IsServiceApplicable = '0';
            gPLW.SessionId = '0';
            gPLW.MacAddress = '0';
            
            //gPLW.isLWrpr.add(isLW);
            //System.debug('gPLW >>> ' + gPLW);
            System.debug(JSON.serialize(gPLW));
            request.setBody(JSON.serialize(gPLW));
            //  request.setBody('{"Userid":"0","TransactionId":"M1AFEB2-4972-4DD5-83B4-02C12BC4B6F9LEAD","StateId":"1","SessionId":"0","ServiceItemID":"53034","ServiceId":"41","RefDoctorID":"2015","PatientId":"0","PackageID":"0","OrderQty":"1","MobileNumber":"9910168971","MaxId":"mid123","MacAddress":"0","LocationId":"1","LeadId":"a15N000000IeawtIAB","LastName":"LastName","IsServiceApplicable":"0","IsDiscountApplicable":"0","IsAdvance":"0","Gender":"Male","FirstName":"Suraj","EmailId":"test@techmatrixconsulting.com","DOB":"2022-03-09","DiscountID":"0","DiscountAmount":"0","DeliveryAddress":"\"test address delhi 110047\"","CompanyID":"0","CityId":"1","Amount":11.00,"Age":31}');
            
            try{
                Http htp = new Http();
                //System.debug('Authorization() >>>> 'genere + request.getHeader('Authorization'));
                // System.debug('request.getBody() >>>> ' + request.getBody());
                HttpResponse response = htp.send(request);
                System.debug('response.getStatusCode() >>>> ' + response.getStatusCode());
                System.debug('response.getBody() >>>> ' + response.getBody());
                // Parse the JSON response
                if (response.getStatusCode() == 200) {
                    // Deserialize the JSON string into collections of primitive data types.
                    Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                    system.debug(results);
                    // get the value of the Status.
                    String status = results.get('Status').toString();
                    System.debug('Received the following details:');
                    if(status == 'success') {
                        System.debug('status >>> ' + status);
                        return 'Success';
                    }
                    else{
                        System.debug('status error >>> ' + status);
                        return 'Error while sending messasge status is Failure.';
                    }
                }
                else{
                    System.debug('status error outer >>> ' + response.getBody());
                    return 'Response status code is not 200.';
                }
            }
            catch(System.CalloutException e) {
                System.debug('System.CalloutException >>> ' + e.getMessage());
                //API_Error_Log__c ael = new API_Error_Log__c();
                //ael.API_Name__c = '';
            }
            return null;
        }
        else{
            return 'Please select accurate Stage and Payment Mode.';
        }
    }
}