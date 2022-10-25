@RestResource(urlMapping='/MaxLabWebsitetosalesforceLeads/*')
global class UploadLeadAPI {
    @HttpPOST
    global static String doCreate() {
        RestRequest req = RestContext.request;
        if(String.isNotBlank(req.requestBody.toString())){
            Wrapper jsonBody = (Wrapper)JSON.deserialize(req.requestBody.toString(),Wrapper.class);
            IF(jsonBody.Name != Null){
                IF(jsonBody.Phone!=Null){ 
                    if(jsonBody.Query  != Null){
                        Id RecordTypeIdlead = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Max Lab customer lead').getRecordTypeId();
                        list<Lead__c> listExistingRecords=new list<Lead__c>();
                        Lead__c   ld=new Lead__c();
                        ld.RecordTypeId=RecordTypeIdlead;
                        ld.Name=jsonBody.Name;
                        If(String.IsNotBlank(jsonBody.Email))
                            
                            ld.Maxlab_Patient_Email_Id__c=jsonBody.Email;
                        ld.Maxlab_Mobile_no__c=jsonBody.Phone;
                        
                        
                        ld.Web_Description__c=jsonBody.Query;
                        If(String.IsNotBlank(jsonBody.City))
                            
                            ld.City__c =jsonBody.City;
                        If(String.IsNotBlank(jsonBody.Campaign))
                            
                            ld.Campaign_Name__c =jsonBody.Campaign;
                        
                        If(String.IsNotBlank(jsonBody.Source_of_Lead))
                            
                            ld.Source_of_Lead__c =jsonBody.Source_of_Lead;
                        //new field addition
                       //Addition of Field-URL by Shivam Gupta
                         If(String.IsNotBlank(jsonBody.URL))                            
                            ld.URL__c =jsonBody.URL;    
                        If(String.IsNotBlank(jsonBody.Patient_ID))                            
                            ld.Maxlab_Patient_Max_Id__c =jsonBody.Patient_ID;                        
                        If(String.IsNotBlank(jsonBody.Patient_Name))                            
                            ld.Name =jsonBody.Patient_Name;                        
                        If(String.IsNotBlank(jsonBody.Customer_Name))                            
                            ld.Customer_Name__c =jsonBody.Customer_Name;                        
                        If(String.IsNotBlank(jsonBody.Mobile))                            
                            ld.MaxLab_Mobile_no__c =jsonBody.Mobile;
                        If(String.IsNotBlank(jsonBody.Email))                            
                            ld.MaxLab_Patient_Email_id__c =jsonBody.Email;
                        If(String.IsNotBlank(jsonBody.PreBookingId))                            
                            ld.Pre_booking_id__c =jsonBody.PreBookingId;
                        If(String.IsNotBlank(jsonBody.Booking_date))     
                        {                       
                           // ld.Booking_Date__c =DateTime.parse(jsonBody.Booking_date.replace('T',' '));	
                            string StringTime= jsonBody.Booking_date;
							List<String> DateAndTimeList = StringTime.split('T');
							List<String> dayList = DateAndTimeList[0].split('-'); 
							List<string> timeList = DateAndTimeList[1].split(':');
							DateTime dt = DateTime.newInstance(Integer.valueOf(dayList[0]), Integer.valueOf(dayList[1]), Integer.valueOf(dayList[2]), Integer.valueOf(timeList[0]), Integer.valueOf(timeList[1]), Integer.valueOf(timeList[2].split('\\.')[0]));
							System.debug('DateTime is : '+dt);
							ld.Booking_Date__c = dt;

                          }						
                        If(String.IsNotBlank(jsonBody.Paid_Amount))                            
                            ld.Paid_Amount__c =jsonBody.Paid_Amount;							
                        If(String.IsNotBlank(jsonBody.Address))                            
                            ld.Address_Line_1__c =jsonBody.Address;
                        If(String.IsNotBlank(jsonBody.Time_Slot))     
                         {                       
                           // ld.Time_Slot__c =DateTime.parse(jsonBody.Time_Slot.replace('T',' '));	
                            string StringTime= jsonBody.Time_Slot;
							List<String> DateAndTimeList = StringTime.split('T');
							List<String> dayList = DateAndTimeList[0].split('-'); 
							List<string> timeList = DateAndTimeList[1].split(':');
							DateTime dt = DateTime.newInstance(Integer.valueOf(dayList[0]), Integer.valueOf(dayList[1]), Integer.valueOf(dayList[2]), Integer.valueOf(timeList[0]), Integer.valueOf(timeList[1]), Integer.valueOf(timeList[2].split('\\.')[0]));
							System.debug('DateTime is Time_Slot__c : '+dt);
							ld.Time_Slot__c = dt;
                          }						
                        If(String.IsNotBlank(jsonBody.Payu_trans_id))                            
                            ld.Payu_trans_id__c =jsonBody.Payu_trans_id;
                        If(String.IsNotBlank(jsonBody.Payu_payid))                            
                            ld.Payu_Payid__c =jsonBody.Payu_payid;
                        If(String.IsNotBlank(jsonBody.Payment_Mode))                            
                            ld.Payment_Mode__c =jsonBody.Payment_Mode;
                        If(String.IsNotBlank(jsonBody.Cart_Items))                            
                            ld.Cart_Items__c =jsonBody.Cart_Items;
                        If(String.IsNotBlank(jsonBody.Lims_Response))                            
                            ld.Lims_Response__c =jsonBody.Lims_Response;
                        If(String.IsNotBlank(jsonBody.Payment_Status))                            
                            ld.Payment_Status__c =jsonBody.Payment_Status;
                        If(String.IsNotBlank(jsonBody.Booking_Status))                            
                            ld.Booking_Status__c =jsonBody.Booking_Status;
                        
                        insert ld;
                        
                        string msg='successfully insert';
                         msg+=' Record Id '+' '+ld.id;
                        return msg;
                        
                    }
                    
                    Else{
                        return 'Please Add Query'; 
                    }
                }
                Else{
                    return 'Please Add Phone';  
                }
            }
            Else{
                return 'Please Add Name';  
            }
        }
        Else {
            
            return 'Please Provide Details';
        }
    }
    public class Wrapper{
        public String Name;
        public String Email;
        public String Phone;
        public string Query;
        public string City;
        public string Campaign;
        public string Source_of_Lead ;
        public string Patient_ID;
        public string Patient_Name;
        public string Customer_Name;
        public string Mobile;
        //public string Email;
        public string PreBookingId;
        public string Booking_date;
        public string Paid_Amount;
        public string Address;
        public string Time_Slot;
        public string Payu_trans_id;
        public string Payu_payid;
        public string Payment_Mode;
        public string Cart_Items;
        public string Lims_Response;
        public string Payment_Status;
        public string Booking_Status;
        public string URL;
        
    }
    
}