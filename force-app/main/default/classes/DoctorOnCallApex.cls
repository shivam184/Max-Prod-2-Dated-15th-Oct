//created by :Nitya (IRT) on 7th june 2022

global without sharing class DoctorOnCallApex {
    @AuraEnabled
    global static list<e_prescription__c> fetchEPrescription(String sRecordId){
        List<e_prescription__c> ePrescriptionList=[select Patient_Name__c,age__c,gender__c,diagnosis__c,Covid_Vaccination__c,Vaccine_Name__c,
                                                   Dose_1__c,Dose_2__c,Booster__c,Allergies__c,If_yes__c,Current_Issues__c,Doctor_Name__c,Signature__c,
                                                   DMC__c,Secondary_Consultation_If_required__c,Treatment__c,Tests_to_be_Done__c,Provisional_Diagnosis__c,
                                                   Clinical_Notes__c,Personal_History_Family_History__c,History_of_Past_Illness__c,History_of_Present_Illness__c
                                                   from e_prescription__c where Isolation_Max_Home__c=:sRecordId ];
        return ePrescriptionList;
    }
}