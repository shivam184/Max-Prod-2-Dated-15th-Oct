public class ListBeatDetailsApex {
    
    @AuraEnabled
    public static WrapperClass doInitApex(Date todayDate) {
        WrapperClass wrpCls = new WrapperClass();
        try {
            if(todayDate == NULL) {
            	wrpCls.todayDate = System.today();
                todayDate = System.today();
            }
            else 
                wrpCls.todayDate = todayDate;
            wrpCls.listBeatDetails = [SELECT Id,Expected_Date_of_Visit__c,Status__c,Account__r.Name,Contact__r.Name
                                      FROM Beat_Plan_Detail__c 
                                      WHERE Expected_Date_of_Visit__c = :todayDate
                                      AND Expected_Date_of_Visit__c != NULL
                                      AND Beat_Plan__c != NULL
                                      AND Beat_Plan__r.Agent__c = :UserInfo.getUserId()
                                      AND (Account__c != NULL OR Contact__c != NULL)
                                      AND Status__c = 'Scheduled'];
            wrpCls.message = 'SUCCESS';
            wrpCls.minDate = System.today();
            return wrpCls;
        }
        catch(Exception e) {
            wrpCls.message = e.getMessage();
            return wrpCls;
        }
    }
    
    public class WrapperClass {
        @AuraEnabled
        public Date todayDate;
        @AuraEnabled
        public List<Beat_Plan_Detail__c> listBeatDetails;
        @AuraEnabled
        public String message;
        @AuraEnabled
        public Date minDate;
        
        public WrapperClass() {
            listBeatDetails = new List<Beat_Plan_Detail__c>();
            message = '';
        }
    }
}