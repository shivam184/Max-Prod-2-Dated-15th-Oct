//Description : Update the stage of max@home on the basis of maxid and stages
//Created By : Prashant Gahlaut

@RestResource(urlMapping='/updatemaxhomelead/*')
global class update_maxathome_stage_API {
    
    @httpPOST
    global static void updatestage(string maxid , string stages){
        
        list<lead__c> leadlist = new list<lead__c>();
        list<string> fetchstages = Label.LeadStages.split(',');
        system.debug('====>maxid='+maxid);
        system.debug('====>fetchstages='+fetchstages);

        if(maxid != null && stages != null){
            system.debug('===Raghav');
            leadlist = [select 	id,name,Max_ID__c, Stage__c from lead__c 
                        where RecordType.Name = 'Max@Home'
                        And Max_ID__c =: maxid
                        And Stage__c in: fetchstages];
            
             if (leadlist != null && leadlist.size()>0){
                leadlist[0].Stage__c = stages;
                string ids= '' ;
                Database.SaveResult[] srList = Database.update(leadlist,false);
                ids += srList[0].getId() ;
                String jsonStr = '{"success" : true,"message" : "Lead Updated successfully","id":"'+ids+'"}';
                RestContext.response.addHeader('Content-Type', 'application/json');
                RestContext.response.responseBody = Blob.valueOf(jsonStr);
            }
            
            else {
                String jsonStr = '{"success" : false,"message" : "Lead not Updated"}';
                RestContext.response.addHeader('Content-Type', 'application/json');
                RestContext.response.responseBody = Blob.valueOf(jsonStr);
            }
        }
    }
}