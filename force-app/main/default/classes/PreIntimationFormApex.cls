public class PreIntimationFormApex {
    
    @auraEnabled
    public static WrapperClass doInItApex() {
        WrapperClass wrpCls = new WrapperClass();
        wrpCls.ownerName = userInfo.getName();
        
        Schema.DescribeFieldResult fieldResult = Lead__c.Department__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry f : ple)
            wrpCls.listDepartment.add(f.getValue());
        
        Schema.DescribeFieldResult fieldResult2 = Lead__c.Pre_Intimation_Status__c.getDescribe();
        List<Schema.PicklistEntry> ple2 = fieldResult2.getPicklistValues();
        for(Schema.PicklistEntry f : ple2)
            wrpCls.listPreIntimationStatus.add(f.getValue());
        
        List<User> listUser = [SELECT Business_Unit__c FROM USER WHERE Id = :UserInfo.getUserId()];
        
        Map<String,String> buMap = new map<String,String>();
        for(Business_Unit_Mapping__mdt bu : [SELECT MasterLabel, Dual_units__c FROM Business_Unit_Mapping__mdt]){
            if(String.isNotBlank(bu.Dual_units__c)) 
                buMap.put(bu.MasterLabel,bu.Dual_units__c);
        }
        
        
        if(buMap.containsKey(listUser[0].Business_Unit__c)){
            wrpCls.listBusinessUnit.addAll(buMap.get(listUser[0].Business_Unit__c).split(';'));
        }
        
        Schema.DescribeFieldResult fieldResult3 = ContentVersion.File_Type__c.getDescribe();
        List<Schema.PicklistEntry> ple3 = fieldResult3.getPicklistValues();
        for(Schema.PicklistEntry f : ple3)
            wrpCls.listFileType.add(f.getValue());
        
        return wrpCls;
    }
    @auraEnabled 
    public static String getdepartment(string docid){
        if(docid != null){
            account Speciality = [select SF_Speciality__c,id from account where id = :docid];
            Speciality__c depname = [select id, alletec_department__r.name from Speciality__c where id = :Speciality.SF_Speciality__c];
            system.debug(depname);
            return depname.alletec_department__r.name;}
        else
            return null;
        
    }
    
    @auraEnabled 
    public static String doSaveApex(String patientName,String selectedMecpNameId,String mecpSource,String treatingDoctorNameId,String ailment,String businessUnit,String selectedUploadDocument,String fileName,String base64Data,String notes,String selectedFileType,DateTime drIntimationDateTime,String age,String selectedDepartment) {
        try {
            Id recordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('MECP').getRecordTypeId();
            Lead__c lead = new Lead__c();
            lead.Name = patientName;
            if(String.isNotBlank(businessUnit))
                lead.Business_Unit__c = businessUnit;
            else {
                List<User> listUser = [SELECT Business_Unit__c FROM USER WHERE Id = :UserInfo.getUserId()];
                if(listUser != NULL && listUser.size() > 0) {
                    if(String.isNotBlank(listUser[0].Business_Unit__c)) {
                        lead.Business_Unit__c = listUser[0].Business_Unit__c;
                    }
                }
            }
            if(age != NULL)
                lead.Patient_Age__c = Integer.valueOf(age);
            if(String.isNotBlank(selectedDepartment))
                lead.Department__c = selectedDepartment;
            
            if(selectedMecpNameId != NULL && selectedMecpNameId != '')
                lead.MECP_Name__c = selectedMecpNameId;
            if(mecpSource != NULL && mecpSource != '')
                lead.MECP_Source__c = mecpSource;
            if(treatingDoctorNameId != NULL && treatingDoctorNameId != '')
                lead.Treating_Doctor__c = treatingDoctorNameId;
            lead.Ailment__c = ailment;
            lead.Is_Document_Uploaded__c = selectedUploadDocument;
            if(recordTypeId != NULL)
                lead.RecordTypeId = recordTypeId;
            if(drIntimationDateTime !=  NULL) {
                lead.Dr_Intimation_Date_Time__c = drIntimationDateTime;
            }
            
            insert lead;
            
            if(String.isNotBlank(base64Data)) {
                ContentVersion content =new ContentVersion(); 
                content.Title = fileName; 
                //List<String> dataencode =base64Data.split(',');
                content.VersionData=EncodingUtil.base64Decode(base64Data);
                content.Notes__c = notes;
                content.File_Type__c = selectedFileType;
                content.PathOnClient= '/' + fileName;
                insert content; 
                
                content = [select id, ContentDocumentId from ContentVersion WHERE Id =: Content.Id];
                ContentDocumentLink cl = new ContentDocumentLink();
                cl.ContentDocumentId = content.ContentDocumentId;
                cl.LinkedEntityId = lead.Id; 
                cl.ShareType = 'V';
                insert cl;
            } 
            return 'SUCCESS*'+lead.Id;
        }
        catch(Exception e) {
            return 'ERROR : '+e.getMessage();
        }
    }
    
    public class WrapperClass {
        @auraEnabled
        public String ownerName;
        @auraEnabled
        public List<String> listDepartment;
        @auraEnabled 
        public List<String> listPreIntimationStatus;
        @auraEnabled
        public List<String> listBusinessUnit;
        @auraEnabled
        public String selectedBusinessUnit;   
        @auraEnabled
        public List<String> listFileType;
        public WrapperClass() {
            ownerName = '';
            listDepartment = new List<String>();
            listPreIntimationStatus = new List<String>();
            listBusinessUnit = new List<String>();
            selectedBusinessUnit = '';
            listFileType = new List<String>();
        }
    }
}