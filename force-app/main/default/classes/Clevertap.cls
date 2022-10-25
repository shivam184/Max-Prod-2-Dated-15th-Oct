public class Clevertap {
    //@future(callout=true)
    /*public static void ClevertapMaxintegration(){
        List<AddAppointmentLeadWrapper>  WrapList = new List<AddAppointmentLeadWrapper>();
        List<Lead__c> LeadList= [Select id, Name, Mobile_Phone__c, Email__c, RecordType.Name, DOB__c, DoctorFormula__c, Max_ID__c, Hospital_Location__c ,specialityFormula__c from Lead__c where CreatedDate = TODAY AND RecordType.Name='Digital Customer Acquisition'];
        system.debug('LeadList'+LeadList);
        for(Lead__c LeadObj : LeadList){
            AddAppointmentLeadWrapper Wrap = new AddAppointmentLeadWrapper();
            Wrap.Name = LeadObj.Name;
            wrap.Speciality = LeadObj.specialityFormula__c;
            wrap.Mobile_Phone = LeadObj.Mobile_Phone__c;
            wrap.Email=LeadObj.Email__c;
            wrap.DOBlead=LeadObj.DOB__c;
            wrap.DoctorLead=LeadObj.DoctorFormula__c;
            wrap.hospitallead=LeadObj.Hospital_Location__c;
            wrap.MaxID=LeadObj.Max_ID__c;
            WrapList.add(Wrap);
        }
        List<Appointment__c> AppointmentList = [select id,Patient_Name__c,Patient_Email__c,Patient_Phone__c,Gender__c,DOB__c,Max_ID__c,specialityFormula__c,bussinessunitformula__c from Appointment__c where CreatedDate = TODAY];
        for(Appointment__c Appoint : AppointmentList){
            AddAppointmentLeadWrapper Wrap = new AddAppointmentLeadWrapper();
            // Wrap.Name = Appoint.Name;
            wrap.Email=Appoint.Patient_Email__c;
            wrap.PatientName=Appoint.Patient_Name__c;
            wrap.Mobile_Phone=Appoint.Patient_Phone__c;
            wrap.hospitallead=Appoint.bussinessunitformula__c;
            wrap.patientGender=Appoint.Gender__c;
            wrap.MaxID=Appoint.Max_ID__c;
            wrap.DOBlead=Appoint.DOB__c;
            wrap.Speciality=appoint.specialityFormula__c;
            WrapList.add(Wrap);
            System.debug(WrapList);
        }
        
        String jsonS;
        
        JSONGenerator gen = JSON.createGenerator(true);  
        gen.writeStartObject();
        gen.writeFieldName('d');
        gen.writeStartArray();
        for(AddAppointmentLeadWrapper wrapper : WrapList){
            gen.writeStartObject();
            if(wrapper.Mobile_Phone!=null){
                gen.writeStringField('identity',wrapper.Mobile_Phone);}
            gen.writeNumberField('ts', 1468308340);
            gen.writeStringField('type', 'profile');
            gen.writeFieldName('profileData');
            gen.writeStartObject();
            if(wrapper.Name!=null){
                gen.writeStringField('Name', wrapper.Name);
            }
            if(wrapper.PatientName!=null){
                gen.writeStringField('Name', wrapper.PatientName);
            }
            if(wrapper.Email!=null){
                gen.writeStringField('Email', wrapper.Email);}
            string Mobile = wrapper.Mobile_Phone;
            if(wrapper.Mobile_Phone!=null && Mobile.startsWith('0') && Mobile.length() > 1 ){
                gen.writeStringField('Phone','+'+ wrapper.Mobile_Phone.replaceFirst('0', ''));
            } 
            else if(wrapper.Mobile_Phone!=null  && (!Mobile.contains('+'))){
                gen.writeStringField('Phone','+'+wrapper.Mobile_Phone);
            }
            else if(wrapper.Mobile_Phone!=null ){
                 gen.writeStringField('Phone', wrapper.Mobile_Phone);
            }
            if(wrapper.patientGender!=null){     
                gen.writeStringField('Gender', wrapper.patientGender);
            }
            if(wrapper.DOBlead!=null){     
                gen.writeDateField('DOB', wrapper.DOBlead);
            }
            if(wrapper.DoctorLead!=null){
                gen.writeStringField('Doctor',wrapper.DoctorLead);
            }
            if(wrapper.hospitallead!=null){
                gen.writeStringField('Hospital', wrapper.hospitallead);
            }
            if(wrapper.MaxID!=null){
                gen.writeStringField('Max ID', wrapper.MaxID);
            }
           
            
            gen.writeStringField('Data', 'Salesforce');
            gen.writeStringField('MSG-sms', 'True');
            gen.writeStringField('MSG-whatsapp', 'True');
            gen.writeStringField('MSG-dndPhone', 'True');
            if(wrapper.Speciality!=null){
                gen.writeStringField('Speciality', wrapper.Speciality);
            }
            gen.writeEndObject();
            gen.writeEndObject();
            
        }
        jsonS = gen.getAsString(); 
        System.debug(jsonS);
        // Sending the http body with JSON 
        String endpoint = 'https://api.clevertap.com/1/upload';
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('POST');
        //Blob headerValue = Blob.valueOf('Maxuser' + ':' + 'Mtuvxyzuv#321');
        // String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('X-CleverTap-Account-Id','4W7-654-WZ6Z');
        req.setHeader('X-CleverTap-Passcode','ACQ-SEA-YHUL');
        req.setHeader('Content-Type','application/json');
        req.setbody(jsonS);
        Http http = new Http();
        HTTPResponse response = http.send(req);
        system.debug('ResponseFromCleverTap'+response.getBody());
        System.debug(response);
}*/
    public class AddAppointmentLeadWrapper { 
        public string Name{get;set;}
        public string Email{get;set;}
        public Date DOBlead{get;set;}
        public string DoctorLead{get;set;}
        public string Mobile_Phone{get;set;}
        public string hospitallead{get;set;}
        public string MaxID{get;set;}
        public string PatientName{get;set;} 
        public string patientGender{get;set;} 
        public string Speciality{get;set;} 
        public datetime AppointmentDateTime{get;set;}
        public decimal Age{get;set;}
        public string Status{get;set;}
        public datetime LastModified{get;set;}
    }
    
}