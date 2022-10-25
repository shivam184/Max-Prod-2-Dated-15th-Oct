public class LeadConvert_Controller {
    
    @auraEnabled
    public static wrapperClass doInitApex(String leadId){
        system.debug('leadId---->'+leadId);
        wrapperClass wrapObj = new wrapperClass();
        try{
            Lead__c lead = [SELECT Name,Company_Name__c,First_Name__c,Last_Name__c,Stage__c
                            FROM Lead__c 
                            WHERE Id =:leadId
                            LIMIT 1];
            
            wrapObj.lead = lead;
            wrapObj.accName = lead.Company_Name__c;
            wrapObj.oppName = lead.Company_Name__c;
            List<String> option = new List<String>();
            for(Schema.PicklistEntry ple : Contact.salutation.getDescribe().getPicklistValues()){
                option.add(ple.getLabel());
            }
            if(option.size()>0)
                wrapObj.salutation = option;
            wrapObj.status = 'SUCCESS';
            return wrapObj;
        }catch(Exception e){
            wrapObj.status = e.getMessage()+ ' at Line '+e.getLineNumber();
            system.debug(e.getMessage()+ ' at Line '+e.getLineNumber());
            return wrapObj;
        }
    }
    //=================Method to convert Lead into Account,contact & opportunity==========================
    @auraEnabled 
    public static wrapperClass convertLeadApex(String jsonWrap, String leadId){
        system.debug('jsonWrap---->'+jsonWrap);
        wrapperClass wrapObj = (wrapperClass)json.deserialize(jsonWrap, wrapperClass.class);
        try{
            Lead__c lead = [SELECT Id, Title__c, Name, OwnerId, First_Name__c, Last_Name__c, Job_Title__c, Company_Name__c, Website__c, Email__c, 
                            Business_Phone__c, Mobile_Phone__c, Fax__c, Contact_No_2__c, Contact_No_3__c, Street__c, City__c, State_Province__c, 
                            ZIP_Postal_Code__c, Country_Region__c, Description__c, Annual_Revenue__c, SIC_Code__c, No_of_Employees__c,MaxLab_Phone__c,
                            Do_not_allow_Emails__c, Do_not_allow_Phone_Calls__c, Do_not_allow_Mails__c, Do_not_allow_Bulk_Emails__c,Business_Model__c, 
                            Follow_Email_Activity__c, Do_not_allow_Faxes__c, Source_Campaign__c, Subject__c, Account_Created__c, Source_Name__c, 
                            Max_ID__c, Parent_Contact_for_lead__c, Locality_Hospital__c, DOB__c, Age__c, Bed_Name__c, Gender__c, Remarks__c,
                            Discount__c, Industry__c, Rating__c, Bill_Date__c,  Territory__c, Lead_Type__c, Lead_Source__c, Source__c, 
                            Sub_Source__c, Business_Unit__c, Doctor_Name__c, Phone__c, Stage__c, HIS_Company_Code__c, Lead_Agency__c, Email_Opt_Out__c, Sales_Region__c, Sales_Territory__c 
                            FROM Lead__c 
                            WHERE Id =:leadId
                            LIMIT 1];
            Account acc;
            Contact con;
            opportunity__c opp;
            
            //==============getting custom setting records in which lead fileds mapped with account,contact and opportunity===================
            
            
            for(LeadConversionMapping__c convert : [SELECT Name,Mapped_Field__c,Mapping_Label__c FROM LeadConversionMapping__c]){
                system.debug('==='+lead.get(convert.Name));
                if(convert.Mapping_Label__c == 1 && lead.get(convert.Name) != NULL)
                    wrapObj.acc.put(convert.Mapped_Field__c,lead.get(convert.Name));
                
                if(convert.Mapping_Label__c == 2 && lead.get(convert.Name) != NULL)
                    wrapObj.con.put(convert.Mapped_Field__c, lead.get(convert.Name));
                
                if(convert.Mapping_Label__c == 3 && lead.get(convert.Name) != NULL)
                    wrapObj.opp.put(convert.Mapped_Field__c,lead.get(convert.Name));
                
            }
            //============= create Account ====================
            if(wrapObj.acc != NULL && wrapObj.accountId.length()==0){
                wrapObj.acc.OwnerId = lead.OwnerId;
                wrapObj.acc.Type = 'Max Labs';
                wrapObj.acc.Name = wrapObj.accName;
                wrapObj.acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Max Labs').getRecordTypeId();
                insert wrapObj.acc;
                wrapObj.status = 'SUCCESS';
                wrapObj.accountId = wrapObj.acc.id;
            }else if(wrapObj.accountId.length()>0){
                acc = new Account(id=wrapObj.accountId);
                acc.OwnerId = lead.OwnerId;
                //acc.Type = 'Max Labs';
                //acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
                update acc;
                wrapObj.status = 'SUCCESS';
                wrapObj.accountId = acc.id;
            }
            
            //=========== create contact if checkbox false ==================
            system.debug('wrapObj.contId---->'+wrapObj.contId);
            if(!wrapObj.isConCreate){
                if(wrapObj.con != NULL && wrapObj.contId.length()==0){
                    wrapObj.con.OwnerId = lead.OwnerId;
                    wrapObj.con.Salutation = wrapObj.salu!=null?wrapObj.salu:'';
                    wrapObj.con.AccountId = acc!=null?acc.id:wrapObj.accountId;
                    
                    if(wrapObj.lead.First_Name__c != null && wrapObj.lead.First_Name__c.length()>0)
                        wrapObj.con.FirstName = wrapObj.lead.First_Name__c;
                    
                    if(wrapObj.lead.Name != null && wrapObj.lead.Name.length()>0)
                        wrapObj.con.LastName = wrapObj.lead.Name;
                    
                    wrapObj.con.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Max Labs Contact').getRecordTypeId();
                    insert wrapObj.con;
                    wrapObj.status = 'SUCCESS';
                }else if(wrapObj.contId.length()>0){
                    con = new Contact(Id=wrapObj.contId);
                    con.OwnerId = lead.OwnerId;
                    con.AccountId = acc!=Null?acc.id:wrapObj.accountId;
                    update con;
                    wrapObj.status = 'SUCCESS';
                }
            }
          
            //========== create opportunity is checkbox is false =============
            if(!wrapObj.isOppCreate){
                if(wrapObj.opp != Null && wrapObj.oppId.length() == 0){
                    wrapObj.opp.OwnerId = lead.OwnerId;
                    wrapObj.opp.Leads__c = lead.id;
                    wrapObj.opp.Account__c = acc!=Null?acc.id:wrapObj.accountId;
                    if(wrapObj.oppName != NULL && wrapObj.oppName.length()>0)
                        wrapObj.opp.Name = wrapObj.oppName;
                    wrapObj.opp.Est_Close_Date__c = system.today().addDays(Integer.valueOf(label.Opty_Close_Date));
                    if(lead.Business_Model__c != NULL && lead.Business_Model__c.length()>0)
                        wrapObj.opp.Business_Model__c = lead.Business_Model__c;
                    
                    if(lead.Sales_Region__c != NULL && lead.Sales_Region__c.length()>0)
                        wrapObj.opp.Sales_Region__c = lead.Sales_Region__c;
                    
                    if(lead.Sales_Territory__c != NULL && lead.Sales_Territory__c.length()>0)
                        wrapObj.opp.Sales_Territory__c = lead.Sales_Territory__c;
                    
                    if(lead.Rating__c != NULL && lead.Rating__c.length()>0)
                        wrapObj.opp.Rating__c = lead.Rating__c;
                    
                    insert wrapObj.opp;
                    wrapObj.status = 'SUCCESS';
                }else if(wrapObj.oppId.length()>0){
                    opp = new Opportunity__c(Id=wrapObj.oppId);
                    opp.OwnerId = lead.OwnerId;
                    opp.Account__c = acc!=Null?acc.id:wrapObj.accountId;
                    update opp;
                    wrapObj.status = 'SUCCESS';
                }
            }
            lead.Stage__c = 'Converted';
            update lead;
            wrapObj.status = 'SUCCESS';
            return wrapObj;
            
        }catch(exception e){
            wrapObj.status = e.getMessage()+ ' at Line '+e.getLineNumber();
            system.debug('Error Message---->'+e.getMessage()+'at Line Number----'+e.getLineNumber());
            return wrapObj;
        }
    }
    
  //================ wrapper class ====================  
    public class wrapperClass{
        @auraEnabled 
        public List<String> salutation;
        @auraEnabled 
        public Lead__c lead;
        @auraEnabled 
        public contact con;
        @auraEnabled 
        public Account acc;
        @auraEnabled 
        public Opportunity__c opp;
        @auraEnabled 
        public boolean isOppCreate;
        @auraEnabled 
        public boolean isConCreate;
        @auraEnabled 
        public String accountId;
        @auraEnabled 
        public String contId;
        @auraEnabled 
        public String oppId;
        @auraEnabled 
        public String accName;
        @auraEnabled 
        public String oppName;
        @auraEnabled 
        public String conLastName;
        @auraEnabled 
        public String status;
        @auraEnabled 
        public String salu;
        public wrapperClass(){
            salutation = new List<String>();
            lead = new Lead__c();
            con = new contact();
            acc = new Account();
            opp = new Opportunity__c();
            isOppCreate = false;
            isConCreate = false;
            accountId = '';
            contId = '';
            oppId = '';
            accName = '';
            oppName = '';
            status = '';
            salu = '';
        }
    }
}