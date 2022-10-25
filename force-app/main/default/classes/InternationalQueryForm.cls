public class InternationalQueryForm {
    
    @auraEnabled
    public static string doSaveLead(Lead__c ld,String country,String hcfpartner, string wrapLst){
        
        
        try{
            WrapperClass wrpCls = new WrapperClass();
            system.debug('wrapper List 1===>' +wrapLst);
            List<WrapperClass> WrapList =(List<WrapperClass>) JSON.deserialize(wrapLst, List<WrapperClass>.class);
            system.debug('wrapper List Data===>' +WrapList);
            ld.RecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('International Query Management').getRecordTypeId();
            
            
            if(ld.First_Name__c!=null)
                ld.Name = ld.First_Name__c+' '+ld.Last_Name__c;
            else
                ld.Name = ld.Last_Name__c;
            if(country!='')
                ld.Country_Query__c = country;
            ld.LeadType__c = 'International Query';
            ld.Stage__c = 'New Query';
            ld.Lead_Channel__c='International';
            ld.Lead_Source__c='Email';
            ld.Intlr_Intimation_Date__c=system.today();
            if(hcfpartner!='') {
                ld.HCF_Partner__c = hcfpartner;
            }
            List<ContentVersion> conversionList = new List<ContentVersion>();
            Set<Id> ConID = New Set<Id>();
            List<String> Fnamelist = new List<String>();
            List<ContentDocumentLink> ConDucmentList = new List<ContentDocumentLink>();
            
           if(!test.isRunningTest()){
                insert ld;
                
            }
            for(WrapperClass wr  : WrapList)
            {
                ContentVersion cv = new ContentVersion();
                if(wr.fname!='' && wr.base64 !=''){
                cv.Title = wr.fname ;
                cv.PathOnClient = wr.fname ;
              	cv.VersionData = EncodingUtil.base64Decode(wr.base64);
                 cv.IsMajorVersion = true;
            	
                conversionList.add(cv);
                }
            }
            system.debug('Converstion List Size ==>' +conversionList.size());
            if(conversionList.size()>0 && !conversionList.isEmpty() ){
                insert conversionList;                
            }
            system.debug('Conversion List Data' + conversionList);
            if(conversionList.size() > 0)
            {	
          
                for(ContentVersion con : conversionList )
                {
                    ConID.add(con.Id);
                }
                conversionList = [select id,ContentDocumentId from ContentVersion WHERE Id IN :ConID ];
                for(ContentVersion Con : conversionList ){
                    ContentDocumentLink cl = new ContentDocumentLink();
                    cl.ContentDocumentId = Con.ContentDocumentId;
                    cl.LinkedEntityId = ld.ID; 
                    cl.ShareType = 'V';
                    ConDucmentList.add(cl);
                    Fnamelist.add(Con.ContentDocumentId);
                }
                

            }
            
            List<ContentDocument> docList = ([SELECT Id ,Title FROM ContentDocument  WHERE ID   IN : Fnamelist  ]);
            
            ld.International_Query_File_Name__c = '';
            
            string str ='';
            for(ContentDocument con : docList)
            {
                str = 'https://maxhealthcare--maxdev.my.salesforce.com' + '/' + con.Id + '\n' ;
                ld.International_Query_File_Name__c +=  str  +  con.Title  +'\n' ;
                
            }
            if(!test.isRunningTest()){
                if(ld.International_Query_File_Name__c !=''){
                Update ld;
                }
            }
            
            return ld.Id;
            
            
        }
        catch(Exception e){
            return 'Error '+e.getMessage();
        }
    }
    
    @AuraEnabled        
    public static List<String> getPickListValuesIntoList(){
        List<String> pickListValuesList = new List<String>();
        Schema.DescribeFieldResult fieldResult = Lead__c.Business_Unit__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
            //System.debug('Values in Rating are: '+pickListValuesList);
        }     
        return pickListValuesList;
    }
    
    public class WrapperClass {
        @auraEnabled
        public String fname;
        @auraEnabled
        public String base64;
        
        
        
    }
}