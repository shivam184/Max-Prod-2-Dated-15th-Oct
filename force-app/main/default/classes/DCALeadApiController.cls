@RestResource(urlMapping='/dcaleads/*')
global class DCALeadApiController {
    
    @HttpPOST
    global static void doCreateDCALead() {
        RestRequest req = RestContext.request;
        if(!String.isBlank(req.requestBody.toString())) {
            RequestBody requestBody = (RequestBody)JSON.deserialize(req.requestBody.toString(),RequestBody.class); 
            system.debug(requestBody);
            try {
                String recordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Digital Customer Acquisition').getRecordTypeId();
                Lead__c lead = new Lead__c();
                if(!String.isBlank(requestBody.Name)) 
                    lead.Name = requestBody.Name;    
                else {
                    String jsonStr = '{"success" : false,"message" : "Name is required"}';
                    RestContext.response.addHeader('Content-Type', 'application/json');
                    RestContext.response.responseBody = Blob.valueOf(jsonStr);
                    return;
                }
                if(!String.isBlank(recordTypeId))
                    lead.RecordTypeId = recordTypeId;
                if(!String.isBlank(requestBody.Email)) {
                    Boolean check = ValidateData.validateEmail(requestBody.email);   
                    if(check)
                        lead.Email__c = requestBody.Email;
                    else {
                        String jsonStr = '{"success" : false,"message" : "Provide email in correct format"}';
                        RestContext.response.addHeader('Content-Type', 'application/json');
                        RestContext.response.responseBody = Blob.valueOf(jsonStr);
                        return;
                    }
                }
                if(!String.isBlank(requestBody.PhoneNumber))
                    lead.Mobile_Phone__c = requestBody.PhoneNumber;
                if(!String.isBlank(requestBody.Comments))
                    lead.Digital_Description__c = requestBody.Comments;
                
                if(!String.isBlank(requestBody.Adw))
                    lead.Adw__c = requestBody.Adw;
                if(!String.isBlank(requestBody.Keyw))
                    lead.Keyw__c = requestBody.Keyw;
                if(!String.isBlank(requestBody.Placement))
                    lead.Placement__c = requestBody.Placement;
                if(!String.isBlank(requestBody.City))
                    lead.City__c = requestBody.City;
                if(!String.isBlank(requestBody.State))
                    lead.State_Province__c = requestBody.State;
                if(!String.isBlank(requestBody.Country))
                    lead.Country_Region__c = requestBody.Country;
                if(!String.isBlank(requestBody.Speciality))
                    lead.Speciality_Text__c = requestBody.Speciality;
                if(!String.isBlank(requestBody.EnquiryID))
                    lead.EnquiryID__c = requestBody.EnquiryID;
                if(!String.isBlank(requestBody.TypeOfQuery))
                    lead.DCA_Subtype__c = requestBody.TypeOfQuery;
                if(!String.isBlank(requestBody.HospitalName))
                    lead.Hospital_Name__c = requestBody.HospitalName;
                if(!String.isBlank(requestBody.DoctorName))
                    lead.Doctor_Name__c = requestBody.DoctorName;
                if(!String.isBlank(requestBody.MaxID))
                    lead.Max_ID__c = requestBody.MaxID;
                if(!String.isBlank(requestBody.NameOfPatient))
                    lead.Patient_Name__c = requestBody.NameOfPatient;
                if(!String.isBlank(requestBody.AppointmentDate))
                    lead.Appointment_Date__c = Date.valueOf(requestBody.AppointmentDate);
                if(!String.isBlank(requestBody.EnquiryType))
                    lead.Lead_Type__c = requestBody.EnquiryType;
                if(!String.isBlank(requestBody.Channel))
                    lead.Digital_Lead_Channel__c = requestBody.Channel;
                if(!String.isBlank(requestBody.IP_Address))
                    lead.IP_Address__c = requestBody.IP_Address;
                if(!String.isBlank(requestBody.SubmittedOn))
                    lead.Submitted_On__c = DateTime.valueOf(requestBody.SubmittedOn);
                if(!String.isBlank(requestBody.UniqueLeadID))
                    lead.HIS_Unique_Lead_ID__c = requestBody.UniqueLeadID;
                if(!String.isBlank(requestBody.File))
                    lead.File_Link__c = requestBody.File;
                if(!String.isBlank(requestBody.FileName))
                    lead.File_Name__c = requestBody.FileName;
                if(!String.isBlank(requestBody.LocationName))
                    lead.Location_Name__c = requestBody.LocationName;
                if(!String.isBlank(requestBody.PreferredTimetoCall))
                    lead.Preferred_Time_to_Call__c = requestBody.PreferredTimetoCall;
                //Added by Nitya
                /*if(!String.isBlank(requestBody.GCLID))
                    lead.GCLID__c=requestBody.GCLID;*/
                //Added By Shivam Gupta on 22nd August UTM Logic
                 boolean check2;
                 boolean check3;
                 boolean check4;
                if(!String.isBlank(requestBody.URL)){
                    lead.UTM_Parameters__c=requestBody.URL;
                    string str =  lead.UTM_Parameters__c;
                    String str2 = str.substringBetween('utm_source=','&');
                    string str3 = str.substringBetween('utm_medium=','&');
                    string str4 = str.substringBetween('utm_campaign=','&');
                    if(String.isBlank(str4)){
                        check3 = true;
                        system.debug('check3 ' +check3);
                        
                    }
                    string str6 = str.substringAfter('utm_campaign=');
                    if(String.isBlank(str6)){
                        check4= true;
                    }
                    check2 = str6.contains('gclid=');
                    system.debug('check2  '+check2);
                
                    
                    if(check2== false && check3 == true){
                         lead.Campaign__c=str.substringAfter('utm_campaign=');
                    }
                    string gclid = str.substringAfter('gclid=');
                    if(check2 == true && !String.isBlank(gclid)){
                        lead.GCLID__c=gclid;
                    }
                    if(String.isBlank(gclid)){
                            if(!String.isBlank(requestBody.GCLID)){
                            lead.GCLID__c = requestBody.GCLID;
                            }
                        }
                  
                    if(!String.isBlank(str4)){
                        lead.Campaign__c=str4;
                    }
                    
                    lead.Sub_Source__c=str3;
                    lead.Lead_Source__c=str2;
                    
                    
                   if(String.isBlank(str2)){
                    if(!String.isBlank(requestBody.Source)){
                    lead.Lead_Source__c=requestBody.Source;
                        }
                      }
                     if(String.isBlank(str3)){
                     if(!String.isBlank(requestBody.SubSource)){
                     lead.Sub_Source__c = requestBody.SubSource;
                     }
                     }
                    if(String.isBlank(str4)){
                    if(!String.isBlank(requestBody.Campaign) && check4==true){
                    lead.Campaign__c = requestBody.Campaign;
                    }
                    }
                    
                }
                  system.debug('GCLID'+lead.GCLID__c);
                  system.debug('Source'+lead.Lead_Source__c);
                  system.debug('Sub Source'+lead.Sub_Source__c ); 
                  system.debug('Campaign'+lead.Campaign__c); 
                
                
                
                if(String.isBlank(requestBody.URL)){
                    if(!String.isBlank(requestBody.Campaign) && check2 == false){
                        lead.Campaign__c = requestBody.Campaign;
                    }
                    if(!String.isBlank(requestBody.SubSource)){
                        lead.Sub_Source__c = requestBody.SubSource;
                    }
                    if(!String.isBlank(requestBody.Source)){
                        lead.Lead_Source__c=requestBody.Source;
                        
                }
                }
                    
                  
                
                
                // Added by Nitya on 5th August 2022
                if(!String.isBlank(requestBody.SpecURL))
                    lead.Speciality_URL__c=requestBody.SpecURL;
                if(!String.isBlank(requestBody.H1))
                    lead.H1__c=requestBody.H1;
                insert lead;
                String jsonStr = '{"success" : true,"message" : "Lead created successfully","lead_Id" : "'+lead.Id+'"}';
                RestContext.response.addHeader('Content-Type', 'application/json');
                RestContext.response.responseBody = Blob.valueOf(jsonStr);
                return;
            }
            catch(Exception e) {
                String jsonStr = '{"success" : false,"message" : "'+e.getMessage()+'"}';
                RestContext.response.addHeader('Content-Type', 'application/json');
                RestContext.response.responseBody = Blob.valueOf(jsonStr);
                return;
            }    
        }
        else {
            String jsonStr = '{"success" : false,"message" : "Provide Lead Details"}';
            RestContext.response.addHeader('Content-Type', 'application/json');
            RestContext.response.responseBody = Blob.valueOf(jsonStr);
            return;
        }
    }
    
    public class RequestBody {
        public String Name;
        public String Email;
        public String PhoneNumber;
        public String Comments;
        public String Campaign;
        public String Adw;
        public String Keyw;
        public String Placement;
        public String City;
        public String State;
        public String Country;
        public String Speciality;
        public String EnquiryID;
        public String TypeOfQuery ;
        public String HospitalName;
        public String DoctorName;
        public String MaxID;
        public String NameOfPatient;
        public String AppointmentDate;
        public String EnquiryType;
        public String Source;
        public String SubSource;
        public String Channel;
        public String IP_Address;
        public String SubmittedOn;
        public String UniqueLeadID;
        public String File;
        public String FileName;
        public String LocationName;
        public String PreferredTimetoCall;
        public string GCLID;
        public string URL;
        public String H1;
        public String SpecURL;
       
    }

}