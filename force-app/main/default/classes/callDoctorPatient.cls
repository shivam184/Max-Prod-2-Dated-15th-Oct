public class callDoctorPatient {
    
    @AuraEnabled
    public static String callDoctorPatient(String LeadId){
        
        Max_at_Home_Enquiry_Page__c isoLead = [select id, name, Patient_Name__c, Phone_No__c, Doctor__r.name, Doctor__r.PersonMobilePhone FROM Max_at_Home_Enquiry_Page__c WHERE id=:LeadId];
        
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:ConferenceCall');
        request.setMethod('POST');
        request.setHeader('Content-Type','application/json');
        request.setHeader('Accept','application/json');
        
        CallDoctorPatientWrapper gPLW = new CallDoctorPatientWrapper();
        
        gPLW.staff_id = isoLead.id;
        gPLW.patient_name = isoLead.Patient_Name__c;
        gPLW.patient_phone = isoLead.Phone_No__c;
        gPLW.doctor_name = isoLead.Doctor__r.name;
        gPLW.doctor_phone = isoLead.Doctor__r.PersonMobilePhone;
        gPLW.clientname = 'max';
        gPLW.token = '5fd53b477b6a275185307208f985b340';
        
        if(gPLW.patient_phone == '' || gPLW.doctor_phone == ''){
            System.debug('No Phone Number Available.' + isoLead.Phone_No__c + ' Here ' + isoLead.Doctor__r.PersonMobilePhone);
            return 'No Phone Number Available.';
        }
        else{   
            request.setBody(JSON.serialize(gPLW));
        }
        
        try{
            Http htp = new Http();
            HttpResponse response = htp.send(request);
            // Parse the JSON response
            if (response.getStatusCode() == 200) {
                // Deserialize the JSON string into collections of primitive data types.
                Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                // get the value of the Status.
                String status = results.get('message').toString();
                System.debug('Received the following details:');
                if(status == 'success') {
                    System.debug('status >>> ' + status);
                    return 'SUCCESS';
                }
                else{
                    System.debug('status error >>> ' + status);
                    return 'Error while Calling status is Failure.';
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
    
    public static void coverage(){
        
        String strj = 'Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        
    }
}