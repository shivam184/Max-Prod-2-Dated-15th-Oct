/*created by: Nitya(IRT)
* created date: 13th May 2022
* */
public class UpdateHcfOnBillingSummary_recursion {
    
    @invocableMethod
    public static void updateHcfOnBillingRecords(List<Id> recordId){
        List<billing_summary__c> billToUpdate=new list<billing_summary__c>();
        //system.debug(recordId);
        List<billing_summary__c> billingList=[select id,hcf_source__c, pre_intimation_status__c, tagged_pre_intimation__c, alletec_billdate__c, name__c from billing_summary__c where id in:recordId];
        List<billing_summary__c> similarBills=[select id,hcf_source__c, pre_intimation_status__c, tagged_pre_intimation__c,alletec_billdate__c from 
                                               billing_summary__c where name__c =:billingList[0].name__c and id !=:billingList[0].id 
                                               order by alletec_billdate__c desc ];
        billToUpdate=recursiveFunction(billToUpdate,similarBills,billingList[0].alletec_billdate__c,billingList);
       // system.debug('line 13 '+billToUpdate);
        update billToUpdate;
        //include international tag
    }
    public static List<billing_summary__c> recursiveFunction(list<billing_summary__c> billToUpdate,list<billing_summary__c> similarBills,dateTime billdate,list<billing_summary__c>billingList){
        
        for(integer i=0;i<similarBills.size();i++){
            system.debug(similarBills[i]);
            if((similarBills[i].alletec_billdate__c.date()).daysBetween(billdate.date())<=90){
               // system.debug('billdate '+billdate.date());
              //  system.debug('similarlist billdate '+similarBills[i].alletec_billdate__c.date());
                similarBills[i].hcf_source__c=billingList[0].hcf_source__c;
                similarBills[i].pre_intimation_status__c=billingList[0].pre_intimation_status__c;
                similarBills[i].tagged_pre_intimation__c=billingList[0].tagged_pre_intimation__c;
                billToUpdate.add(similarBills[i]);
                //system.debug('Line 20 '+billToUpdate);
                datetime d=similarBills[i].alletec_billdate__c;
                similarBills.remove(i);
                billToUpdate=recursiveFunction(billToUpdate,similarBills,d,billingList);
               // system.debug('Line 23 '+billToUpdate);
            }
        }
        return billToUpdate;
    }
}