global class AutomateQuarantineDateBatch implements Database.Batchable<sObject>, Database.stateful{
    global AutomateQuarantineDateBatch(){}
    global Database.QueryLocator start(Database.BatchableContext bc){
        String query = 'SELECT Id,Date__c,Doctor_Frequency_date__c,Time_One__c,Time_One_Nurse__c,Time_Two_Nurse__c,Time_Three_Nurse__c,Doctor_Frequency_Day__c,Isolation_Max_Home__c,Isolation_Max_Home__r.Doctor_Frequency_Date__c, Quarantine_Day__c FROM Vital__c where Doctor_Frequency_date__c!=null and (Isolation_Max_Home__r.Stage__c = \'Prescription Generated\' OR Isolation_Max_Home__r.Stage__c = \'Delivery underway\' OR Isolation_Max_Home__r.Stage__c = \'Delivered\')';
        return Database.getQueryLocator(query); 
    }
    global void execute(Database.BatchableContext bc,List<Vital__c> VitalList){
        
        System.debug('VitalList --- '+VitalList);
        set<id> setId=new set<id>();
        List<Max_at_Home_Enquiry_Page__c> tempmaxHomeList = new List<Max_at_Home_Enquiry_Page__c>();
        for(Vital__c VL: VitalList){
            Max_at_Home_Enquiry_Page__c obj=new Max_at_Home_Enquiry_Page__c();
            if(!setId.Contains(VL.Isolation_Max_Home__c)){
                obj.Id=VL.Isolation_Max_Home__c;
                setId.add(VL.Isolation_Max_Home__c);
                if(VL.Doctor_Frequency_date__c!= null){
                    if(System.today()==VL.Doctor_Frequency_date__c){
                        obj.Doctor_Frequency_Date__c=VL.Doctor_Frequency_date__c;
                        obj.Doctor_Frequency_Time__c=VL.Time_One__c;
                    }  
                }else{
                    obj.Doctor_Frequency_Date__c=null;
                    obj.Doctor_Frequency_Time__c=null;
                }
                obj.Nurse_call_Time_Morning__c =VL.Time_One_Nurse__c;
                obj.Nurse_call_Time_Evening__c =VL.Time_Two_Nurse__c;
                obj.Nurse_call_Date__c=VL.Date__c;
                tempmaxHomeList.add(obj);
            }
        }
        System.debug('tempmaxHomeList--->'+tempmaxHomeList);
        if(!tempmaxHomeList.isEmpty()){
            UPDATE tempmaxHomeList;
        }
    }
    global void finish(Database.BatchableContext bc){
        
    }
    
}