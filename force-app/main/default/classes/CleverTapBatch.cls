Global class CleverTapBatch implements Database.Batchable<sObject>, Database.AllowsCallouts 
{
    public List<sObject> start(Database.BatchableContext c)
    {
        List<sObject> scope = new List<sObject>();
        scope.addAll([Select id, Name, Mobile_Phone__c, Email__c, RecordType.Name, DOB__c, DoctorFormula__c,Doctor_Name__c, Max_ID__c, Hospital_Location__c ,specialityFormula__c,Stage__c,lastmodifieddate from Lead__c where CreatedDate = Yesterday AND RecordType.Name='Digital Customer Acquisition']);
        scope.addAll([select id,Patient_Name__c,Patient_Email__c,Patient_Phone__c,Gender__c,DOB__c,Max_ID__c,specialityFormula__c,bussinessunitformula__c,Appointment_Date_Time__c,Age__c from Appointment__c where CreatedDate = yesterday]);
        return scope;
    }
    public void execute(Database.BatchableContext c, List<sObject> scope)
    {
        List<Clevertap.AddAppointmentLeadWrapper>  WrapList = new List<Clevertap.AddAppointmentLeadWrapper>();
        for(sObject obj : scope)
        {
            switch on obj
            {
                when Lead__c LeadObj
                {
                    Clevertap.AddAppointmentLeadWrapper Wrap = new Clevertap.AddAppointmentLeadWrapper();
                    Wrap.Name = LeadObj.Name;
                    wrap.Speciality = LeadObj.specialityFormula__c;
                    wrap.Mobile_Phone = LeadObj.Mobile_Phone__c;
                    wrap.Email=LeadObj.Email__c;
                    wrap.DOBlead=LeadObj.DOB__c;
                    if(LeadObj.DoctorFormula__c!=null){
                        wrap.DoctorLead=LeadObj.DoctorFormula__c;}
                    else if(LeadObj.Doctor_Name__c!=null){
                        
                        wrap.DoctorLead=LeadObj.Doctor_Name__c;
                        
                    }
                    wrap.LastModified=LeadObj.lastmodifieddate;
                    wrap.hospitallead=LeadObj.Hospital_Location__c;
                    wrap.MaxID=LeadObj.Max_ID__c;
                    wrap.Status=LeadObj.Stage__c;
                    WrapList.add(Wrap);
                }
                when Appointment__c Appoint
                {
                    Clevertap.AddAppointmentLeadWrapper Wrap = new Clevertap.AddAppointmentLeadWrapper();
                    wrap.Email=Appoint.Patient_Email__c;
                    wrap.PatientName=Appoint.Patient_Name__c;
                    wrap.Mobile_Phone=Appoint.Patient_Phone__c;
                    wrap.hospitallead=Appoint.bussinessunitformula__c;
                    wrap.patientGender=Appoint.Gender__c;
                    wrap.MaxID=Appoint.Max_ID__c;
                    wrap.DOBlead=Appoint.DOB__c;
                    wrap.AppointmentDateTime=Appoint.Appointment_Date_Time__c;
                    wrap.Speciality=appoint.specialityFormula__c;
                    wrap.Age=Appoint.Age__c;
                    WrapList.add(Wrap);
                    System.debug(WrapList);
                }
            }
        }
        String jsonS;
        
        JSONGenerator gen = JSON.createGenerator(true);  
        gen.writeStartObject();
        gen.writeFieldName('d');
        gen.writeStartArray();
        for(Clevertap.AddAppointmentLeadWrapper wrapper : WrapList){
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
                gen.writeStringField('Phone','+91'+ wrapper.Mobile_Phone.replaceFirst('0', ''));
            } 
            else if(wrapper.Mobile_Phone!=null  && (!Mobile.contains('+'))){
                gen.writeStringField('Phone','+91'+wrapper.Mobile_Phone);
            }
            else if(wrapper.Mobile_Phone!=null ){
                gen.writeStringField('Phone', wrapper.Mobile_Phone);
            }
            if(wrapper.patientGender!=null){     
                gen.writeStringField('Gender', wrapper.patientGender);
            }
                if(wrapper.Status!=null){     
                gen.writeStringField('Stage', wrapper.Status);
            }
            if(wrapper.Age!=null){     
                gen.writeNumberField('Age', wrapper.Age);
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
            if(wrapper.AppointmentDateTime!=null){
                gen.writeDateTimeField('Appointment Date/Time', wrapper.AppointmentDateTime);
            }
            if(wrapper.LastModified!=null){
                gen.writeDateTimeField('Lead Last Modified Date/Time',wrapper.LastModified);
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
    }
    
    public void finish(Database.BatchableContext c)
    {
    }
    
}