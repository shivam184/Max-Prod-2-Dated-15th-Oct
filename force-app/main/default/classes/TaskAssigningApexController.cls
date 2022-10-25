public class TaskAssigningApexController {
    @AuraEnabled
    public static patientsWrapper getIsolationMax(){
        List<Max_at_Home_Enquiry_Page__c> unassignedPatientsList = [Select Id,AssignDoctor__c,QuarantineDayOnly__c, Name__c,Doctor__c,Patient_Name__c,Doctor__r.Name ,Nurse__r.Name ,Spoke__c,Stage__c,Package__c,Phone_No__c,Name,Service_Started_Date__c,Age__c,Address__c FROM Max_at_Home_Enquiry_Page__c 
                                                                    WHERE (Stage__c = 'Prescription Generated' OR Stage__c = 'Delivery underway' OR Stage__c = 'Delivered') AND Nurse__c = ''];
        List<Max_at_Home_Enquiry_Page__c> assignedPatientsList = [Select Id,AssignDoctor__c,AssignNurse__c,QuarantineDayOnly__c, Name__c,Doctor__c,Patient_Name__c,Doctor__r.Name,Nurse__r.Name,Spoke__c,Stage__c,Package__c,Phone_No__c,Name,Service_Started_Date__c,Age__c,Address__c FROM Max_at_Home_Enquiry_Page__c 
                                                                  WHERE (Stage__c = 'Prescription Generated' OR Stage__c = 'Delivery underway' OR Stage__c = 'Delivered') AND Nurse__c != ''];
        List<String> pickListValuesList= new List<String>();
        Schema.DescribeFieldResult fieldResult = Vital__c.Time_One__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
        } 
        patientsWrapper patientWrapObj = new patientsWrapper();
        patientWrapObj.unassignedPatientsList = unassignedPatientsList;
        patientWrapObj.assignedPatientsList = assignedPatientsList;
        patientWrapObj.hourValues = pickListValuesList;
        return patientWrapObj;
    }   
    @AuraEnabled
    public static patientsWrapper getSearchResults(Date searchDate,String patientNameForSearch,String phoneNumberForSearch,String docNameForSearch){
        String stage1 = 'Prescription Generated';
        String stage2 = 'Delivery underway';
        String stage3 = 'Delivered';
        String unassignedPatientsQuery = 'Select Id, Name__c,Patient_Name__c,Doctor__r.Name ,Nurse__r.Name ,Spoke__c,Stage__c,Package__c,Phone_No__c,Name,Service_Started_Date__c,Age__c,Address__c FROM Max_at_Home_Enquiry_Page__c WHERE (Stage__c =: stage1  OR Stage__c =: stage2 OR Stage__c =: stage3) AND Nurse__c = null';
        if(searchDate != null ){
            unassignedPatientsQuery += ' AND Service_Started_Date__c =: searchDate ';  
        }
        if(patientNameForSearch != null && patientNameForSearch != ''){
            unassignedPatientsQuery += ' AND Patient_Name__c LIKE \'%'  +patientNameForSearch+ '%\'';  
        }
        if(phoneNumberForSearch != null && phoneNumberForSearch != ''){
            unassignedPatientsQuery += ' AND Phone_No__c =: phoneNumberForSearch ';  
        }
        if(String.isNotBlank(docNameForSearch)){
            unassignedPatientsQuery += ' AND Doctor__c =: docNameForSearch ';  
        }
        system.debug('unassignedPatientsQuery'+unassignedPatientsQuery);
        List<Max_at_Home_Enquiry_Page__c> unassignedPatientsList = Database.query(unassignedPatientsQuery);
        /*List<Max_at_Home_Enquiry_Page__c> unassignedPatientsList = [Select Id, Name__c,Patient_Name__c,Doctor__r.Name ,Nurse__r.Name ,Spoke__c,Stage__c,Package__c,Phone_No__c,Name,Service_Started_Date__c FROM Max_at_Home_Enquiry_Page__c 
WHERE Stage__c = 'Payment_Verified' AND Nurse__c = '' AND Service_Started_Date__c =: searchDate];
List<Max_at_Home_Enquiry_Page__c> assignedPatientsList = [Select Id, Name__c,Patient_Name__c,Doctor__r.Name,Nurse__r.Name,Spoke__c,Stage__c,Package__c,Phone_No__c,Name,Service_Started_Date__c FROM Max_at_Home_Enquiry_Page__c 
WHERE Stage__c = 'Payment_Verified' AND Nurse__c != '' AND Service_Started_Date__c =: searchDate];*/
        patientsWrapper patientWrapObj = new patientsWrapper();
        patientWrapObj.unassignedPatientsList = unassignedPatientsList;
        //patientWrapObj.assignedPatientsList = assignedPatientsList;
        return patientWrapObj;
    }
    
    @AuraEnabled
    public static patientsWrapper getSearchResultsAssigned(Date searchDateAssigned,String patientNameForSearchAssigned,String phoneForSearchAssigned,String selectedDocForSearchAssigned){
        String stage1 = 'Prescription Generated';
        String stage2 = 'Delivery underway';
        String stage3 = 'Delivered';
        
        String unassignedPatientsQuery = 'Select Id, Name__c,Patient_Name__c,Doctor__r.Name ,Nurse__r.Name ,Spoke__c,Stage__c,Package__c,Phone_No__c,Name,Service_Started_Date__c,Age__c,Address__c FROM Max_at_Home_Enquiry_Page__c WHERE (Stage__c =: stage1  OR Stage__c =: stage2 OR Stage__c =: stage3) AND Nurse__c != null';
        if(searchDateAssigned != null ){
            unassignedPatientsQuery += ' AND Service_Started_Date__c =: searchDateAssigned ';  
        }
        if(patientNameForSearchAssigned != null && patientNameForSearchAssigned != ''){
            unassignedPatientsQuery += ' AND Patient_Name__c LIKE \'%' +patientNameForSearchAssigned+ '%\'';  
        }
        if(phoneForSearchAssigned != null && phoneForSearchAssigned != ''){
            unassignedPatientsQuery += ' AND Phone_No__c =: phoneForSearchAssigned ';  
        }
        if(String.isNotBlank(selectedDocForSearchAssigned)){
            unassignedPatientsQuery += ' AND Doctor__c =: selectedDocForSearchAssigned ';  
        }
        system.debug('unassignedPatientsQuery'+unassignedPatientsQuery);
        List<Max_at_Home_Enquiry_Page__c> assignedPatientsList = Database.query(unassignedPatientsQuery);
        /*List<Max_at_Home_Enquiry_Page__c> unassignedPatientsList = [Select Id, Name__c,Patient_Name__c,Doctor__r.Name ,Nurse__r.Name ,Spoke__c,Stage__c,Package__c,Phone_No__c,Name,Service_Started_Date__c FROM Max_at_Home_Enquiry_Page__c 
WHERE Stage__c = 'Payment_Verified' AND Nurse__c = '' AND Service_Started_Date__c =: searchDate];
List<Max_at_Home_Enquiry_Page__c> assignedPatientsList = [Select Id, Name__c,Patient_Name__c,Doctor__r.Name,Nurse__r.Name,Spoke__c,Stage__c,Package__c,Phone_No__c,Name,Service_Started_Date__c FROM Max_at_Home_Enquiry_Page__c 
WHERE Stage__c = 'Payment_Verified' AND Nurse__c != '' AND Service_Started_Date__c =: searchDate];*/
        patientsWrapper patientWrapObj = new patientsWrapper();
        patientWrapObj.assignedPatientsList = assignedPatientsList;
        return patientWrapObj;
    }
    
    @AuraEnabled
    public static void assignPatient(String assignDoc, String assignNurse , List<Max_at_Home_Enquiry_Page__c> unassignPatient , String docFrequency, String docVisits, String docVisitTime1,
                                     String nurseFrequency,String nurseVisits,String nurseVisitTime1,String nurseVisitTime2,Date serviceStartDate, Date serviceEndDate){
                                         
                                         //  if(unassignPatient.size()>0)
                                         system.debug('unassignPatient====>> '+unassignPatient[0].id);
                                         
                                         
                                         List<Max_at_Home_Enquiry_Page__c> patientsToUpdateList = new List<Max_at_Home_Enquiry_Page__c>();
                                         List<Vital__c> vitalListToInsert = new List<Vital__c>();
                                         for(Max_at_Home_Enquiry_Page__c eachPatient : unassignPatient){ 
                                             eachPatient.Doctor__c = assignDoc;
                                             eachPatient.Nurse__c = assignNurse;
                                             eachPatient.Service_Started_Date__c = serviceStartDate;
                                             if(System.today()==serviceStartDate){
                                                 eachPatient.Quarantine_Day__c='1';
                                                 eachPatient.Nurse_call_Time_Morning__c =nurseVisitTime1;
                                                 eachPatient.Nurse_call_Time_Evening__c =nurseVisitTime2;
                                                 eachPatient.Nurse_call_Date__c=serviceStartDate;   
                                             }
                                             if(docFrequency=='Daily' && System.today()==serviceStartDate){
                                                 eachPatient.Doctor_Frequency_Date__c=serviceStartDate;
                                                 eachPatient.Doctor_Frequency_Time__c=docVisitTime1;
                                             }
                                             
                                             if(serviceEndDate == null){
                                                 eachPatient.Service_End_Date__c = serviceStartDate.addDays(15);
                                             }
                                             else{
                                                 eachPatient.Service_End_Date__c = serviceEndDate;
                                             }
                                             patientsToUpdateList.add(eachPatient);
                                             integer nextdatedoctor=0;
                                             integer nextdatenurse=0;
                                             for(integer i=0;i<15;i++){
                                                 
                                                 Vital__c vitalObj = new Vital__c();
                                                 vitalObj.Date__c = eachPatient.Service_Started_Date__c.addDays(i); 
                                                 if(docFrequency=='Once in three days' && (i==2 || i==5 ||i==8 ||i==11 ||i==14)){
                                                     vitalObj.Doctor_Frequency_date__c=eachPatient.Service_Started_Date__c.adddays(i);
                                                     vitalObj.Doctor_Frequency_Day__c=i;
                                                     vitalObj.Time_One__c = docVisitTime1;
                                                     vitalObj.Doctor_Frequency__c = docVisits;
                                                 }
                                                 if(docFrequency=='Alternate day' && (i==1 || i==3 ||i==5 ||i==7 ||i==9||i==11 ||i==13)){
                                                     vitalObj.Doctor_Frequency_date__c=eachPatient.Service_Started_Date__c.adddays(i);
                                                     vitalObj.Doctor_Frequency_Day__c=i;
                                                     vitalObj.Time_One__c = docVisitTime1;
                                                     vitalObj.Doctor_Frequency__c = docVisits;
                                                 }
                                                 if(docFrequency=='Daily'){
                                                     vitalObj.Doctor_Frequency_date__c=eachPatient.Service_Started_Date__c.adddays(i);
                                                     vitalObj.Doctor_Frequency_Day__c=i;
                                                     vitalObj.Time_One__c = docVisitTime1;
                                                     vitalObj.Doctor_Frequency__c = docVisits;
                                                 }
                                                 if(!test.isRunningTest())
                                                 vitalObj.Frequency_Day__c = docFrequency;
                                                 vitalObj.Quarantine_Day__c = String.valueOf(i+1);
                                                 vitalObj.Isolation_Max_Home__c = eachPatient.id;
                                                 if(!test.isRunningTest())
                                                 vitalObj.Frequency_Day_Nurse__c = nurseFrequency;
                                                 //vitalObj.Time_One__c = docVisitTime1;
                                                 vitalObj.Time_One_Nurse__c = nurseVisitTime1;
                                                 vitalObj.Time_Two_Nurse__c = nurseVisitTime2;
                                                 //vitalObj.Doctor_Frequency__c = docVisits;
                                                 vitalObj.Nurse_Frequency__c = nurseVisits;
                                                 vitalObj.Next_Notification_date__c = eachPatient.Service_Started_Date__c.adddays(nextdatedoctor);
                                                 vitalObj.Next_Notification_Date_Nurse__c = eachPatient.Service_Started_Date__c.adddays(nextdatenurse);
                                                 nextdatedoctor=nextdatedoctor+3;
                                                 nextdatenurse=nextdatenurse+1;
                                                 vitalListToInsert.add(vitalObj);
                                             }
                                         }
                                         if(!patientsToUpdateList.isEmpty()){
                                             update patientsToUpdateList;   
                                         }   
                                         if(!vitalListToInsert.isEmpty()){
                                             insert vitalListToInsert;
                                         }
                                         
                                     }
    
    @AuraEnabled
    public static void replaceDoc(String docToUpdate, List<Max_at_Home_Enquiry_Page__c> assignPatient){
        List<Max_at_Home_Enquiry_Page__c> patientsToUpdateList = new List<Max_at_Home_Enquiry_Page__c>();
        system.debug('assignPatient'+assignPatient);
        system.debug('docToUpdate'+docToUpdate);
        for(Max_at_Home_Enquiry_Page__c eachPatient : assignPatient){ 
            eachPatient.Doctor__c = docToUpdate;
            patientsToUpdateList.add(eachPatient);
        }
        if(!patientsToUpdateList.isEmpty()){
            update patientsToUpdateList;   
        } 
    }
    
    @AuraEnabled
    public static void replaceNurse(String nurseToUpdate, List<Max_at_Home_Enquiry_Page__c> assignPatient){
        List<Max_at_Home_Enquiry_Page__c> patientsToUpdateList = new List<Max_at_Home_Enquiry_Page__c>();
        system.debug('assignPatient'+assignPatient);
        system.debug('nurseToUpdate'+nurseToUpdate);
        for(Max_at_Home_Enquiry_Page__c eachPatient : assignPatient){ 
            eachPatient.Nurse__c = nurseToUpdate;
            patientsToUpdateList.add(eachPatient);
        }
        if(!patientsToUpdateList.isEmpty()){
            update patientsToUpdateList;   
        } 
    }
    
    
    public class patientsWrapper{
        @AuraEnabled 
        public List<Max_at_Home_Enquiry_Page__c> unassignedPatientsList;
        @AuraEnabled  
        public List<Max_at_Home_Enquiry_Page__c> assignedPatientsList;
        @AuraEnabled
        public List<String> hourValues;
        patientsWrapper(){
            unassignedPatientsList = new List<Max_at_Home_Enquiry_Page__c>();
            assignedPatientsList = new List<Max_at_Home_Enquiry_Page__c>();
            hourValues = new List<String>();
        }
    }
}