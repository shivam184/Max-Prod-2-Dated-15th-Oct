public class UploadDocumentApex {
    
    @auraEnabled
    public static WrapperClass doInitApex(String recordId) {
        WrapperClass wrpCls = new WrapperClass();
        try {
            List<ContentDocumentLink> listContentDoc = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :recordId];
            if(listContentDoc != NULL && listContentDoc.size() > 0) {
            	wrpCls.showComponent = false;
            	wrpCls.status = 'SUCCESS';    
            }
            else{
            	wrpCls.status = 'SUCCESS';
                Schema.DescribeFieldResult fieldResult = ContentVersion.File_Type__c.getDescribe();
                List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
                for(Schema.PicklistEntry f : ple)
                    wrpCls.listFileType.add(f.getValue());    
            }
            return wrpCls;
        }
        catch(Exception e) {
            wrpCls.status = e.getMessage();
            return wrpCls;
        }
    }
    
    @auraEnabled 
    public static String handleSaveApex(String recordId,String base64Data,String selectedFileType,String notes,String fileName) {
        try {
            ContentVersion content =new ContentVersion(); 
            content.Title = fileName; 
            List<String> dataencode =base64Data.split(',');
            if(dataencode != NULL && dataencode.size() >= 2)
                content.VersionData=EncodingUtil.base64Decode(dataencode[1]);
            if(String.isNotBlank(notes))
            	content.Notes__c = notes;
            content.File_Type__c = selectedFileType;
            content.PathOnClient= '/' + fileName;
            insert content; 
            
            content = [select id,ContentDocumentId from ContentVersion WHERE Id = :content.Id];
            ContentDocumentLink cl = new ContentDocumentLink();
            cl.ContentDocumentId = content.ContentDocumentId;
            cl.LinkedEntityId = recordId; 
            cl.ShareType = 'V';
            insert cl; 
            /*
            if(String.isNotBlank(selectedFileType)){
                if(selectedFileType == 'E-Prescription') {
                    Lead__c lead = new Lead__c();
                    lead.Id = recordId;
                    lead.Is_Document_Uploaded__c = 'YES';
                    update lead;
                }
            }
			*/
            if(String.isNotBlank(recordId)){
            	Lead__c lead = new Lead__c();
                lead.Id = recordId;
                lead.Is_Document_Uploaded__c = 'YES';
                update lead;    
            }
            
            return 'SUCCESS';
        }
        catch(Exception e) {
            return e.getMessage();
        }
    }
    
    public class WrapperClass {
        @auraEnabled
        public String status;
        @auraEnabled
        public List<String> listFileType;
        @auraEnabled
        public Boolean showComponent;
        
        public WrapperClass() {
            status = '';
            listFileType = new List<String>();
            showComponent = true;
        }
    }
}