/*Last Modified By Nitya on 24th June: converted future class into batch class
 */
@suppressWarnings('PMD')

global class MAXApi implements database.batchable<sObject>,database.AllowsCallouts{
    Set<id> leadSet;
    Boolean isScheduled=false;
    public MAXApi(set<id> idSet, boolean isScheduled){
        leadSet = idSet;
        isScheduled=isScheduled;
    }

    global database.QueryLocator start(database.BatchableContext bc){
        String query = 'Select Id, contact_id__c, MaxLab_Mobile_no__c, Mobile_Phone__c, Campaign__c, MaxLab_Phone__c, priority__c, ExecutiveID__c, follow_up_date__c, Patient_Name__c, Lead_Id__c, Source_of_Lead__c from Lead__c where id in:leadSet';
        return database.getQueryLocator(query);
    }

    global void execute(database.BatchableContext bc, List<lead__c> leadList){
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartArray();
        for (Lead__c Lead : LeadList){
            gen.writeStartObject();
            if (Lead.contact_id__c != null){
                gen.writeObjectField('contact_id', Lead.contact_id__c);
            } else{
                gen.writeNullField('contact_id');
            }
            gen.writeObjectField('Campaign', 'MAXhealth_OB');
            gen.writeObjectField('contact_list', 'Maxhealth');
            gen.writeObjectField('directoryName', 'maxhealth');
            if (Lead.MaxLab_Phone__c != null || Lead.MaxLab_Mobile_no__c != null || Lead.Mobile_Phone__c != null){
                if (Lead.MaxLab_Phone__c != null){
                    gen.writeObjectField('PHONE_NO', Lead.MaxLab_Phone__c);
                } else if (Lead.MaxLab_Mobile_no__c != null){
                    gen.writeObjectField('PHONE_NO', Lead.MaxLab_Mobile_no__c);
                } else if (Lead.Mobile_Phone__c != null){
                    gen.writeObjectField('PHONE_NO', Lead.Mobile_Phone__c);
                }
            } else{
                gen.writeNullField('PHONE_NO');
            }
            if (Lead.priority__c != null){
                gen.writeObjectField('priority', Lead.priority__c);
            } else{
                gen.writeNullField('priority');
            }
            if (Lead.ExecutiveID__c != null){
                gen.writeObjectField('ExecutiveID', Lead.ExecutiveID__c);
            } else{
                gen.writeNullField('ExecutiveID');
            }
            if (Lead.follow_up_date__c != null){
                gen.writeDateTimeField('follow_up_date', Lead.follow_up_date__c + 5.5 / 24);
            } else{
                gen.writeNullField('follow_up_date');
            }
            if (Lead.Patient_Name__c != null){
                gen.writeObjectField('Patient_name', Lead.Patient_Name__c);
            } else{
                gen.writeNullField('Patient_name');
            }
            if (Lead.Id != null){
                gen.writeObjectField('Lead_ID', Lead.Id);
            } else{
                gen.writeNullField('Lead_ID');
            }
            gen.writeEndObject();
        }
        String jsonS = gen.getAsString();
        // Sending the http body with JSON
        String endpoint = 'https://ingapps12.ienergizer.in/ieapimax/api/CreateContact';
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('POST');
        Blob headerValue = Blob.valueOf('Maxuser' + ':' + 'Mtuvxyzuv#321');
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('Content-Type', 'application/json');
        req.setbody(jsonS);
        Http http = new Http();
        HTTPResponse response = http.send(req);
        system.debug('ResponseFromDialer' + response.getBody());
    }
    global void finish(database.BatchableContext bc){
        system.debug('isScheduled value ' +isScheduled);
    }

}