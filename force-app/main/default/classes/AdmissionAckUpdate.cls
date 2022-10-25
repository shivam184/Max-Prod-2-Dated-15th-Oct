public class AdmissionAckUpdate {
    
    @auraEnabled
    public static String updatePicklist(){
        
        System.debug('---->>|WW'+[select id,Procedure__c,CreatedDate,Update_Redemption__c from Admission_Acknowledgement__c]);
        
        list<Admission_Acknowledgement__c> admlist = [select id,Procedure__c,Update_Redemption__c from Admission_Acknowledgement__c
                                                      where Procedure__c != null 
                                                      AND  Update_Redemption__c = false
                                                      AND CreatedDate >= LAst_N_Months:1 
                                                      AND CreatedDate < today];
       

        list<Admission_Acknowledgement__c> admupdatelist = new list<Admission_Acknowledgement__c>();
        
        
       System.debug('admlist----->>>>'+admlist);
        
        if(admlist != null && admlist.size()>0){
            for(integer i=0 ;i<admlist.size();i++){
                Admission_Acknowledgement__c adm = new Admission_Acknowledgement__c();
                adm.Id = admlist[i].id;
                adm.Update_Redemption__c = true;
                admupdatelist.add(adm);
            } 
        }
        
        
        if(admupdatelist != null && admupdatelist.size()>0)
            update admupdatelist;
        
        return 'SUCCESS';
    }
}