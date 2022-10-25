/* last modified by: Nitya(IRT) on 25th march 2022
 *
 */
trigger LeadTrigger on Lead__c(after insert, after update, before insert, before update ){

    TriggerExecutions__c triggercheck = TriggerExecutions__c.getOrgDefaults();
    //To send Data from Max Lab customer lead to Dailer Team
    Set<id> LeadIds = New Set<ID>();
    Set<id> LeadId1 = new set<id>();
    List<lead__c> leadList;
    Id RecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Max Lab customer lead').getRecordTypeId();
    //added by Nitya
    List<string> sourceOfLead = Label.source_of_lead.split(';');
    list<string> stage = label.stage.split(';');
    list<string> bookingStatus = label.booking_status.split(';');
    //added upto here

    if (triggercheck.leadcheckbox__c){
        try{
            if (trigger.isBefore){
                //added by Nitya
                leadList = new list<lead__c>();
                for (lead__c l : trigger.new ){
                    if (l.recordTypeId == RecordTypeId)
                        leadList.add(l);
                }
                if (trigger.isInsert){
                    LeadTriggerHelper.validationFunction(trigger.new );
                    LeadTriggerHelper.AssignleadAndIncrementUser(trigger.new );
                    
                    // LeadTriggerHelper.AssignleadToCallCenterUser(trigger.new);
                    LeadTriggerHelper.validationDuplicate(trigger.new );
                    LeadTriggerHelper.updateMaxId(trigger.new );
                    //added by Nitya

                    LeadTriggerHelper.UpdateLeadStage(leadList);
                    LeadTriggerHelper.changeLeadStageToDuplicate(leadList);
                    LeadTriggerHelper.updateMobileAndSourceOfLead(leadList);
                    LeadTriggerHelper.updateDigitalCallCenterOwner(trigger.new );
                    //always after updateDigitalCallCenterOwner
                    LeadTriggerHelper.updateWebSourceAndManagerEmailId(trigger.new );

                    leadTriggerHelper.updateIntimationDate(trigger.new );
                }
                //added by Nitya
                else if (trigger.IsUpdate){
                    LeadTriggerHelper.updateMobileAndSourceOfLead(leadList);
                }
                /*       //Update Owner Name in OP-OP process od lead.(Added by Vinay Mishra)
                 if(trigger.isUpdate){
                 LeadTriggerHelper.UpdateLeadOwner(trigger.new);
                 } */

            } else if (trigger.isAfter){
                if (trigger.isInsert){
                    //LeadTriggerHelper.sendSMS2(trigger.new);
                    
                    LeadTriggerHelper.sendSMS3(trigger.new);
                    LeadTriggerHelper.generateSFRelationShipId(trigger.new );
                    LeadTriggerHelper.checkduplicate2(trigger.new );
                    // LeadTriggerHelper.sendSMS12();
                    LeadTriggerHelper.postChatter();
                    LeadTriggerHelper.createCase(trigger.new );
                    LeadTriggerHelper.updateRelatedProspect(trigger.new );
                    LeadTriggerHelper.createFollowupLead(trigger.new );
                   // LeadTriggerHelper.autodeskapi(trigger.new );
                    for (Lead__c CustomLead : Trigger.New ){
                        //updated by Nitya
                        if (CustomLead.RecordTypeId == RecordTypeId && ((!sourceOfLead.contains(CustomLead.Source_of_Lead__c)) && (!bookingStatus.contains(CustomLead.Booking_Status__c)) && (!stage.contains(customLead.Stage__c)))){
                            if (CustomLead.end_disposition__c != 'Price Issue' && customLead.end_disposition__c != 'Call us back'){
                                LeadIds.add(CustomLead.id);
                            } else{
                                leadId1.add(customLead.id);
                            }
                        }
                    }
                  //  if (!test.isRunningTest()){
                        if (!LeadIds.isEmpty()){
                            database.executeBatch(new MAXApi(LeadIds, false));
                        }
                        if (!LeadId1.isEmpty()){
                            system.scheduleBatch(new MAXApi(leadId1, true), 'AutoDialler to Run ' + leadid1, 60);
                        }
                 //   }
                    //upto here
                } else if (trigger.isUpdate){
                    LeadTriggerHelper.sendSMS4(trigger.new);
                    //Added BY SHIVAM AUTO DESK FOLLOW UP TIME
                    
                    //leadTriggerHelper.autodeskapi2(trigger.new);
                    // LeadTriggerHelper.sendSMS3();
                    for (Lead__c lead : trigger.new ){
                        // To Call Initiate Assessment API
                        if (lead.Initiate_Assessment__c != trigger.oldMap.get(lead.id).Initiate_Assessment__c && lead.Initiate_Assessment__c == True || (lead.Ward_Bed__c != trigger.oldMap.get(lead.id).Ward_Bed__c && lead.Initiate_Assessment__c == True)){
                            //if(lead.Initiate_Assessment__c !=trigger.oldMap.get(lead.id).Initiate_Assessment__c && lead.Initiate_Assessment__c==True){
                            LeadTriggerHelper.UpdateLeadIdInLead(lead.Id);
                        }
                    }
                    leadTriggerHelper.updateCaseRecord(trigger.new, trigger.oldmap);
                    LeadTriggerHelper.updateRelatedProspect(trigger.new );
                    LeadTriggerHelper.createFollowupLead(trigger.new );
                    for (Lead__c CustomLead : Trigger.New ){
                        //added by Nitya on 24th june 2022
                        if (CustomLead.RecordTypeId == RecordTypeId && ((!sourceOfLead.contains(CustomLead.Source_of_Lead__c)) && (!bookingStatus.contains(CustomLead.Booking_Status__c)) && (!stage.contains(customLead.Stage__c)))){
                            if (trigger.oldmap.get(CustomLead.id).ob_end_disposition__c!=CustomLead.ob_end_disposition__c && (CustomLead.ob_end_disposition__c == 'Price Issue' || customLead.ob_end_disposition__c == 'Call me back')){
                                LeadIds.add(CustomLead.id);
                            }
                        }
                    }
                    if (!LeadIds.isEmpty()){
                        system.scheduleBatch(new MAXApi(leadId1, true), 'AutoDialler to Run '+leadIds, 60);
                    }
                }

            }
        } catch (Exception e){
            System.debug('e-->>>' + e);
        } 
    }




    
    
}