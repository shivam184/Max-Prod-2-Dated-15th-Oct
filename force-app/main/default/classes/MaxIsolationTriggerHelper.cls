//created By Nitya on 2nd August 2022
public class MaxIsolationTriggerHelper{
    public static void updateAccount(set<id> docId, set<id> nurseId){
        Map<Id, Integer> docToLeadCountMap = new Map<Id, Integer>();
        Map<Id, Integer> nurseToLeadCountMap = new Map<Id, Integer>();
        List<Account> docListToUpdate = new List<Account>();
        List<Account> nurseListToUpdate = new List<Account>();

        //Added By Nitya on 3rd June 2022
        for (aggregateResult ar : [select doctor__c, count(id)num
                                   from Max_at_Home_Enquiry_Page__c
                                   WHERE (Stage__c = 'Prescription Generated' OR Stage__c = 'Delivery underway' OR Stage__c = 'Delivered') AND doctor__c in:docId
                                   group by Doctor__c]){
            docToLeadCountMap.put((ID) ar.get('doctor__c'), (Integer) ar.get('num'));
            Account acc = new Account();
            acc.id = (id) ar.get('Doctor__c');
            acc.Patient_Count__c = docToLeadCountMap.get((ID) ar.get('doctor__c'));
            docListToUpdate.add(acc);
        }
        //added by Nitya on 3rd June 2022
        for (aggregateResult ar : [select nurse__c, count(id)num
                                   from Max_at_Home_Enquiry_Page__c
                                   WHERE (Stage__c = 'Prescription Generated' OR Stage__c = 'Delivery underway' OR Stage__c = 'Delivered') AND nurse__c in:nurseId
                                   group by nurse__c]){
            nurseToLeadCountMap.put((ID) ar.get('nurse__c'), (Integer) ar.get('num'));
            Account acc = new Account();
            acc.id = (id) ar.get('nurse__c');
            acc.Patient_Count__c = nurseToLeadCountMap.get((ID) ar.get('nurse__c'));
            nurseListToUpdate.add(acc);


        }
        if (!docListToUpdate.isEmpty()){
            update docListToUpdate;
        }
        if (!nurseListToUpdate.isEmpty()){
            update nurseListToUpdate;
        }
    }

    //added By Nitya on 2nd August 2022
    @future
    public static void updateTranactionId(Set<id> setOfIds){
        List<Max_at_Home_Enquiry_Page__c> listToUpdate = new list<Max_at_Home_Enquiry_Page__c>();
        for (Max_at_Home_Enquiry_Page__c max : [select id, name, transaction_id__c
                                                from Max_at_Home_Enquiry_Page__c
                                                where id in:setOfIds]){
            max.transaction_id__c = max.name + 'LEAD';
            listToUpdate.add(max);
        }
        if (!listToUpdate.isEmpty())
            update listToUpdate;
    }

    //process Builder is converted into Trigger By Nitya on 2nd August 2022
    public static void updateMAxAtHomeFromAccount(List<Max_at_Home_Enquiry_Page__c> triggerNew){
        set<id> accountSet = new set<id>();
        for (Max_at_Home_Enquiry_Page__c max : triggerNew){
            if (max.patient_search__c != null){
                accountSet.add(max.patient_search__c);
            }
        }
        if(accountSet.isEmpty())
        return;
        Map<id, account> accMap=new map<id, account>([select id,BillingStreet,firstName, lastName, patient_age__c, dob__c, max_id__c, personMobilePhone from account where id in:accountSet ]);
      //  system.debug(accMap);
        for(Max_at_Home_Enquiry_Page__c max:triggerNew){
            if(max.patient_search__c!=null){
                max.address__c=accMap.get(max.patient_search__c).billingStreet;
                max.patient_max_id__c=accMap.get(max.patient_search__c).max_id__c;
                max.first_name__c=accMap.get(max.patient_search__c).FirstName;
                max.last_name__c=accMap.get(max.patient_search__c).LastName;
                max.patient_dob__c=accMap.get(max.patient_search__c).dob__c;
                max.phone_no__c=accMap.get(max.patient_search__c).personMobilePhone;
                max.age__c=accMap.get(max.patient_search__c).patient_age__c;
            }
        }
    }
    //process builder is converted By Nitya in 2nd August 2022
    public static void updatePatientName(List<Max_at_Home_Enquiry_Page__c> triggerNew){
        for(Max_at_Home_Enquiry_Page__c max:triggerNew){
            if(max.first_Name__c !=null || max.last_name__c!=null)
            max.patient_name__c=max.first_name__c+' '+max.last_Name__c;
        }
    }

}