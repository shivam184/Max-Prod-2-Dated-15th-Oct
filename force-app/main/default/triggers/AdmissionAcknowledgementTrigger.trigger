//Description: Apex Trigger to rollup total revenue amount from Admission Acknowledgement to MECP Doctors
//Contains Logic to Auto tag patients based on their last visits in Max (for Domestic)
//Created by: techmatrix Consulting
//last Modified by: Nitya(IRT)
trigger AdmissionAcknowledgementTrigger on Admission_Acknowledgement__c(before insert, after insert, before update, after update, after delete, after undelete ){
    TriggerExecutions__c trex = TriggerExecutions__c.getOrgDefaults();
    AdmissionAcknowledgementHelper ackHelper = new AdmissionAcknowledgementHelper();
    //added by Nitya
    //Metadata dependency
    Trigger_Setting_All_Objects__mdt ts = [select id, before_insert__c, before_update__c, after_undelete__c
                                           from Trigger_Setting_All_Objects__mdt
                                           where developerName = 'Admission_Acknowlegement_Trigger'];
    List<admission_acknowledgement__c> admlist;
    Id recordtype = Schema.SObjectType.Admission_acknowledgement__c.getRecordTypeInfosByName().get('Domestic').getRecordTypeId();
    if (trex.Admission_Acknowledgement__c){
        //Linking Prospects with Admission Acknowledgements
        if (trigger.isBefore){
            if (trigger.isInsert){
                ackHelper.linkAdmissionAckWithProspects(trigger.new );
                AdmissionAcknowledgementHelper.ConnectVisaInviteWithAdmissionAcknowledgement(Trigger.new );
                if (ts.before_insert__c){
                    ackHelper.autoTagInternational(trigger.new );
                }
                //added by Nitya on 21st April 2022
                AdmissionAcknowledgementHelper.updateHospitalLocationTextField(trigger.new );

            }

            //added by Nitya on 21st April 2022
            else if (trigger.isUpdate){
                admList = new list<admission_acknowledgement__c>();
                for (admission_acknowledgement__c adm : trigger.new ){
                    if (adm.RecordTypeId == recordtype && trigger.oldMap.get(adm.id).pre_intimation_status__c != adm.Pre_Intimation_Status__c && adm.Pre_Intimation_Status__c != null){
                        admList.add(adm);
                    }
                }
                if (!admList.isEmpty())
                    AdmissionAcknowledgementHelper.updateFieldsOnUpdationOfPreIntimationStatus(admList);
                AdmissionAcknowledgementHelper.updateHospitalLocationTextField(trigger.new );

            }
        }

        Channel_Massaging__mdt objSetting = [SELECT channel_massaging_active__c
                                             FROM Channel_Massaging__mdt
                                             WHERE MasterLabel = 'Setting'];
        //for channel massaging

        if (objSetting.channel_massaging_active__c){

            if (trigger.isBefore && (trigger.isInsert || trigger.isUpdate)){

                AdmissionAcknowledgementHelper.checkChannelMassaging();
            }
            if (trigger.isAfter && trigger.isUpdate){
                AdmissionAcknowledgementHelper.updateChannelMassagingForBillSum();
            }

        }

        //Rollup Amount from Admission Acknowlegdement to MECP Account
        //Autotagging Admission Acknowledgements based on Specialty
        Set<String> setOfAdmissionIds = new Set<String>();
        if (trigger.isAfter){
            if (Trigger.isInsert){
                for (Admission_Acknowledgement__c objAd : trigger.new ){
                    setOfAdmissionIds.add(objAd.Id);
                }
                AdmissionAcknowledgementHelper.IPID_UNPDATEONPROSPECT(trigger.new);
                ackHelper.rollupMethod(trigger.new );
                //ackHelper.autoTagPatients(trigger.new,trigger.old);
                // ackHelper.autoTagInternational(trigger.new);
                AdmissionAcknowledgementHelper.updateProspectStageToPateintAdmitted(setOfAdmissionIds);
                AdmissionAcknowledgementHelper.createMaxHomeLead(setOfAdmissionIds);
                //@added by nitya
                //  AdmissionAcknowledgementHelper.updateIopjBasedOnDateOfAdmission(trigger.new);
                AdmissionAcknowledgementHelper.updateRelatedProspect(trigger.new );
                AdmissionAcknowledgementHelper.CmpLeadAdmissionAckMaxId(setOfAdmissionIds);
                AdmissionAcknowledgementHelper.updateProspectInCaseOfEmergency(trigger.new );
                // ackHelper.updateProspectStageToPateintAdmitted(trigger.new);
                // ackHelper.createMaxHomeLead(trigger.new,trigger.oldmap);
                // ackHelper.CmpLeadAdmissionAckMaxId(trigger.new);
            } else if (Trigger.isUpdate){
                set<id> admSet = new Set<id>();
                for (admission_acknowledgement__c ack : trigger.new ){
                    if (ack.max_id__c != null && trigger.oldmap.get(ack.id).hcf_source__c == null && ack.hcf_source__c != null){
                        admset.add(ack.id);
                    }
                }
                if(!admSet.isEmpty())
                AdmissionAcknowledgementHelper.reTagOnLateTagging(admSet);

                for (Admission_Acknowledgement__c objAd : trigger.new ){
                    setOfAdmissionIds.add(objAd.Id);
                }
                ackHelper.rollupMethod(trigger.new );
                //ackHelper.autoTagPatients(trigger.new,trigger.old);
                //ackHelper.autoTagInternational(trigger.new);
                AdmissionAcknowledgementHelper.createMaxHomeLead(setOfAdmissionIds);
                //@added by nitya
                // AdmissionAcknowledgementHelper.updateIopjBasedOnDateOfAdmission(trigger.new);
                AdmissionAcknowledgementHelper.updateRelatedProspect(trigger.new );
                AdmissionAcknowledgementHelper.CmpLeadAdmissionAckMaxId(setOfAdmissionIds);
                AdmissionAcknowledgementHelper.updateProspectInCaseOfEmergency(trigger.new );
                if (checkRecursive.runOnce())
                    ackHelper.redemptionSummaryInsertion(trigger.new, trigger.oldMap);
                //ackHelper.createMaxHomeLead(trigger.new,trigger.oldmap);
                //ackHelper.CmpLeadAdmissionAckMaxId(trigger.new);
            } else if (Trigger.IsUndelete){
                for (Admission_Acknowledgement__c objAd : trigger.new ){
                    setOfAdmissionIds.add(objAd.Id);
                }

                ackHelper.rollupMethod(trigger.new );
                //ackHelper.autoTagPatients(trigger.new,trigger.old);
                AdmissionAcknowledgementHelper.updateProspectStageToPateintAdmitted(setOfAdmissionIds);
                // ackHelper.updateProspectStageToPateintAdmitted(trigger.new);
            } else{
                ackHelper.rollupMethod(trigger.old);
            }
        }
    }
}