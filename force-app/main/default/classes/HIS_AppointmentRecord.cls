/*created by : Nitya(IRT)
 * Created Date :2nd May 2022
 * Purpose: API to insert appointment records from HIS
 */
@RestResource(urlMapping='/AppointmentHis/*')
global class HIS_AppointmentRecord {
    @HttpPatch
    global static void upsertAppointment(){
        RestRequest req=RestContext.request;
        List<Appointment__c> appointmentList=(List<Appointment__c>)JSON.deserialize(req.requestBody.toString(), List<Appointment__c>.class);
        Schema.SObjectField token = appointment__c.Fields.appointment_id__c;
        Database.UpsertResult[] srList=Database.upsert(appointmentList,token, false);
        list<API_Error_Log__c> errorRecords=new list<API_Error_Log__c>();
        String jsonresponse = '[';
        for(Integer index = 0, size = srList.size(); index < size; index++) 
        {
            if (!srList[index].isSuccess()) {
                // Operation failed, so get all errors                
                for(Database.Error err : srList[index].getErrors()) {
                    API_Error_Log__c error=new API_Error_Log__c();
                    error.API_Name__c='HIS Appointment API';
                    error.Error_Message__c=err.getMessage();
                    error.Trigger_Point__c='HIS Appointment API';
                    error.Record_Identifier__c=json.serialize(err.getFields());
                    errorRecords.add(error);
                    jsonresponse+=' {';
                    jsonresponse+='"Id": "'+srList[index].getId()+'",';
                    jsonresponse+='"AppointmentId": "'+appointmentList[index].appointment_id__c+'",';
                    jsonresponse+=' "Error message": "'+error.Error_Message__c+'",';
                    jsonresponse+='  "Status": "Failure"';
                    jsonresponse+='},';
                }
            }
            else{
                jsonresponse+=' {';
                jsonresponse+='"Id": "'+srList[index].getId()+'",';
                jsonresponse+='"AppointmentId": "'+appointmentList[index].appointment_id__c+'",';
                jsonresponse+='  "Status": "Success",';
                jsonresponse+='"isCreated":"'+srList[index].isCreated()+'"';
                jsonresponse+='},';
            }
            
        }
        if(errorRecords.size()>0) 
            insert errorRecords;
        jsonresponse=jsonresponse.removeEnd(',');
        jsonresponse+=']';
        RestContext.response.responseBody = Blob.valueOf(jsonresponse);
    }
    
}