/*created by: Adib Khan(IRT)
* Last Modified by: Nitya (IRT) on 29th April 2022
* */
@RestResource(urlMapping='/Lead_Creation_SFDC/*')
global class Rest_LeadCreation {
    @HttpPost
    global static void initPostService() {
        List<string> parentIds=label.JustDial_Parent_Ids.split(',');
        Id recordTypeId=Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Max Lab customer lead').getRecordTypeId();
Id recordTypeId1=Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Digital Customer Acquisition').getRecordTypeId();        
        //system.debug(recordTypeid[0].id);
        Lead__c incomingLead=new Lead__c();
        RestRequest req=RestContext.request;
        // system.debug(req.requestBody.toString());
        system.jsonparser jp= json.createParser(req.requestBody.toString());
        
        while(jp.nextToken()!=null){
            if(jp.getText()=='leadid'){
                jp.nextToken();
                incominglead.lead_id__c=jp.getText();
                //system.debug('lead id '+incominglead.lead_id__c);
                continue;
            }
            
            if(jp.getText()=='leadtype'){
                jp.nextToken();
                incominglead.leadtypejd__c=jp.getText();
                //system.debug('lead type '+incominglead.leadtypejd__c);
                continue;
            }
            
            if(jp.getText()=='prefix'){
                jp.nextToken();
                incominglead.prefix__c =jp.getText();
                // system.debug('prefix '+incominglead.prefix__c);
                continue;
            }
            
            if(jp.getText()=='name'){
                jp.nextToken();
                incominglead.name=jp.getText();
                // system.debug('name '+incominglead.name);
                continue;
            }
            
            if(jp.getText()=='mobile'){
                jp.nextToken();
                incominglead.mobile_phone__c=jp.getText();
                // system.debug('mobile phone '+incominglead.mobile_phone__c);
                continue;
            }
            
            if(jp.getText()=='phone'){
                jp.nextToken();
                incominglead.maxlab_phone__c =jp.getText();
                // system.debug('phone '+incominglead.maxlab_phone__c);
                continue;
            }
            
            if(jp.getText()=='email'){
                jp.nextToken();
                incominglead.email__c=jp.getText();
                //system.debug('email '+incominglead.email__c);
                continue;
            }
            
            if(jp.getText()=='date'){
                jp.nextToken();
                incominglead.lead_date__c=Date.valueof(jp.getText());
                //  system.debug('date '+incominglead.lead_date__c);
                continue;
            }
            
            if(jp.getText()=='category'){
                jp.nextToken();
                incominglead.category__c=jp.getText();
                // system.debug('category '+incominglead.category__c);
                continue;
            }
            
            if(jp.getText()=='area'){
                jp.nextToken();
                incominglead.area__c=jp.getText();
                //  system.debug('area '+incominglead.area__c);
                continue;
            }
            
            if(jp.getText()=='city'){
                jp.nextToken();
                incominglead.city__c=jp.getText();
                //  system.debug('city '+incominglead.city__c);
                continue;
            }
            
            if(jp.getText()=='brancharea'){
                jp.nextToken();
                incominglead.branch_area__c=jp.getText();
                //  system.debug('category '+incominglead.branch_area__c);
                continue;
            }
            
            if(jp.getText()=='dncmobile'){
                jp.nextToken();
                incominglead.dncmobile__c=jp.getText();
                // system.debug('dncmobile '+incominglead.dncmobile__c);
                continue;
            }
            
            if(jp.getText()=='dncphone'){
                jp.nextToken();
                incominglead.dncphone__c=jp.getText();
                //  system.debug('dncphone '+incominglead.dncphone__c);
                continue;
            }
            
            if(jp.getText()=='company'){
                jp.nextToken();
                incominglead.company_name__c=jp.getText();
                // system.debug('company '+incominglead.company_name__c);
                continue;
            }
            
            if(jp.getText()=='pincode'){
                jp.nextToken();
                incominglead.pincode__c=jp.getText();
                // system.debug('pincode '+incominglead.pincode__c);
                continue;
            }
            
            if(jp.getText()=='time'){
                jp.nextToken();
                incominglead.time__c=jp.getText();
                //  system.debug('time '+incominglead.time__c);
                continue;
            }
            
            if(jp.getText()=='branchpin'){
                jp.nextToken();
                incominglead.branch_pin__c=jp.getText();
                //  system.debug('branchpin '+incominglead.branch_pin__c);
                continue;
            }
            
            if(jp.getText()=='parentid'){
                jp.nextToken();
                incominglead.parent_id__c=jp.getText();
                system.debug('parentid '+incominglead.parent_id__c);
                //logic here to bifurcate
                if(!parentIds.contains(incominglead.parent_id__c))
                 incomingLead.RecordTypeId=recordTypeId;
                else
                    incomingLead.RecordTypeId=recordTypeId1;
                continue;
            }
            
        }
        incominglead.Source_of_Lead__c='JustDial';
        //  system.debug('incoming record'+incominglead);
        
        list<lead__c> listOfLeads=new list<lead__c>();
        listOfLeads.add(incomingLead);
        
        Database.SaveResult[] srList = Database.insert(listOfLeads, false);
        list<API_Error_Log__c> errorRecords=new list<API_Error_Log__c>();
        
        list<string> errors=new list<string>();        
        for (Database.SaveResult sr : srList) {
            if (!sr.isSuccess()) {
                // Operation failed, so get all errors                
                for(Database.Error err : sr.getErrors()) {
                    API_Error_Log__c error=new API_Error_Log__c();
                    error.API_Name__c='Rest lead creation';
                    error.Error_Message__c=err.getMessage();
                    error.Trigger_Point__c='Rest lead creation for just dial';
                    error.Record_Identifier__c=json.serialize(err.getFields());
                    errorRecords.add(error);
                    // System.debug('The following error has occurred.');                    
                    // System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    // System.debug('Fields that affected this error: ' + err.getFields());
                    
                    errors.add(err.getMessage());
                }
            }
        }
        
        if(errorRecords.size()>0) insert errorRecords;
        // system.debug(errorRecords);
        
        list<string> returnIds=new list<string>();
        for(Lead__c l:listOfLeads){
            if(l.id!=null) returnIds.add(l.id);
        }
        
        
        RestContext.response.responseBody = Blob.valueOf('{\n"Success Record ID\'s" :'+JSON.serialize(returnIds)+'\n"Errors" : '+json.serialize(errors)+' \n}');
    }
}