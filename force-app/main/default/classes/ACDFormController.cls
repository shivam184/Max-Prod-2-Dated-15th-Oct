public class ACDFormController {
    
    
    @AuraEnabled
    public static String saveProspectDetails(Prospect__c prospect){
        String message = 'Success';
        try{
            if(String.isNotBlank(prospect.Max_Id__c)){
                list<Account> acc = [select id,Max_Id__c from account where Recordtype.name='Patient'
                                     and Id =: prospect.Max_Id__c];
                if(acc!=null && acc.size()>0){
                    prospect.account__c = acc[0].id;
                    prospect.Max_Id__c = acc[0].Max_Id__c;
                }
            }
            
            if(String.isNotBlank(prospect.account__c)){
                list<Prospect__c> listPros=[SELECT Id,Source__c, HIS_Hospital_Location__c,Doctor__c
                                            FROM Prospect__c WHERE account__c=:prospect.account__c and 
                                            Source__c IN ('E Prescription','Estimation','ACD Page','ER') AND 
                                            Stage__c NOT IN ('Patient Discharged','Closed Lost')];
                
                for(Prospect__c pros :listPros) {
                    prospect.Id = pros.Id;
                    if(prospect.Doctor__c!=null)
                        prospect.Doctor_Est_Ep__c = prospect.Doctor__c;
                    if(prospect.HIS_Hospital_Location__c!=null)
                        prospect.Secondary_Doctor_Business_Unit__c = prospect.HIS_Hospital_Location__c;
                    
                    prospect.Doctor__c = pros.Doctor__c;
                    prospect.HIS_Hospital_Location__c = pros.HIS_Hospital_Location__c;
                    
                    
                    
                }
                
                for(Account acc : [SELECT Id,Name FROM Account WHERE id=:prospect.account__c]){
                    prospect.Name = acc.Name;
                    //prospect.Account__c = acc.Id;
                }
            }
            
            
            
            if(prospect.Id==null){
                prospect.Source__c ='ACD Page';
            }
            prospect.RecordTypeId = Schema.SObjectType.Prospect__c.getRecordTypeInfosByName().get('OP - IP').getRecordTypeId();
            prospect.Identified_By_ACD__c = true;
            
            
            //Logic to look for Admission Acknowledgements and change the Prospect Stage to Admitted/Discharged if found
            list<Admission_Acknowledgement__c> ackList = new list<Admission_Acknowledgement__c>();
            set<String> statusSet = new set<String>();
            statusSet.addAll(label.Admission_Status_For_Prospect.split(','));
            
            if(String.isNotBlank(prospect.Max_Id__c)){
                DateTime endt = system.now();
                DateTime stDt = system.now().addDays(Integer.valueOf(label.Prospect_Previous_Hous));
                
                ackList = [SELECT Id,Related_Prospect__c,Max_ID__c,CreatedDate,(SELECT Id FROM Billing_Summary__r) FROM Admission_Acknowledgement__c
                           WHERE Related_Prospect__c=null and Max_ID__c=:prospect.Max_Id__c and Admission_Status__c in:statusSet
                           and CreatedDate>=:stDt and CreatedDate<=:endt];
                
                if(ackList!=null && ackList.size()>0){
                    prospect.Stage__c = label.Prospect_Admitted;
                    
                    for(Admission_Acknowledgement__c ack : ackList)
                        if(ack.Billing_Summary__r!=null && ack.Billing_Summary__r.size()>0)
                        prospect.Stage__c = label.Patient_Discharged;
                    
                }                                                                                
            }
            
            //Upseting Prospect Record
            upsert prospect prospect.Id;
            
            //Linking Admission Acknowledgements with Prospects
            if(ackList!=null && ackList.size()>0){
                for(Admission_Acknowledgement__c ack : ackList)
                    ack.Related_Prospect__c = prospect.Id;
                update ackList;
            }
            
            message+='#'+prospect.Id; 
        }
        catch(Exception e){
            message = 'Error #'+e.getMessage();
        }
        return message;
    }
    
}