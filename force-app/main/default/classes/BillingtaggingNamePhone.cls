/*****************************************************************************************************
 * Date: 9th Sept 2022                                                                               *
 * Written By: Shivam Gupta                                                                          *
 * Batch Class for finding lead Name and Phone from billing summary if MAX ID is null                *
 * Test Class :TestBillingtaggingNamePhone                                                           *
 * Scheduler :ScheduleBillingtaggingNamePhone                                                        *
 * ***************************************************************************************************/

Global class BillingtaggingNamePhone implements Database.Batchable<sObject>, Database.AllowsCallouts 
{
    public List<Billing_Summary__c> start(Database.BatchableContext c)
    {
        //checking MAXID is null
        List<Billing_Summary__c> scope = new List<Billing_Summary__c>();
        scope= [Select id, alletec_patientname__c,Digital_Lead__c , Patient_Mobile_no__c, name__c,CreatedDate  from Billing_Summary__c where name__c=null AND CreatedDate =TODAY];
        
        return scope;
    }
    public void execute(Database.BatchableContext c, List<Billing_Summary__c> scope){
        {
            {
                
                list<Billing_Summary__c>billid = new list<Billing_Summary__c>();
                string Phone;
                string Name;
                string leadstring;
                string Billstring;
                system.debug(scope);
                map<string, id>nmap= new map<string,id>();
                for(Billing_Summary__c bill:scope){
                    if(bill.alletec_patientname__c!=null && bill.alletec_patientname__c!='' && bill.Patient_Mobile_no__c!='' && bill.Patient_Mobile_no__c!=null){
                        Phone=bill.Patient_Mobile_no__c;
                        Name=bill.alletec_patientname__c;
                        Billstring = Phone + Name;
                        nmap.put(Billstring.toUpperCase(),bill.id);
                    }   
                    
                }
                
                map<string,id> nmap2 = new map<string,id>();   
                List<Lead__c> leadlist = new List<Lead__c>();
                leadlist= [Select id, Name, Mobile_Phone__c, RecordType.Name, Max_ID__c, CreatedDate from Lead__c where Max_ID__c=null AND RecordType.Name='Digital Customer Acquisition' AND CreatedDate = LAST_N_DAYS:180 limit 9999];
                if(leadlist.size()>0){
                    for(Lead__c leadr:leadlist){
                        if(leadr.Name!=null && leadr.Mobile_Phone__c!=null){ 
                            leadstring=leadr.Mobile_Phone__c+leadr.Name;          
                            if(nmap.containsKey(leadstring.toUpperCase())){
                                nmap2.put(leadstring.toUpperCase(),leadr.id);
                            }
                        }
                    }
                    
                    for(Billing_Summary__c bill2:scope){
                        if(bill2.alletec_patientname__c!=null && bill2.Patient_Mobile_no__c!=null){
                            Phone=bill2.Patient_Mobile_no__c;
                            Name=bill2.alletec_patientname__c;
                            Billstring = Phone + Name;
                            if(nmap2.containskey(Billstring) && Billstring != '' ){
                                bill2.Digital_Lead__c= nmap2.get(Billstring);
                                billid.add(bill2);
                            }
                            
                        }     
                        
                    }
                    
                }
                update billid;
                
            }
            
            
        }
    }
    
    public void finish(Database.BatchableContext c)
    {
    }
    
}