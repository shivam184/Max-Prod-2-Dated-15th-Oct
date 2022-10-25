public class ListPreIntimationApex {
    
    @AuraEnabled
    public static WrapperClass doInitApex(String selectedDate) {
        
        WrapperClass wrpCls = new WrapperClass();
        try {
            Id userId = UserInfo.getUserId();
            String qry = 'SELECT Id,Name,CreatedDate,MECP_Source__c,MECP_Name__c,MECP_Name__r.Name FROM Lead__c WHERE RecordType.Name = \'MECP\' AND OwnerId = :userId AND Pre_Intimation_Status__c = NULL AND CreatedDate >=LAST_N_MONTHS:2';
            
            if(selectedDate != null && selectedDate != ''){
                Date dt = Date.valueOf(selectedDate);
                Date startDate = getThisMonday(dt);
                Date endDate = startDate.addDays(7);
                qry+=' AND CreatedDate >= :startDate AND CreatedDate <= :endDate';
            }
            qry +=' ORDER BY CreatedDate DESC';
            
            wrpCls.listLead = Database.query(qry);
            wrpCls.message = 'SUCCESS';
            return wrpCls;
        }
        catch(Exception e) {
            wrpCls.message = e.getMessage();
            return wrpCls;
        }
    }
    
    public static Date getThisMonday(Date startDate){
    
        datetime myDate = datetime.newInstance(startDate.year(), startDate.month(), startDate.day());
        String day = myDate.format('EEEE');
        if(myDate.format('EEEE') == 'Monday'){
            
            return myDate.Date();
        }
        Integer iter=0;
        while(iter < 8){
            if(myDate.format('EEEE') == 'Monday'){
                break;
            }
            myDate-=1;
            startDate-=1;
            iter++;
        }
        return startDate;
    }
    
    public class WrapperClass {
        @AuraEnabled
        public List<Lead__c> listLead;
        @AuraEnabled
        public String message;
        
        public WrapperClass() {
            listLead = new List<Lead__c>();
            message = '';
        }
    }
}