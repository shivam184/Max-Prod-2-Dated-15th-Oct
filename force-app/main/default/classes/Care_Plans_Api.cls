//Description : Create the Care Plans Records under relative Lead records
//              And update the lead field 'Care plan status'.              
//Created By : Prashant Gahlaut

@RestResource(urlmapping = '/careplanapi/*')
global class Care_Plans_Api {
    @httpPost
    global static void createplans(){
        RestRequest req = RestContext.request;
        if(string.isNotBlank(req.requestBody.toString())){
            RequestBody request = (RequestBody)json.deserialize(req.requestBody.toString(), RequestBody.class);
            if(request.data != null && request.data.size()>0){
                
                map<string,Care_Plan__c> careplanmap= new map<string,Care_Plan__c>();
                map<string,id> patientmap = new map<string,id>();
                map<string,id> specialmap = new map<string,id>();
                map<string,id> doctormap = new map<string,id>();
                map<string,id> businessmap = new map<string,id>();
                map<string,lead__c> leadmap = new map <string,lead__c>();
                list<Care_Plan__c> insertlist = new list<Care_Plan__c>();
                list<lead__c> ldlist = new list<lead__c>(); 
                
                
                for(integer i = 0 ;i<request.data.size();i++){
                    Care_Plan__c cp = new Care_Plan__c();
                    
                    if(string.isNotBlank(request.data[i].patientaddress)){
                        cp.Patient_Address__c = request.data[i].patientaddress;
                    }
                    if(string.isNotBlank(request.data[i].maxid)){
                        cp.Max_ID__c = request.data[i].maxid;
                    }
                    if(string.isNotBlank(request.data[i].mobilenumber)){
                        cp.Mobile_Phone__c = request.data[i].mobilenumber;
                    }
                    if(string.isNotBlank(request.data[i].channel)){
                        cp.Channel__c = request.data[i].channel;
                    }
                    if(string.isNotBlank(request.data[i].age)){
                        cp.Age__c = request.data[i].age;
                    }
                    if(string.isNotBlank(request.data[i].gender)){
                        cp.Gender__c = request.data[i].gender;
                    }
                    if(string.isNotBlank(request.data[i].admissiondate)){
                        date dt = date.valueOf(request.data[i].admissiondate);
                        cp.Admission_Date__c = date.newInstance(dt.year(), dt.month(), dt.day());
                    }
                    if(string.isNotBlank(request.data[i].totalhospitaldays)){
                        cp.Total_Hospital_days__c = request.data[i].totalhospitaldays;
                    }
                    if(string.isNotBlank(request.data[i].speciality)){
                        cp.Special__c = request.data[i].speciality;
                    }
                    if(string.isNotBlank(request.data[i].doctor)){
                        cp.doctorid__c = request.data[i].doctor;
                    }
                    if(string.isNotBlank(request.data[i].unit)){
                        cp.unitid__c = request.data[i].unit;
                    }
                    if(string.isNotBlank(request.data[i].LeadId)){
                        cp.Lead_Id__c = request.data[i].LeadId;
                    }
                    
                    careplanmap.put(cp.Max_ID__c,cp);
                    doctormap.put(cp.doctorid__c,null);
                    patientmap.put(cp.Max_ID__c,null);
                    specialmap.put(cp.Special__c,null);
                    businessmap.put(cp.unitid__c,null);
                    leadmap.put(cp.Max_ID__c,null);
                    
                }
                if(leadmap != null && leadmap.size()>0){
                    for(lead__c l : [select id , name,	Max_ID__c from lead__c 
                                     where RecordType.name = 'Max@Home'
                                     AND Stage__c not in ('Lead Won','Closed Lost')
                                     And Max_ID__c in :leadmap.keyset()]){
                                         
                                         leadmap.put(l.Max_ID__c,l);
                                     }
                }
                
                if(patientmap != null && patientmap.size()>0){
                    for(Account a : [select id,name,Max_ID__c from account 
                                     where RecordType.Name =:'Patient'
                                     And Max_ID__c in: patientmap.keyset()]){
                                         
                                         patientmap.put(a.Max_ID__c,a.Id);
                                     }
                }
                if(doctormap != null && doctormap.size()>0){
                    for(Account a : [select id,name,alletec_doctorid__c from account 
                                     where RecordType.Name =:'Doctor'
                                     And alletec_doctorid__c in: doctormap.keyset()]){
                                         
                                         doctormap.put(a.alletec_doctorid__c,a.Id);
                                     }
                }
                
                if(specialmap != null && specialmap.size()>0){
                    for(Speciality__c s : [select id, name,	HIS_ID__c from Speciality__c 
                                           where HIS_ID__c in : specialmap.keyset()]){
                                               
                                               specialmap.put(s.HIS_ID__c,s.id);
                                           }
                }
                
                if(businessmap != null && businessmap.size()>0){
                    for(Business_Unit__c b : [select id,name,HIS_ID__c from Business_Unit__c 
                                              where HIS_ID__c in: businessmap.keyset()]){
                                                  
                                                  businessmap.put(b.HIS_ID__c,b.id);
                                              }
                }
                
                if(careplanmap != null && careplanmap.size()>0){
                    for(string keyss : careplanmap.keyset()){
                        if(leadmap.containskey(keyss) &&  leadmap.get(keyss) !=NULL){
                            careplanmap.get(keyss).Lead__c = leadmap.get(keyss).id;
                            lead__c ld = new lead__c();
                            ld.Id =  careplanmap.get(keyss).lead__c;
                            ld.Care_Plan_Status__c = 'Completed';
                            ldlist.add(ld);
                            
                            if(patientmap.containskey(keyss)){
                                careplanmap.get(keyss).Patient_Name__c = patientmap.get(keyss);
                            }
                            
                            if(doctormap.containskey(careplanmap.get(keyss).doctorid__c)){
                                careplanmap.get(keyss).Doctor_Name__c = doctormap.get(careplanmap.get(keyss).doctorid__c);
                            }
                            if(specialmap.containskey(careplanmap.get(keyss).Special__c)){
                                careplanmap.get(keyss).Specialization__c = specialmap.get(careplanmap.get(keyss).Special__c);
                            }
                            if(businessmap.containskey(careplanmap.get(keyss).unitid__c)){
                                careplanmap.get(keyss).Unit__c = businessmap.get(careplanmap.get(keyss).unitid__c);
                            }
                            
                            insertlist.add(careplanmap.get(keyss));
                        }
                        
                    }
                }
                
                String ids='';
                if(insertlist != NULL && insertlist.size() > 0){
                    Database.SaveResult[] srList = Database.insert(insertlist,false);
                    Database.SaveResult[] srList2 = Database.update(ldlist,false);
                    for(Integer i=0;i<srList.size();i++){
                        ids += srList[i].getId() + ',';
                    }
                }
                ids = ids.removeEnd(',');
                String jsonStr = '{"success" : true,"message" : "Care Plan Record Create Successfully","ids":"'+ids+'"}';
                RestContext.response.addHeader('Content-Type', 'application/json');
                RestContext.response.responseBody = Blob.valueOf(jsonStr);
            }
        }
        
    }
    public class RequestBody{
        public list<bodydata> data;
        public RequestBody(){
            data = new list<bodydata>();
        }
    }
    public class bodydata{
        
        public string patientaddress;
        public string maxid;
        public string mobilenumber;
        public string channel;
        public string age;
        public string gender;
        public string speciality;
        public string doctor;
        public string admissiondate;
        public string totalhospitaldays;
        public string unit;
        public string LeadId;
        
    }
    
}