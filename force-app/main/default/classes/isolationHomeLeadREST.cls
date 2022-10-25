@RestResource(urlMapping='/isoloationHome/*')
global with sharing class isolationHomeLeadREST {
    
    @HttpPost
    global static ID createLead(String leadId, String invoiceNo, String paymentStatus, String transactionID, String modeOfPayment, Decimal amount, 
                                DATETIME trnxDateTime, String PayUTrnxID) {
                                    List<Max_at_Home_Enquiry_Page__c> MHEP = new List<Max_at_Home_Enquiry_Page__c>();
                                    for(Max_at_Home_Enquiry_Page__c isoLead : [SELECT id, Invoice_No__c, Payment_Status__c, Transaction_ID__c, Payment_Mode__c, Amount__c, 
                                                                               Transaction_date_and_time__c, PayU_Transaction_ID__c FROM Max_at_Home_Enquiry_Page__c WHERE id=:leadId]){
                                                                                   isoLead.Invoice_No__c=invoiceNo;
                                                                                   isoLead.Payment_Status__c=paymentStatus;
                                                                                   isoLead.Transaction_ID__c=transactionID;
                                                                                   isoLead.Mode_of_payment__c=modeOfPayment;
                                                                                   Decimal amountRound = amount.setScale(0);
                                                                                   System.debug('amountRound >>> ' + amountRound);
                                                                                   isoLead.Amount__c=amountRound;
                                                                                   isoLead.Transaction_date_and_time__c=trnxDateTime;
                                                                                   isoLead.PayU_Transaction_ID__c=PayUTrnxID;
                                                                                   
                                                                                   MHEP.add(isoLead);
                                                                               }
                                    update MHEP;
                                    return MHEP[0].Id;
                                }
}