public class VILLinkageApex {
    @auraEnabled
    public static Wrapper doInitApex(String recordId) {
        
        Wrapper wrap = new Wrapper();
        wrap.vilrequested.add('--None--');
        Schema.DescribeFieldResult fieldResult = Case.VIL_requested_by_partner__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry f : ple)
            wrap.vilrequested.add(f.getValue());
        list<Case> cslst = [SELECT Id,VIL_Detail__c,HCF_Partner__c,HCF_Partner__r.alletec_mhulocation__c,Country__c,Passport_No__c,VIL_requested_by_partner__c,
                            VIL_Detail__r.Name from Case where Id=:recordId];
        if(cslst!=null && cslst.size() > 0){
            if(cslst[0].VIL_Detail__c!=null){
                wrap.vilrequested.clear();
                wrap.vilId = cslst[0].VIL_Detail__c;
                wrap.vilrequested.add(cslst[0].VIL_requested_by_partner__c);
                wrap.Name = cslst[0].VIL_Detail__r.Name;
                
            }
            wrap.passNo = cslst[0].Passport_No__c;
            wrap.val = cslst[0].VIL_requested_by_partner__c;
            wrap.hcf = cslst[0].HCF_Partner__c;
            wrap.country = cslst[0].Country__c;
            if(cslst[0].HCF_Partner__r.alletec_mhulocation__c!=null)
                wrap.location = cslst[0].HCF_Partner__r.alletec_mhulocation__c;
        }
        return wrap;
    }
    public class Wrapper{
        @auraEnabled
        public List<String> vilrequested;
        @auraEnabled
        public String vilId;
        @auraEnabled
        public String val;
        @auraEnabled
        public String Name;
        @auraEnabled
        public String passNo;
        @auraEnabled
        public String hcf;
        @auraEnabled
        public String country;
        @auraEnabled
        public String location;
        public Wrapper(){
            vilrequested = new List<String>();
            vilId = '';
            val = '--None--';
            Name = '';
            passNo = '';
        }
    }
}