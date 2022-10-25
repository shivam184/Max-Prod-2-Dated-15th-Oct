/*created by:Nitya(IRT) on 14th July 2022
 * */
@suppressWarnings('PMD')global class updateRChannelOnBillingBatch implements database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext bc){
        String query = 'select id,alletec_channelType__c,patient__c,admission_acknowledgement__c,alletec_transactiontype__C,R_channel__c,alletec_isinternational__c,createddate from Billing_Summary__c where R_Channel__c =null and name__c!=null and alletec_hospitallocation__c!=null and alletec_ipid__c !=null order by createddate desc';
        return database.getqueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<Billing_summary__c> bsList){
        system.debug('bsList ' + bsList);
        map<Id, List<Billing_Summary__c>> mapAdminAckIdWithBillSum = new map<Id, List<Billing_Summary__c>>();
        map<Id, List<Billing_Summary__c>> mapPatientIdWithBillSum = new map<Id, List<Billing_Summary__c>>();
        for (billing_summary__c bsum : bsList){
           
             if (String.isBlank(bsum.Admission_Acknowledgement__c) && String.isNotBlank(bsum.Patient__c)){
                if (!mapPatientIdWithBillSum.containsKey(bsum.Patient__c))
                    mapPatientIdWithBillSum.put(bsum.Patient__c, new List<Billing_Summary__c>{ bsum });
                else
                    mapPatientIdWithBillSum.get(bsum.Patient__c).add(bsum);
            } else if (String.isNotBlank(bsum.Admission_Acknowledgement__c)){
                if (!mapAdminAckIdWithBillSum.containsKey(bsum.Admission_Acknowledgement__c))
                    mapAdminAckIdWithBillSum.put(bsum.Admission_Acknowledgement__c, new List<Billing_Summary__c>{ bsum });
                else
                    mapAdminAckIdWithBillSum.get(bsum.Admission_Acknowledgement__c).add(bsum);
            }

        }
        List<billing_summary__c> billToUpdate=new list<billing_summary__c>();
        
        if (!mapAdminAckIdWithBillSum.isEmpty()){
            for (Admission_Acknowledgement__c objAdminAck : [SELECT Id, pcl_markuptype__c, Patient__r.address2_country__c, MECP_Source__c
                                                             FROM Admission_Acknowledgement__c
                                                             WHERE Id IN:mapAdminAckIdWithBillSum.keySet()]){
                for (Billing_Summary__c objBillSum : mapAdminAckIdWithBillSum.get(objAdminAck.Id)){
                    if ((objBillSum.alletec_channeltype__c.equalsIgnoreCase('PSU') || objBillSum.alletec_channeltype__c.equalsIgnoreCase('Corporate')))
                    objBillSum.R_Channel__c = objBillSum.alletec_channeltype__c;
                    else if (objBillSum.alletec_isinternational__c || (String.isNotBlank(objAdminAck.Patient__r.address2_country__c) && !objAdminAck.Patient__r.address2_country__c.equalsIgnoreCase('Indian') && !objAdminAck.Patient__r.address2_country__c.equalsIgnoreCase('149')) || (String.isNotBlank(objAdminAck.pcl_markuptype__c) && objAdminAck.pcl_markuptype__c.equalsIgnoreCase('is applied'))){
                        // system.debug('Intrernational got true ');
                        objBillSum.alletec_isinternational__c = true;
                        objBillSum.R_Channel__c = 'International';
                    } else{
                        if (objBillSum.alletec_channeltype__c == 'Cash'){
                            if (String.isNotBlank(objAdminAck.MECP_Source__c))
                                objBillSum.R_Channel__c = 'MECP';
                            else
                                objBillSum.R_Channel__c = 'Walk-In';
                        } else if ((objBillSum.alletec_channeltype__c == 'Walk-In' || objBillSum.alletec_channeltype__c == 'TPA')){
                            if (String.isNotBlank(objAdminAck.MECP_Source__c))
                                objBillSum.R_Channel__c = 'MECP';
                            else
                                objBillSum.R_Channel__c = objBillSum.alletec_channeltype__c;
                        } else
                            objBillSum.R_Channel__c = objBillSum.alletec_channeltype__c;
                    }
                    billToUpdate.add(objBillSum);
                }
                //end of BillSum Loop
            }
            //end of Admin Ack Loop
        }
        //incase of bill's other than Ip where there is no Admission Ack
       else if (!mapPatientIdWithBillSum.isEmpty()){
        system.debug('mapPatientIdWithBillSum '+ mapPatientIdWithBillSum);
            for (Account objAcc : [SELECT Id, address2_country__c
                                   FROM Account
                                   WHERE Id IN:mapPatientIdWithBillSum.keySet()]){
                for (Billing_Summary__c objBillSum : mapPatientIdWithBillSum.get(objAcc.Id)){
                    if ((objBillSum.alletec_channeltype__c.equalsIgnoreCase('PSU') || objBillSum.alletec_channeltype__c.equalsIgnoreCase('Corporate')))
                    objBillSum.R_Channel__c = objBillSum.alletec_channeltype__c;
                    else if (objBillSum.alletec_isinternational__c || (String.isNotBlank(objAcc.address2_country__c) && !objAcc.address2_country__c.equalsIgnoreCase('Indian') && !objAcc.address2_country__c.equalsIgnoreCase('149'))){
                        //  system.debug('Intrernational got true ');
                        objBillSum.alletec_isinternational__c = true;
                        objBillSum.R_Channel__c = 'International';
                    } else{
                        if (objBillSum.alletec_channeltype__c == 'Cash')
                            objBillSum.R_Channel__c = 'Walk-In';
                        else if (objBillSum.alletec_channeltype__c == 'Walk-In' || objBillSum.alletec_channeltype__c == 'TPA')
                            objBillSum.R_Channel__c = objBillSum.alletec_channeltype__c;
                        else
                            objBillSum.R_Channel__c = objBillSum.alletec_channeltype__c;
                    }
                    billToUpdate.add(objBillSum);
                }
                //end of BillSum Loop
            }
            //end of Account Obj Loop
        }
        update billToUpdate;
    }

    global void finish(Database.BatchableContext bc){
    }

}