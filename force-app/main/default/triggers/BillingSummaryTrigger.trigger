trigger BillingSummaryTrigger on Billing_Summary__c(before Insert, before update, after insert, after update, after delete, after undelete ){

    TriggerExecutions__c triggerExecution = TriggerExecutions__c.getOrgDefaults();
    Billing_Summary_Trigger__mdt bsTrigger = [select id, Before_Insert__c
                                              from Billing_Summary_Trigger__mdt
                                              where DeveloperName = 'Trigger_Setting'];
    Billing_Summary_Trigger__mdt bsIOPJ = [select id, Before_Insert__c, after_update__c, after_insert__c
                                           from Billing_Summary_Trigger__mdt
                                           where DeveloperName = 'IOPJ_Methods'];

    map<string, billing_summary__c> bMap = new map<string, billing_summary__c>();
    if (trigger.isBefore){
        if (trigger.isUpdate){
           
            // BillingSummaryTriggerHelper.checkEligiblityForMassagingPatient( trigger.new );
            //added by Nitya on 20th April 2022
            List<billing_summary__c> bsList1 = new List<billing_summary__c>();
            for (billing_summary__c bs : trigger.new ){
                if ((trigger.oldmap.get(bs.id).invoicenumber__c != bs.invoicenumber__c && bs.invoicenumber__c != null) || (trigger.oldmap.get(bs.id).alletec_transactiontype__c != bs.alletec_transactiontype__c && bs.alletec_transactiontype__c != null)){
                    bsList1.add(bs);
                }
            }
            if (!bsList1.isEmpty())
                BillingSummaryTriggerHelper.transactionBillNoField(bsList1);
        } else if (trigger.isInsert){
           
            OncoProspectPopulationonBillingHandler.iopAutoPopulationMethod(Trigger.New );
            //added by Nitya on 1th april 2022
            List<billing_summary__c> bsList = new List<billing_summary__c>();
            Set<id> buSet = new set<id>();
            List<billing_summary__c> bsList1 = new List<billing_summary__c>();
            for (billing_summary__c bs : trigger.new ){
                if (bs.alletec_hospitallocation__c != null){
                    bsList.add(bs);
                    buSet.add(bs.alletec_hospitallocation__c);
                }
                if (bs.invoicenumber__c != null && bs.alletec_transactiontype__c != null){
                    bsList1.add(bs);
                }
            }
            if (!bsList.isEmpty())
                BillingSummaryTriggerHelper.updateHospitalLocation(bsList, buSet);

            BillingSummaryTriggerHelper sumHelper = new BillingSummaryTriggerHelper();
            sumHelper.mapBillingDetails1(trigger.new );
            
            if (!bsList1.isEmpty())
                BillingSummaryTriggerHelper.transactionBillNoField(bsList1);
            if (bsTrigger.Before_Insert__c){
                BillingSummaryTriggerHelper.autoTagInternationalLeads(trigger.new );
            }

            if (bsIOPJ.Before_Insert__c)
                BillingSummaryTriggerHelper.TagIOPJourneyOnBillingSummary(trigger.new );
            //added by nitya on 15th June 2022
            BillingSummaryTriggerHelper.linkCampaignWithBilling(trigger.new );
           //Added by Shivam 8th August 2022
           // BillingSummaryTriggerHelper.AppointBilling(trigger.new);
            // BillingSummaryTriggerHelper.mapBillingMappingwithFacebook(trigger.new);
        }
    }


    //RollUp Values to Patient, Doctor and Admission Acknowledgement
    else if (trigger.isAfter){
        Set<String> setOfIds = new Set<String>();

        if (trigger.isInsert){
            for (Billing_Summary__c objBS : trigger.new ){
                setOfIds.add(objBS.Id);
            }
            BillingSummaryTriggerHelper.ProspectLogic(trigger.new);
            BillingSummaryTriggerHelper.doInsertUpdateUndelete(setOfIds);
            BillingSummaryTriggerHelper.UpdateMaxAtHomeLeadStageToDischarge(setOfIds);
            BillingSummaryTriggerHelper.updateInternationalLeadStage(setOfIds);
            BillingSummaryTriggerHelper.changeCaseStage(trigger.new );
            BillingSummaryTriggerHelper.updateLeadStagetoOPD(trigger.new );
            BillingSummaryTriggerHelper.OncologyPatientJourney(trigger.new );
            if (bsIOPJ.After_Insert__c){
                BillingSummaryTriggerHelper.InsertInternationalOPPatientJourney(trigger.new );
            }
            BillingSummaryTriggerHelper.updateFirstOpdIpdDate(trigger.new );
           
       system.debug('success');
            //BillingSummaryTriggerHelper.mapBillingMappingwithFacebook(trigger.new);
        } else if (trigger.isUpdate){
            //added by Nitya on 30th june 2022AppointBilling
            Set<id> bsSet = new set<id>();
            for (billing_summary__c bs : trigger.new ){
                if (trigger.oldmap.get(bs.id).hcf_source__c == null && bs.HCF_Source__c != null && bs.name__c != null && bs.patient__c != null && bs.alletec_isinternational__c){
                    bsSet.add(bs.id);
                }
            }
            if (!bsSet.isEmpty())
                billingSummaryTriggerHelper.tagOnLateTagging(bsSet);
            //added on 26th April by Nitya
            list<billing_summary__c> billList;
            billList = new list<billing_summary__c>();
            for (billing_summary__c bs : trigger.new ){
                if (trigger.oldmap.get(bs.id).alletec_billdate__c != bs.alletec_billdate__c){
                    billList.add(bs);
                }
            }
            if (!billList.isEmpty())
                BillingSummaryTriggerHelper.updateFirstOpdIpdDate(billList);
            //added by nitya on 20th april 2022
            billList = new list<billing_summary__c>();
            set<id> idSet = new set<id>();
            for (billing_summary__c bs : trigger.new ){
                if (trigger.oldmap.get(bs.id).alletec_billdate__c != bs.alletec_billdate__c && bs.alletec_billdate__c != null && bs.Admission_Acknowledgement__c != null){
                    billList.add(bs);
                    idSet.add(bs.Admission_Acknowledgement__c);
                }
            }
            if (!billList.isEmpty())
                billingSummaryTriggerHelper.updateBillDateOnAdmAck(billList, idSet);
            for (Billing_Summary__c objBS : trigger.new ){
                setOfIds.add(objBS.Id);
            }
            Set<String> updateSetOfIds = new Set<String>();
            for (Billing_Summary__c bs : trigger.new ){
                if (bs.alletec_companyname__c != NULL && bs.alletec_companyname__c != trigger.oldMap.get(bs.id).alletec_companyname__c || bs.Patient__c != NULL && bs.Patient__c != trigger.oldMap.get(bs.id).Patient__c || bs.Admission_Acknowledgement__c != NULL && bs.Admission_Acknowledgement__c != trigger.oldMap.get(bs.id).Admission_Acknowledgement__c){
                    updateSetOfIds.add(bs.Id);
                }
                if (updateSetOfIds != null && updateSetOfIds.size() > 0){
                    BillingSummaryTriggerHelper.doInsertUpdateUndelete(updateSetOfIds);
                }
            }
            BillingSummaryTriggerHelper.updateLeadStagetoOPD(trigger.new );
            if (bsIOPJ.After_Update__c){
                BillingSummaryTriggerHelper.updateInternationalOPPatientJourney(trigger.new, trigger.oldMap);
            }


        } else if (trigger.isUndelete){
            for (Billing_Summary__c objBS : trigger.new ){
                setOfIds.add(objBS.Id);
            }
            BillingSummaryTriggerHelper.doInsertUpdateUndelete(setOfIds);
        } else{
            for (Billing_Summary__c objBS : trigger.old){
                setOfIds.add(objBS.Id);
            }
            BillingSummaryTriggerHelper.doInsertUpdateUndelete(setOfIds);
        }
    }
}
/*
 * ----------------------------------------Not to be removed-----------------------------------------------*
 if(triggerExecution.BillingSummary__c){
 if(trigger.isBefore && trigger.isInsert ){  //if(trigger.isBefore)
 BillingSummaryTriggerHelper sumHelper = new BillingSummaryTriggerHelper();

 sumHelper.mapBillingDetails(trigger.new);
 sumHelper.mapBillingGLCodedetail(trigger.new);
 if(label.Biling_trigger =='On')
 {
 system.debug('Testttttt');
 BillingSummaryTriggerHelper.ConnectVisaInviteWithBillingSummary(trigger.new);
 }

 }*/