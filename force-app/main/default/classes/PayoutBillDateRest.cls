@RestResource(urlMapping='/PayoutBillDates/*')
global with sharing class PayoutBillDateRest {
    
    @HttpPost
    global static void getPayouts() {
        try{
            RestRequest request = RestContext.request;
            if(String.isNotBlank(request.requestBody.toString())){
                
                RequestBodyWrapper requestBody = (RequestBodyWrapper)JSON.deserialize(request.requestBody.toString(),RequestBodyWrapper.class); 
                System.debug('requestBody: ' +requestBody.startDate+ 'endDate: ' +requestBody.endDate);
                
                List<Payout__c> payoutlst = [SELECT Id,Record_Id__c,Billing_Summary_Owner_Name__c,Name,Name__c,Patient_Name__c,Patient_RecordId__c,alletec_dateofadmission__c, Max_ID__c, Transaction_Type__c, IPID__c, alletec_hospitallocation__r.Name,
                                             Doctor__r.Name, alletec_speciality__r.Name, HCF_Source__r.Name, Parent_Account__c, New_Pre_Intimation_Date_Time__c, 
                                             Patient_Reg_DateTime__c, Date_Time_of_Admission__c, Date_of_Discharge__c,
                                             Pre_Intimation_Status__c, SMS_Tagged__c, Auto_Tagged__c, First_OPD_IPD_Bill_Date__c, First_OPD_IPD_Bill_No__c,
                                             Tagged_On__c, Remarks__c, Message_Description__c, Nationality__c, pcl_markuppercentage__c, invoicenumber__c,
                                             alletec_hisamount__c, Discount__c, OPID__c, Number_of_Hours__c, Payout_Percentage__c,
                                             GST__c, Total_Payout__c,alletec_billdate__c FROM Payout__c WHERE alletec_billdate__c >= :requestBody.startDate AND 
                                             alletec_billdate__c <= :requestBody.endDate order by alletec_billdate__c desc limit 50000];
                
                String jsonStr = '';
                if(payoutlst!=null && payoutlst.size() > 0){
                    String records = '[';
                    for(Payout__c pay : payoutlst){
                        records+='{"Patient Name":"'+pay.Name+'","Max Id":"'+pay.Max_ID__c+'","Transaction Type":"'+pay.Transaction_Type__c+'","IPID":"'+pay.IPID__c+'","Hospital Location":"'+pay.alletec_hospitallocation__r.Name+'","Doctor":"'+pay.Doctor__r.Name+'","Speciality":"'+pay.alletec_speciality__r.Name+'","HCF Source":"'+pay.HCF_Source__r.Name+'","Parent Account":"'+pay.Parent_Account__c+'"';
                        
                        if(pay.New_Pre_Intimation_Date_Time__c!=null)
                            records+=',"New Pre Intimation Date Time":"'+pay.New_Pre_Intimation_Date_Time__c.format()+'"';
                        
                        
                        if(pay.Patient_Reg_DateTime__c!=null)
                            records+=',"Patient Reg DateTime":"'+pay.Patient_Reg_DateTime__c.format()+'"';
                        if(pay.alletec_dateofadmission__c!=null)
                            records+=',"Date Of Admission":"'+pay.alletec_dateofadmission__c.format()+'"';
                        if(pay.Date_Time_of_Admission__c!=null)
                            records+=',"Date Time Of Admission":"'+pay.Date_Time_of_Admission__c.format()+'"';
                        records+=',"Date Of Discharge":"'+pay.Date_of_Discharge__c+'","Pre Intimation Status":"'+pay.Pre_Intimation_Status__c+'","Registration Number":"'+pay.Name__c+'","Patient RecordId":"'+pay.Patient_RecordId__c+'","SMS Tagged":"'+pay.SMS_Tagged__c+'","Auto Tagged":"'+pay.Auto_Tagged__c+'","First OPD/IPD Bill Date":"'+pay.First_OPD_IPD_Bill_Date__c+'","First OPD/IPD Bill No":"'+pay.First_OPD_IPD_Bill_No__c+'","Tagged On":"'+pay.Tagged_On__c+'","Remarks":"'+pay.Remarks__c+'","Message Description":"'+pay.Message_Description__c+'","Nationality":"'+pay.Nationality__c+'","Mark up Percent":"'+pay.pcl_markuppercentage__c+'","BillNo":"'+pay.invoicenumber__c+'","Total Amount":"'+pay.alletec_hisamount__c+'","Discount":"'+pay.Discount__c+'","OPID":"'+pay.OPID__c+'","No of hours":"'+pay.Number_of_Hours__c+'","Payout percent":"'+pay.Payout_Percentage__c+'","GST":"'+pay.GST__c+'","Total Payout":"'+pay.Total_Payout__c+'","Record Id":"'+pay.Record_Id__c+'","Billing Summary Owner Name":"'+pay.Billing_Summary_Owner_Name__c+'","Bill Date":"'+pay.alletec_billdate__c.format()+'"},';
                        System.debug('records---->>>'+records);
                    }
                    if(records.contains(','))
                        records = records.removeEnd(',');
                    records+=']';
                    jsonStr = '{"success" : true,"PayoutList" : "'+records+'"}';
                }else
                    jsonStr = '{"success" : false,"message" : "Payouts is not lying between Start and End date"}';
                
                RestContext.response.addHeader('Content-Type', 'application/json');
                RestContext.response.responseBody = Blob.valueOf(jsonStr);
                return; 
            }else {
                String jsonStr = '{"success" : false,"message" : "Provide Body"}';
                RestContext.response.addHeader('Content-Type', 'application/json');
                RestContext.response.responseBody = Blob.valueOf(jsonStr);
                return;     
            }  
        }catch(Exception e){
            String jsonStr = '{"success" : false,"message" : "'+e.getMessage()+'"}';
            RestContext.response.addHeader('Content-Type', 'application/json');
            RestContext.response.responseBody = Blob.valueOf(jsonStr);
            return; 
        }
    }
    
    public class  RequestBodyWrapper{
        public Date startDate {get; set;}
        public Date endDate {get; set;}
    }
}