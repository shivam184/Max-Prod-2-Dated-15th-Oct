@RestResource(urlMapping='/bookingtransactionservice/*')
global class BookingTransactionService {
    @httpPost
    global static String updatePateintTransaction(){
        RestRequest req = RestContext.request;
        if(String.isNotBlank(req.requestBody.toString())){
            try{
                Wrapper jsonBody = (Wrapper)JSON.deserialize(req.requestBody.toString(),Wrapper.class);
                
                List<Transaction_line_Item__c> trList = new List<Transaction_line_Item__c>();
                map<string,id> doctormap = new map<string,id>();
                map<string,id> maxlabmap = new map<string,id>();
                if(jsonBody.patient != null){
                    Account acc = new Account();
                    acc.LastName = jsonBody.patient.patientName != null ? jsonBody.patient.patientName : '';
                    acc.Patient_Mobile_Number__c = jsonBody.patient.Mobile != null ? jsonBody.patient.Mobile : '';
                    acc.Family_UHID__c= jsonBody.patient.familyUHID != null ? jsonBody.patient.familyUHID : '';
                    acc.Max_ID__c = jsonBody.patient.maxId != null ? jsonBody.patient.maxId : '';
                    acc.Gender__c = jsonBody.patient.gender != null ? jsonBody.patient.gender : '';
                    acc.RecordTypeId = [SELECT id FROM RecordType WHERE sobjectType='Account' AND Name = 'Patient' LIMIT 1].Id;
                    acc.DOB__c = jsonBody.patient.gender != null ? Date.valueOf(jsonBody.patient.dob) : null;
                    acc.PersonEmail = jsonBody.patient.email != null ? jsonBody.patient.email : null;
                    acc.House_No__c = jsonBody.patient.houseNo != null ? jsonBody.patient.houseNo : '';
                    acc.Area__c = jsonBody.patient.area != null ? jsonBody.patient.area : '';
                    acc.PersonMailingCity = jsonBody.patient.city != null ? jsonBody.patient.city : '';
                    acc.PersonMailingState = jsonBody.patient.state != null ? jsonBody.patient.state : '';
                    acc.address2_country__c = jsonBody.patient.nationality != null ? jsonBody.patient.nationality : '';
                    acc.Pin_Code__c = jsonBody.patient.pinCode != null ? jsonBody.patient.pinCode : '';
                    acc.Source__c='Max Lab';
                    
                    if(jsonBody.trans != null){ 
                        
                        Transaction__c tr = new Transaction__c();
                        tr.Bill_No__c = jsonBody.trans.billNo != null ? jsonBody.trans.billNo : '';
                        tr.LIMS_Code__c = jsonBody.trans.limsCode != null ? jsonBody.trans.limsCode : '';
                        tr.Centre_Name__c = jsonBody.trans.centreName != null ? jsonBody.trans.centreName : '';
                        tr.Source__c = jsonBody.trans.source != null ? jsonBody.trans.source : '';
                        tr.Phlebotomist__c = jsonBody.trans.phlebotomist != null ? jsonBody.trans.phlebotomist : '';
                        tr.Payment_Mode__c = jsonBody.trans.paymentmode != null ? jsonBody.trans.paymentmode : '';
                        tr.First_Name__c = jsonBody.trans.firstname != null ? jsonBody.trans.firstname : '';
                        tr.Last_Name__c = jsonBody.trans.lastname != null ? jsonBody.trans.lastname : '';
                        tr.Middle_Name__c = jsonBody.trans.middlename != null ? jsonBody.trans.middlename : '';
                        tr.Bill_Cancel_Trnsaction__c = Boolean.ValueOf(jsonBody.trans.BillCancelTransaction != null ? jsonBody.trans.BillCancelTransaction : '');
                        tr.Discount_Reason__c = jsonBody.trans.discountreason != null ? jsonBody.trans.discountreason : '';
                        tr.Total_Amount__c = jsonBody.trans.totalAmount != null? Decimal.valueOf(jsonBody.trans.totalAmount) : 0.0;
                        tr.Discount__c = jsonBody.trans.discount != null ? Decimal.valueOf(jsonBody.trans.discount) : 0.0;
                        tr.Net_Amount__c = jsonBody.trans.netAmount != null ? Decimal.valueOf(jsonBody.trans.netAmount) : 0.0;
                        tr.Billing_Date_Time__c = jsonBody.trans.billingDateTime != null && String.isNotBlank(jsonBody.trans.billingDateTime) ? DateTime.valueOf(jsonBody.trans.billingDateTime) : null;
                        tr.Cancel_Date_Time__c = jsonBody.trans.cancelDateTime != null && String.isNotBlank(jsonBody.trans.cancelDateTime) ? DateTime.valueOf(jsonBody.trans.cancelDateTime) : null;

                        
                        if(string.isNotBlank(jsonBody.trans.doctorid) ){
                            for(Account acc1 : [select id, alletec_doctorid__c from account
                                                where recordType.name='Doctor' 
                                                And alletec_doctorid__c =:jsonBody.trans.doctorid]){
                                                    doctormap.put(acc1.alletec_doctorid__c,acc1.Id);
                                                }
                        }
                        if(doctormap != null && doctormap.size()>0){
                            if(doctormap.containskey(jsonBody.trans.doctorid)){
                                tr.Referred_Doctor__c = doctormap.get(jsonBody.trans.doctorid);
                            }
                        }
                        if(string.isNotBlank(jsonBody.trans.limsCode) ){
                            for(Account acc2 : [select id, LIMS_Code__c from account
                                                where recordType.name='Max Labs' 
                                                And LIMS_Code__c =:jsonBody.trans.limsCode]){
                                                    maxlabmap.put(acc2.LIMS_Code__c,acc2.Id);
                                                }
                        }
                        if(maxlabmap != null && maxlabmap.size()>0){
                            if(maxlabmap.containskey(jsonBody.trans.limsCode)){
                                tr.Centre__c = maxlabmap.get(jsonBody.trans.limsCode);
                            }
                        }
                        
                        if(jsonBody.trans.lineList != null){
                            for(TransLineItem line : jsonBody.trans.lineList){
                                Transaction_line_Item__c trItem = new Transaction_line_Item__c();
                                trItem.Transaction__r = tr;
                                trItem.Transaction_Id__c = line.transactionId != null ? line.transactionId : '';
                                trItem.Test_Id__c = line.test_id != null ? line.test_id : '';
                                trItem.Test_Name__c = line.test_name != null ? line.test_name : '';
                                trItem.Test_Rate__c = line.test_rate != null ? line.test_rate : '';
                                trItem.Test_Amount__c = line.test_amount != null ? Decimal.valueOf(line.test_amount) : 0.0;
                                trList.add(trItem);
                            }
                        }
                        
                        upsert acc Max_ID__c;
                       
                        if(acc.Id != null){
                            tr.Patient__c = acc.Id;
                            upsert tr Bill_No__c;
                        }
                        
                        for(Transaction_line_Item__c trItem  : trList){
                            trItem.Transaction__c = trItem.Transaction__r.Id;
                        }
                        System.debug('trList----->>>>>>'+trList.size());
                        upsert trList Test_Id__c;
                        return 'Success '+acc.Id;
                    }else{
                        return 'Transaction Details not found.';
                    }
                }
                else{
                    return 'Patient Details not found.';
                }
            }catch(Exception e){
                return e.getMessage()+' '+e.getLineNumber();
            }
        }else{
            return 'Blank body.';
        }
    }
    
    //********************************************** Modal Section **********************************************
    //***************************************************************************************************************//   
    
    
    public class Wrapper{
        public Patient patient {get;set;}
        public TransactionWrap trans {get;set;}
    }
    public class Patient{
        public String maxId;
        public String gender;
        public String patientName;
        public String dob;
        public String pinCode;
        public String email;
        public String houseNo;
        public String area;
        public String city;
        public String state;
        public String nationality;
        public String vip;
        public String Mobile;
        public String familyUHID;
        
    } 
    public class TransactionWrap{
        public String firstname;
        public String middlename;
        public String lastname;
        public String limsCode;
        public String billNo;
        public String centreName;
        public String source;
        public String phlebotomist;
        public String totalAmount;
        public String discount;
        public String paymentmode;
        public String discountreason;
        public String netAmount;
        public String billingDateTime;
        public String cancelDateTime;
        public string doctorid;
        public string BillCancelTransaction;
        public List<TransLineItem> lineList;
        
    }
    public class TransLineItem{
        public String test_id;
        public String test_name;
        public String test_rate;
        public String test_amount;
        public String max_share;
        public String transactionId;
    }
}