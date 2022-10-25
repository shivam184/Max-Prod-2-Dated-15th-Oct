//Description : Apex Class to create Leads for Customer Activations (Customer Program Management)
//Created by: Techmatrix Consulting



public class AddFamilyMemberApex {
    
    public static String businessUnit;
    
    public static void populateBusinesUnit(){
        List<User> usrList = new list<User>([SELECT Id,Business_Unit__c FROM User WHERE Id=:UserInfo.getUserId()]);
        if(String.isNotBlank(usrList[0].Business_Unit__c))
            businessUnit = usrList[0].Business_Unit__c;
        
    }
    
    @AuraEnabled
    public static String fetchPrimaryMember(String leadRecordId) {
        populateBusinesUnit();
        String primaryMemberId;
        for(Lead__c record : [SELECT Id,Primary_Member__c ,Family_Member__c,Membership_Enrolment_Type__c  FROM Lead__c WHERE Id=:leadRecordId]){
            if(record.Primary_Member__c)
                primaryMemberId = record.Id;
            else
                primaryMemberId = record.Family_Member__c;
            
            primaryMemberId+='#'+record.Membership_Enrolment_Type__c;
        }
        
        return primaryMemberId;
    }
    
    @AuraEnabled
    public static list<String> getOccupations(){
        populateBusinesUnit();
        list<String> occupation = new list<String>();
        Schema.DescribeFieldResult fieldResult1 = Lead__c.Present_Occupation__c.getDescribe();
        List<Schema.PicklistEntry> ple1 = fieldResult1.getPicklistValues();
        for(Schema.PicklistEntry f : ple1)
            occupation.add(f.getValue());
        return occupation;
    }
    
    @AuraEnabled
    public static list<String> getEnrolmentTypes(){
        populateBusinesUnit();
        map<String,String> optMap = new map<String,String>();
        for(CMP_Enrolment_Program__mdt cmp : [SELECT Business_Unit_HIS__c,Membership_Enrolment_Type__c FROM CMP_Enrolment_Program__mdt]){
            optMap.put(cmp.Business_Unit_HIS__c,cmp.Membership_Enrolment_Type__c);
        }
        
        list<String> strList = new list<String>();
        if(String.isNotBlank(businessUnit))
            if(optMap.containsKey(businessUnit))
            strList = optMap.get(businessUnit).split(';');
        
        return strList;
    }
    
    
    @AuraEnabled
    public static Lead__c setMasterValues(String recordId, Lead__c ld){
        for(Customer_Activation__c cust : [SELECT City_AddressMaster__c, City_AddressMaster__r.Name,HIS_Locality__c, HIS_Locality__r.Name,
                                           Pin_Code_Master__c FROM  Customer_Activation__c WHERE Id=:recordId]){
                                               if(cust.City_AddressMaster__c!=null)
                                                   ld.City__c = cust.City_AddressMaster__r.Name;
                                               if(cust.HIS_Locality__c!=null)
                                                   ld.Locality__c = cust.HIS_Locality__r.Name;
                                               if(String.isNotBlank(cust.Pin_Code_Master__c))
                                                   ld.ZIP_Postal_Code__c = cust.Pin_Code_Master__c;
                                               ld.Health_Camp__c = cust.Id;
                                           }
        
        return ld;
    }
    
    @AuraEnabled
    public static AddFamilyMemberApex.patientWrapper searchinSalesforce(String mobileNo, Boolean searchHIS){
        AddFamilyMemberApex.patientWrapper awrap = new AddFamilyMemberApex.patientWrapper();
        
        if(String.isNotBlank(mobileNo)){
            awrap.isSuccess = true;
            list<Account> accList = new list<Account>([SELECT Id,FirstName,MiddleName,LastName,Phone,PersonMobilePhone,PersonEmail,Max_ID__c,
                                                       CityAddressMaster__c,CityAddressMaster__r.Name,BillingStreet,Postal_Code__c,
                                                       Gender__c,DOB__c,Age__c FROM Account WHERE Recordtype.Name='Patient' 
                                                       and (Phone=:mobileNo OR PersonMobilePhone=:mobileNo)]);
            if(accList!=null && accList.size()>0){
                awrap.isExisiting = true;
                if(accList.size()==1){
                    awrap = mapPatientsWithWrapper(awrap,accList,false);
                }
                else{
                    awrap.moreThanOnePat = true;
                    awrap = mapPatientsWithWrapper(awrap,accList,true);
                }
            }
            else{
                if(searchHIS)
                    awrap = searchHISMember(mobileNo);
                else
                    awrap.isNewPat = true;
            }
        }
        return awrap;
    }
    
    
    //Method to map patient details with wrapper variables
    public static AddFamilyMemberApex.patientWrapper mapPatientsWithWrapper(AddFamilyMemberApex.patientWrapper wrapper, list<Account> patList, Boolean isMorethanOne){
        if(isMorethanOne){
            for(Account patient : patList){
                PatientSearchJsonParser.Patients tempPat = new PatientSearchJsonParser.Patients();
                
                if(patient.Phone!=null || patient.PersonMobilePhone!=null){
                    if(patient.Phone!=null)
                        tempPat.MobileNo = patient.Phone;
                    else if(patient.PersonMobilePhone!=null)
                        tempPat.MobileNo = patient.PersonMobilePhone;                        
                }
                
                if(String.isNotBlank(patient.Max_ID__c))
                    tempPat.MaxID = patient.Max_ID__c;
                if(String.isNotBlank(patient.FirstName))
                    tempPat.FirstName = patient.FirstName;
                if(String.isNotBlank(patient.LastName))
                    tempPat.LastName = patient.LastName;
                if(String.isNotBlank(patient.PersonEmail))
                    tempPat.EmailID = patient.PersonEmail;
                if(patient.CityAddressMaster__c!=null)
                    tempPat.CityName = patient.CityAddressMaster__r.Name; 
                if(String.isNotBlank(patient.Postal_Code__c))
                    tempPat.PinCode = Integer.valueOf(patient.Postal_Code__c);
                if(String.isNotBlank(patient.BillingStreet))
                    tempPat.Address = patient.BillingStreet;
                if(String.isNotBlank(patient.Gender__c))
                    tempPat.Gender = patient.Gender__c;
                if(patient.DOB__c!=null){
                    String dob = String.valueOf(patient.DOB__c);
                    list<String> strList = dob.split('-');
                    tempPat.DateOfBirth = strList[2]+'/'+strList[1]+'/'+strList[0]  ;
                }
                if( patient.Age__c!=null)
                    tempPat.AgeINT = Integer.valueOf(patient.Age__c);
                
                //Mapping Member Details for more than one patient
                AddFamilyMemberApex.maxWrapper maxWrap = new AddFamilyMemberApex.maxWrapper();
                maxWrap.maxId = patient.Max_ID__c;
                maxWrap.patLabel = patient.Max_ID__c+' -';
                if(String.isNotBlank(patient.FirstName))
                    maxWrap.patLabel+=' '+patient.FirstName;
                if(String.isNotBlank(patient.LastName))
                    maxWrap.patLabel+=' '+patient.LastName; 
                wrapper.maxIdwrap.add(maxWrap);
                wrapper.patientDetailMap.put(patient.Max_ID__c,mapDetails(tempPat));
            }
        }
        else{
            PatientSearchJsonParser.Patients tempPat = new PatientSearchJsonParser.Patients();
            if(patList[0].Phone!=null || patList[0].PersonMobilePhone!=null){
                if(patList[0].Phone!=null)
                    tempPat.MobileNo = patList[0].Phone;
                else if(patList[0].PersonMobilePhone!=null)
                    tempPat.MobileNo = patList[0].PersonMobilePhone;                        
            }
            
            if(String.isNotBlank(patList[0].Max_ID__c))
                tempPat.MaxID = patList[0].Max_ID__c;
            if(String.isNotBlank(patList[0].FirstName))
                tempPat.FirstName = patList[0].FirstName;
            if(String.isNotBlank(patList[0].LastName))
                tempPat.LastName = patList[0].LastName;
            if(String.isNotBlank(patList[0].PersonEmail))
                tempPat.EmailID = patList[0].PersonEmail;
            if(patList[0].CityAddressMaster__c!=null)
                tempPat.CityName = patList[0].CityAddressMaster__r.Name; 
            if(String.isNotBlank(patList[0].Postal_Code__c))
                tempPat.PinCode = Integer.valueOf(patList[0].Postal_Code__c);
            if(String.isNotBlank(patList[0].BillingStreet))
                tempPat.Address = patList[0].BillingStreet;
            if(String.isNotBlank(patList[0].Gender__c))
                tempPat.Gender = patList[0].Gender__c;
            if(patList[0].DOB__c!=null){
                String dob = String.valueOf(patList[0].DOB__c);
                list<String> strList = dob.split('-');
                tempPat.DateOfBirth = strList[2]+'/'+strList[1]+'/'+strList[0]  ;
            }
            if( patList[0].Age__c!=null)
                tempPat.AgeINT = Integer.valueOf(patList[0].Age__c);
            wrapper.leadObj = mapDetails(tempPat);
        }
        return wrapper;
    }
    
    
    //Search Members from HIS/Salesforce
    //Based on value in Custom Metadata type, method searches in Salesforce and HIS or both.
    @AuraEnabled
    public static AddFamilyMemberApex.patientWrapper searchMember(String mobileNo){
        populateBusinesUnit();
        
        AddFamilyMemberApex.patientWrapper awrap = new AddFamilyMemberApex.patientWrapper();
        
        String searchLocation;
        for(HIS_API_Search_Criteria__mdt search : [SELECT Id,API_Search__c FROM HIS_API_Search_Criteria__mdt])
            if(String.isNotBlank(search.API_Search__c))
            searchLocation = search.API_Search__c;
        
        //Check where to search for Patient Details and search accordingly
        if(String.isNotBlank(searchLocation)){ 
            if(searchLocation=='Salesforce')
                awrap = searchinSalesforce(mobileNo,false);
            else if(searchLocation=='HIS')
                awrap = searchHISMember(mobileNo);
            else if(searchLocation=='Salesforce & HIS')
                awrap = searchinSalesforce(mobileNo,true);
        }
        return awrap;
    }
    
    
    public static AddFamilyMemberApex.patientWrapper searchHISMember(String mobileNo){
        AddFamilyMemberApex.patientWrapper awrap = new AddFamilyMemberApex.patientWrapper();
        OutboundAPIUtilityController.fetchDetailsFromMetadata(system.label.PatientSearch);
        String endpoint = OutboundAPIUtilityController.endpoint;
        
        String apikeyHeader = OutboundAPIUtilityController.apikeyHeader;
        String timeStampHeader = OutboundAPIUtilityController.timeStampHeader;
        String signatureHeader = OutboundAPIUtilityController.signatureHeader;
        String dtFormat = OutboundAPIUtilityController.dtFormat;
        String api_key = OutboundAPIUtilityController.api_key;
        String signature = OutboundAPIUtilityController.generateSignature(system.label.PatientSearch,mobileNo);  
        String body = '{"MaxID":"",  "MobileNo": "'+mobileNo+'",  "Source": "SalesForce"}';
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setHeader(apikeyHeader,api_key);
        request.setHeader(timeStampHeader,system.now().format(dtFormat));
        request.setHeader(signatureHeader,signature);
        request.setHeader('Content-Type', 'application/json');
        request.setEndpoint(endpoint);
        request.setBody(body);
        request.setMethod('POST');
        
        HttpResponse response = new HttpResponse();
        
        if(!test.isRunningTest()){
            response = http.send(request);
            system.debug('body-->'+response.getBody());
            if(response.getStatusCode()==200){
                if(String.isNotBlank(response.getBody())){
                    Map<String,Object> tempMap = (Map<String,Object>)JSON.deserializeUntyped(response.getBody());
                    if(tempMap.get('Status')=='Success'){
                        awrap.isSuccess = true;
                        PatientSearchJsonParser japex = PatientSearchJsonParser.parse(response.getBody());
                        
                        if(japex.Patients!=null && japex.Patients.size()>0){
                            awrap.isExisiting = true;
                            if(japex.Patients.size()==1){
                             // system.debug('body-->1');
                                PatientSearchJsonParser.Patients tempPat = new PatientSearchJsonParser.Patients();
                                tempPat = japex.Patients[0];
                                awrap.leadObj = mapDetails(tempPat);
                            }
                            else{ 
                                           // system.debug('body-->2'+japex.Patients.size());
                                populateBusinesUnit();
                                awrap.moreThanOnePat = true;
                                for(PatientSearchJsonParser.Patients patient : japex.Patients){
                                    AddFamilyMemberApex.maxWrapper maxWrap = new AddFamilyMemberApex.maxWrapper();
                                    maxWrap.maxId = patient.MaxID;
                                    maxWrap.patLabel = patient.MaxID+' - '+patient.PatientName;
                                    awrap.maxIdwrap.add(maxWrap);
                                    awrap.patientDetailMap.put(patient.MaxID,mapDetails(patient));
                                }
                            }
                        }
                        else{
                            awrap.isNewPat = true;
                        }
                    }
                }
            }
        }else{
            response.setBody('TEST BODY');
        }
        return awrap;
    }
    
    
    
    //Map field values of Leads(Members)
    public static Lead__c mapDetails (PatientSearchJsonParser.Patients tempPat){
        Lead__c obj = new Lead__c();
        obj.Business_Unit__c =businessUnit;// [SELECT Id,Business_Unit__c FROM User WHERE Id=:UserInfo.getUserId()].Business_Unit__c;
        obj.Name = '';
        if(String.isNotBlank(tempPat.MobileNo))
            obj.Mobile_Phone__c = tempPat.MobileNo;
        if(String.isNotBlank(tempPat.MaxID))
            obj.Max_ID__c = tempPat.MaxID;
        if(String.isNotBlank(tempPat.FirstName)){
            obj.First_Name__c = tempPat.FirstName;
            obj.Name = tempPat.FirstName;
        }
        if(String.isNotBlank(tempPat.LastName)){
            obj.Last_Name__c = tempPat.LastName;
            obj.Name+=' '+obj.Last_Name__c;
        }
        if(String.isNotBlank(tempPat.EmailID))
            obj.Email__c = tempPat.EmailID;
        if(String.isNotBlank(tempPat.CityName))
            obj.City__c = tempPat.CityName;
        if(String.isNotBlank(tempPat.Area))
            obj.Locality__c = tempPat.Area;
        if(tempPat.PinCode!=null)
            obj.ZIP_Postal_Code__c = String.valueOf(tempPat.PinCode);
        if(String.isNotBlank(tempPat.Address))
            obj.Address_Line_1__c = tempPat.Address;
        if(String.isNOtBlank(tempPat.Gender))
            obj.Gender__c = tempPat.Gender;
        if(tempPat.DateOfBirth!=null){
            list<String> strList = tempPat.DateOfBirth.split('/');
            obj.DOB__c = Date.valueOf(strList[2]+'-'+strList[1]+'-'+strList[0]);
        }
        if(tempPat.AgeINT!=null)
            obj.CMP_Age__c = tempPat.AgeINT;  
        return obj;
    }
    
    //Validate MemberDetails
    @AuraEnabled
    public static String validateMemberDetails(Lead__c exisitingLead, String primaryMember, Boolean isNewWithExist){
        String message = 'OK';
        
        //system.debug('exisitingLead-->'+exisitingLead);
        if(!isNewWithExist && exisitingLead.Want_to_Enrol__c){
            if(String.isNotBlank(exisitingLead.Max_ID__c) && String.isNotBlank(exisitingLead.Business_Unit__c)){
                list<Lead__c> leadList = new list<Lead__c>([SELECT Id,Max_ID__c,Business_Unit__c FROM Lead__c 
                                                            WHERE RecordType.Name=:'CMP' AND Max_ID__c=:exisitingLead.Max_ID__c
                                                            AND Business_Unit__c=:exisitingLead.Business_Unit__c and Membership_Enrolment_Type__c!=null]);
                
                if(leadList!=null && leadList.size()>0){
                    message = 'A customer with thix Max ID already exists for this Location';
                }
            }
            if(String.isBlank(exisitingLead.Max_ID__c) && exisitingLead.Mobile_Phone__c!=null && exisitingLead.Name!=null){
                
                list<Lead__c> ldLIst = new list<Lead__c>([SELECT Id,Name,Mobile_Phone__c FROM Lead__c
                                                          WHERE Mobile_Phone__c=:exisitingLead.Mobile_Phone__c
                                                          AND Name=:exisitingLead.Name and Membership_Enrolment_Type__c!=null]);
                if(ldLIst!=null && ldLIst.size()>0)
                    message = 'A customer with this mobile no. already exists for this Location';
                
            }
        }
        
        if(String.isNotBlank(primaryMember)){
            list<Lead__c> prmaryLead = new list<Lead__c>([SELECT Id,Membership_Enrolment_Type__c,(SELECT Id FROM Family_Members__r) FROM Lead__c WHERE Id=:primaryMember]);
            if(prmaryLead!=null && prmaryLead.size()>0){
                if(String.isNotBlank(prmaryLead[0].Membership_Enrolment_Type__c)){
                    String memtype = prmaryLead[0].Membership_Enrolment_Type__c;
                    if(memtype==label.Enrollment_Type_Citizen){
                        if(exisitingLead.CMP_Age__c!=null && exisitingLead.CMP_Age__c<55)
                            message = 'For Citizen Plus age cannot be less than 55';
                        else if(prmaryLead[0].Family_Members__r!=null && prmaryLead[0].Family_Members__r.size()>0)
                            message = 'For Citizen Plus, only one family member can be added';
                    }
                    else{
                        if(memtype==label.Enrolment_Health_Family){
                            if(prmaryLead[0].Family_Members__r!=null && prmaryLead[0].Family_Members__r.size()>0){
                                Integer size = prmaryLead[0].Family_Members__r.size();
                                if(size==5)
                                    message = 'For Healthy Family, only five family members can be added'; 
                            }
                        }
                    }
                }
            }
        }
        //system.debug('message-->'+message);
        return message;
    }
    
    //Save Method
    @AuraEnabled
    public static String saveMemberDetails(Lead__c leadObj, String primaryMember, Boolean isExisting,  Boolean isExistWithNew, String leadPhone, Boolean isPrimary, String fileName, String fileBase64){
        system.debug('====leadObj'+leadObj);
        system.debug('====primaryMember'+primaryMember);
        system.debug('====isExisting'+isExisting);
        system.debug('====leadisExistingObj'+isExisting);
        system.debug('====isExistWithNew'+isExistWithNew);
        system.debug('====leadPhone'+leadPhone);
        system.debug('====isPrimary'+isPrimary);
        system.debug('====fileName'+fileName);
        //system.debug('====fileBase64'+fileBase64);

        
        
        //  try{ 
            leadObj.Name ='';
            if(String.isNotBlank(primaryMember))
                leadObj.Family_Member__c = primaryMember;
            if(String.isNotBlank(leadObj.First_Name__c))
                leadObj.Name = leadObj.First_Name__c;
            if(String.isNotBlank(leadObj.Last_Name__c))
                leadObj.Name +=' '+leadObj.Last_Name__c;
            
            if(String.isNotBlank(leadPhone))
                leadObj.Mobile_Phone__c = leadPhone;
            if(isExistWithNew){
                leadObj.Max_ID__c = null;
                leadObj.New_Contact_With_Existing_Mobile__c = true;
            }
            if(isExisting)
                leadObj.Existing_Patient__c=true;
            
            leadObj.recordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('CMP').getRecordTypeId();
            leadObj.Business_Unit__c  = [SELECT Id,Business_Unit__c FROM User WHERE Id=:UserInfo.getUserId()].Business_Unit__c;
            system.debug( 'ghoulllllll>>>>>'+leadObj.Business_Unit__c);
            if(String.isNotBlank(primaryMember)){
                list<Lead__c> prmaryLead = new list<Lead__c>([SELECT Id,Membership_Enrolment_Type__c,Health_Camp__c,Health_Camp__r.HIS_Locality__c,
                                                              Health_Camp__r.HIS_Locality__r.Name, Health_Camp__r.Pin_Code_Master__c,  
                                                              Health_Camp__r.City_AddressMaster__c, Health_Camp__r.City_AddressMaster__r.Name
                                                              FROM Lead__c WHERE Id=:primaryMember]);
                if(prmaryLead!=null && prmaryLead.size()>0){
                    if(String.isNotBlank(prmaryLead[0].Membership_Enrolment_Type__c)){
                        leadObj.Membership_Enrolment_Type__c = prmaryLead[0].Membership_Enrolment_Type__c;
                        if(prmaryLead[0].Membership_Enrolment_Type__c==label.Enrollment_Type_Citizen)
                            leadObj.Relationship__c = label.Citizen_Plus_Relation;
                        if(prmaryLead[0].Membership_Enrolment_Type__c==label.Enrolment_Health_Family)
                            leadObj.Relationship__c = label.Healthy_Family_Relationship;
                    }
                    
                    if(prmaryLead[0].Health_Camp__c!=null){
                        leadObj.Health_Camp__c= prmaryLead[0].Health_Camp__c;
                        if(prmaryLead[0].Health_Camp__r.HIS_Locality__c!=null && String.isBlank(leadObj.Locality__c))
                            leadObj.Locality__c = prmaryLead[0].Health_Camp__r.HIS_Locality__r.Name;
                        if(prmaryLead[0].Health_Camp__r.City_AddressMaster__c!=null && String.isBlank(leadObj.City__c))
                            leadObj.City__c = prmaryLead[0].Health_Camp__r.City_AddressMaster__r.Name;
                        if(prmaryLead[0].Health_Camp__r.Pin_Code_Master__c!=null && String.isBlank(leadObj.ZIP_Postal_Code__c))
                            leadObj.ZIP_Postal_Code__c = prmaryLead[0].Health_Camp__r.Pin_Code_Master__c;
                    }
                }
            }
            
            if(isPrimary){
                leadObj.Primary_Member__c = true;
                if(String.isNotBlank(leadObj.Membership_Enrolment_Type__c)){
                    if(leadObj.Membership_Enrolment_Type__c==label.Enrollment_Type_Citizen)
                        leadObj.Relationship__c = label.Citizen_Plus_Relation;
                    if(leadObj.Membership_Enrolment_Type__c==label.Enrolment_Health_Family)
                        leadObj.Relationship__c = label.Healthy_Family_Relationship;
                }
            }
            
            
            
            //Insert member
            insert leadObj;
            
            if(leadObj.Stage__c=='Referred to Max' && leadObj.Doctor__c!= null)
            {
                list<Doctor_Coordinator_Master__c> dcm =[select Co_ordinator__c 
                                                         from Doctor_Coordinator_Master__c
                                                         where Doctor__c =: leadObj.Doctor__c
                                                         and Business_unit__r.name =: leadObj.Business_Unit__c ];
                if(dcm!=null && dcm.size()>0)
                {
                    lead__share ls = new lead__share();
                    ls.ParentId = leadObj.Id;
                    ls.UserOrGroupId = dcm[0].Co_ordinator__c;
                    ls.AccessLevel = 'edit';
                    insert ls;
                }
            }
            
            if(String.isNotBlank(fileName) && String.isNotBlank(fileBase64))
                attachFile(fileName,fileBase64,leadObj.Id);
            
            return 'Success#'+leadObj.Id;
       // }catch(Exception e){
       //     return e.getMessage();
      //  } 
    } 
    
    //Upload File to the Lead if attached
    public static void attachFile(String fileName, String base64Value, String parentId){
        ContentVersion conVer = new ContentVersion();
        conVer.isMajorVersion  = false;
        conVer.PathOnClient = fileName; // The files name, extension is very important here which will help the file in preview.
        conVer.Title = fileName; // Display name of the files
        conVer.VersionData = EncodingUtil.base64Decode(base64Value); // converting your binary string to Blog
        
        insert conVer;
        
        ContentDocumentLink cDe = new ContentDocumentLink();
        cDe.ContentDocumentId = [SELECT Id,ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId; 
        cde.LinkedEntityId = parentId;
        cDe.ShareType = 'I'; // Inferred permission, checkout description of ContentDocumentLink object for more details 
        insert cDe;
    }
    
    public class patientWrapper {
        @AuraEnabled
        public Boolean isExisiting ;
        @AuraEnabled
        public Boolean isNewPat;
        @AuraEnabled
        public Boolean isExistButNewPat;
        @AuraEnabled
        public Boolean moreThanOnePat;
        @AuraEnabled
        public Boolean isSuccess;
        @AuraEnabled
        public Lead__c leadObj;
        @AuraEnabled
        public list<AddFamilyMemberApex.maxWrapper> maxIdwrap;
        @AuraEnabled
        public map<String,Lead__c> patientDetailMap;
        
        public patientWrapper(){
            isExisiting = false;
            isNewPat = false;
            isExistButNewPat = false;
            moreThanOnePat = false;
            isSuccess = false;
            leadObj = new Lead__c();
            patientDetailMap = new map<String,Lead__c>();
            maxIdwrap = new list<AddFamilyMemberApex.maxWrapper>();
        }
    }
    
    //Child Wrapper
    public class maxWrapper {
        @AuraEnabled
        public String maxId;
        @AuraEnabled
        public String patLabel;
    }
    
    
}