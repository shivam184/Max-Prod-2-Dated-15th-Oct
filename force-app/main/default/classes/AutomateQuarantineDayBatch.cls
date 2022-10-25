global class AutomateQuarantineDayBatch implements Database.Batchable<sObject>, Database.stateful{
    global AutomateQuarantineDayBatch(){}
    global Database.QueryLocator start(Database.BatchableContext bc){
        String query = 'SELECT Id,Stage__c,Service_Started_Date__c,Quarantine_Day__c,Doctor_Frequency_date__c FROM Max_at_Home_Enquiry_Page__c WHERE  (Stage__c = \'Prescription Generated\' OR Stage__c = \'Delivery underway\' OR Stage__c = \'Delivered\')';
        return Database.getQueryLocator(query); 
    }
    global void execute(Database.BatchableContext bc,List<Max_at_Home_Enquiry_Page__c> maxIsolationList){

        System.debug('maxIsolationList---'+maxIsolationList);    
        List<Max_at_Home_Enquiry_Page__c> tempmaxHomeList = new List<Max_at_Home_Enquiry_Page__c>();
        for(Max_at_Home_Enquiry_Page__c max: maxIsolationList){
            Integer tempDay=0;
            if(System.today()==max.Service_Started_Date__c && max.Quarantine_Day__c==null)  //if(max.Quarantine_Day__c== null)
                max.Quarantine_Day__c='0';
            if(max.Quarantine_Day__c!= null){
                if(Integer.valueOf(max.Quarantine_Day__c)<=15){
                    tempDay=Integer.valueOf(max.Quarantine_Day__c);
                    max.Quarantine_Day__c=String.valueOf(tempDay+1);
                    System.debug('max.Quarantine_Day__c --- '+max.Quarantine_Day__c);
                    if(Integer.valueOf(max.Quarantine_Day__c)>15){
                        max.Service_End_Date__c=System.today();
                        max.Stage__c='Closed';
                        max.Quarantine_Day__c=String.valueOf(15);
                    }
                    
                    //if(LstVital[0].Doctor_Frequency_Day__c==Integer.valueOf(max.Quarantine_Day__c)){
                     //   max.Doctor_Frequency_Date__c=LstVital[0].Doctor_Frequency_date__c;
                   // }
                    max.Patient_Verify_Morning__c=false;
                    max.Patient_Verify_Evening__c=false;
                    max.Vital_Verify_in_Morning__c=false;
                    max.Vital_Verify_in_Evening__c=false;          
                }
                tempmaxHomeList.add(max);
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