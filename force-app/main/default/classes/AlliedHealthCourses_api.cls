/*created by : Nitya(IRT)
 * Created Date :4th May 2022
 * Purpose: API to insert allied health courses lead records from website
 */
@RestResource(urlMapping='/AlliedHealthCoursesLeads/*')
global class AlliedHealthCourses_api {
    @HttpPost
    global static void insertAlliedHealthcourses(){
        RestRequest req=RestContext.request;
        List<Allied_Healthcare_Courses__c> coursesList=(List<Allied_Healthcare_Courses__c>)JSON.deserialize(req.requestBody.toString(), List<Allied_Healthcare_Courses__c>.class);
        //system.debug(coursesList);
        Id recordtype=schema.SObjectType.Allied_Healthcare_Courses__c.getRecordTypeInfosByName().get('Allied Healthcare Course').recordTypeId;
        List<String> PhoneNumbers=new List<string>();
        For(Allied_Healthcare_Courses__c a:coursesList){
            PhoneNumbers.add(a.Contact_No__c);
        }
        Map<String,Allied_Healthcare_Courses__c> duplicateRec=new map<string,Allied_Healthcare_Courses__c>();
        for(Allied_Healthcare_Courses__c a:[select id,contact_No__c, name from Allied_Healthcare_Courses__c where contact_no__c in:PhoneNumbers and createdDate=TODAY]){
            duplicateRec.put(a.Contact_No__c,a);
        }
        
        for(Allied_Healthcare_Courses__c a:coursesList){
            a.RecordTypeId=recordType;
            if(duplicateRec.containsKey(a.Contact_No__c)){
                a.Stage__c='Duplicate';
            }
        }
        Database.saveResult[] srList=Database.insert(coursesList,false);
        list<API_Error_Log__c> errorRecords=new list<API_Error_Log__c>();
        String JsonResponse='';
        for(database.SaveResult result:srList){
            if(result.isSuccess()){
                JsonResponse+=result;
            }
            else{
                for(Database.Error err : result.getErrors()) {
                    API_Error_Log__c error=new API_Error_Log__c();
                    error.API_Name__c='Allied Healthcare API';
                    error.Error_Message__c=err.getMessage();
                    error.Trigger_Point__c='Allied Healthcare API';
                    error.Record_Identifier__c=json.serialize(err.getFields());
                    errorRecords.add(error);
                    JsonResponse+=result;
                }
            }
        }
        if(errorRecords.size()>0) 
            insert errorRecords;
        RestContext.response.responseBody = Blob.valueOf(JsonResponse);
       // return srList;
    }
}