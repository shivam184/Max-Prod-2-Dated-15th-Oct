@RestResource(urlMapping='/maxhomebilling/*')
global class MaxHomeBillingAPIController {
    
    @httpPost
    global static void insertBillingSummary(){
        try{
            RestRequest request = RestContext.request;
            if(String.isNotBlank(request.requestBody.toString())){
                Map<String,Id> mapHisCodeToHospitalLocationId = new Map<String,Id>();
                Map<String,Id> mapAlleteDocIdToDoctorId = new Map<String,Id>();
                Map<String,Id> mapHisIdToSpecializationId = new Map<String,Id>();
                Map<String,Id> mapAlletecIdToDepartmentId = new Map<String,Id>();
                List<Lead__c> listToUpdateLead = new List<Lead__c>();
                List<Billing_Summary__c> listToInsertBilling = new List<Billing_Summary__c>();
                
                
                Billing_Summary__c bSummary = new Billing_Summary__c();
                RequestBodyWrapper requestBody = (RequestBodyWrapper)JSON.deserialize(request.requestBody.toString(),RequestBodyWrapper.class);                
                
                for(Business_Unit__c bUnit :[SELECT Id,HIS_ID__c FROM Business_Unit__c WHERE HIS_ID__c!= NULL])                             
                    mapHisCodeToHospitalLocationId.put(bUnit.HIS_ID__c,bUnit.Id);
                
                for(Account acc:[SELECT Id,alletec_doctorid__c FROM Account WHERE alletec_doctorid__c != NULL])
                    mapAlleteDocIdToDoctorId.put(acc.alletec_doctorid__c,acc.Id);                
                
                for(Speciality__c speciality:[SELECT Id,HIS_ID__c FROM Speciality__c WHERE HIS_ID__c != NULL])
                    mapHisIdToSpecializationId.put(speciality.HIS_ID__c,speciality.Id);                
                
                for(Department__c depart : [SELECT Id,alletec_id__c FROM Department__c WHERE alletec_id__c != NULL])
                    mapAlletecIdToDepartmentId.put(String.valueOf(depart.alletec_id__c),depart.Id);               
                
                if(String.isNotBlank(requestBody.maxid)){                    
                    listToUpdateLead = [SELECT Id,Assessment_Created_Date__c,Assessment_Stage__c,Assessment_Status__c,Stage__c FROM Lead__c WHERE Max_ID__c =: requestBody.maxid AND Stage__c NOT IN('Closed Lost','Lead Won') AND RecordType.Name = 'Max@Home'];
                    List<Account> accountList = [SELECT Id FROM Account WHERE Max_ID__c =: requestBody.maxid];
                    if(listToUpdateLead != NULL && listToUpdateLead.size() > 0)
                        bSummary.Tagged_Pre_Intimation__c = listToUpdateLead[0].Id;
                    if(accountList != NULL && accountList.size() > 0)
                        bSummary.Patient__c = accountList[0].Id;
                    bSummary.name__c = requestBody.maxid;
                }
                if(String.isNotBlank(requestBody.billno))
                    bSummary.invoicenumber__c = requestBody.billno;
                
                if(String.isNotBlank(requestBody.orderno)){
                    bSummary.Order_No__c = requestBody.orderno; 
                }                    
                if(String.isNotBlank(requestBody.billdate))
                    bSummary.alletec_billdate__c = Date.valueOf(requestBody.billdate);
                if(String.isNotBlank(requestBody.channelname))
                    bSummary.alletec_channeltype__c = requestBody.channelname;
                if(String.isNotBlank(requestBody.totalamount))
                    bSummary.alletec_hisamount__c = Decimal.valueOf(requestBody.totalamount);
                if(String.isNotBlank(requestBody.transactiontype))
                    bSummary.alletec_transactiontype__c = requestBody.transactiontype;
                if(String.isNotBlank(requestBody.ipid))
                    bSummary.alletec_ipid__c = requestBody.ipid;
                if(String.isNotBlank(requestBody.LeadId))
                    bSummary.Lead_Id__c = requestBody.LeadId;
                if(String.isNotBlank(requestBody.BillingType))
                    bSummary.Billing_Type__c = requestBody.BillingType;
                if(String.isNotBlank(requestBody.channel)){
                    //Need to Map
                }
                if(String.isNotBlank(requestBody.hospitallocation)){
                    if(mapHisCodeToHospitalLocationId.containsKey(requestBody.hospitallocation))
                        bSummary.alletec_hospitallocation__c = mapHisCodeToHospitalLocationId.get(requestBody.hospitallocation);
                }
                if(String.isNotBlank(requestBody.doctor)){
                    if(mapAlleteDocIdToDoctorId.containsKey(requestBody.doctor))
                        bSummary.alletec_doctorid__c = mapAlleteDocIdToDoctorId.get(requestBody.doctor);
                }
                if(String.isNotBlank(requestBody.speciality)){
                    if(mapHisIdToSpecializationId.containsKey(requestBody.speciality))
                        bSummary.alletec_speciality__c = mapHisIdToSpecializationId.get(requestBody.speciality);
                }
                if(String.isNotBlank(requestBody.department)){
                    if(mapAlletecIdToDepartmentId.containsKey(requestBody.department))
                        bSummary.alletec_department__c = mapAlletecIdToDepartmentId.get(requestBody.department);                    
                }
                if(String.isNotBlank(requestBody.serviceid)){                    
                    bSummary.Service_ID__c = requestBody.serviceid;
                    List<Services__c> serlst = [SELECT Id from Services__c where Service_Id__c=:requestBody.serviceid];
                    if(serlst.size() > 0)
                        bSummary.Services_Name__c = serlst[0].Id;  
                    listToInsertBilling.add(bSummary);
                } 
                
                //(requestBody.servicename == 'Nursing Services' || requestBody.servicename =='GDA Services' || requestBody.servicename == 'Phisio Services')               
                // if(String.isNotBlank(requestBody.servicename)){                    
                if( requestBody.BillingType=='F'){
                    if(listToUpdateLead != NULL && listToUpdateLead.size() > 0){
                        listToUpdateLead[0].Stage__c = 'Lead Won';
                        listToUpdateLead[0].Assessment_Status__c='Not Started';
                    }
                } 
                else If(requestBody.BillingType=='Y'){
                    listToUpdateLead[0].Assessment_Status__c='Started';
                }
                /*  if(requestBody.servicename == 'Assessment'){
if(listToUpdateLead != NULL && listToUpdateLead.size() > 0){
listToUpdateLead[0].Assessment_Status__c = 'Created';
listToUpdateLead[0].Assessment_Stage__c = listToUpdateLead[0].Stage__c ;
listToUpdateLead[0].Assessment_Created_Date__c = System.today(); 
}
}*/
                
                // }                  
                
                
                
                if(listToInsertBilling != NULL && listToInsertBilling.size() > 0){                
                    Insert listToInsertBilling;
                }
                
                if(listToUpdateLead != NULL && listToUpdateLead.size() > 0){                
                    Update listToUpdateLead;
                }
                
                String jsonStr = '{"success" : true,"message" : "Billing Summary Created Successfully","id" :"'+bSummary.Id+'"}';
                RestContext.response.addHeader('Content-Type', 'application/json');
                RestContext.response.responseBody = Blob.valueOf(jsonStr);
                return;
            }
            else {
                String jsonStr = '{"success" : false,"message" : "Provide Body"}';
                RestContext.response.addHeader('Content-Type', 'application/json');
                RestContext.response.responseBody = Blob.valueOf(jsonStr);
                return;     
            }            
        }   
        catch(Exception e){
            String jsonStr = '{"success" : false,"message" : "'+e.getMessage()+'"}';
            RestContext.response.addHeader('Content-Type', 'application/json');
            RestContext.response.responseBody = Blob.valueOf(jsonStr);
            return; 
        }
    }
    
    public Class RequestBodyWrapper{
        public String maxid;
        public String billno;
        public String orderno;        
        public String servicename;
        public String serviceid;
        public String billdate;
        public String channelname;
        public String totalamount;
        public String transactiontype;        
        public String ipid;
        public String channel;
        public String hospitallocation;
        public String doctor;
        public String speciality;
        public String department;
        public string LeadId;
        public string BillingType;
    }
}