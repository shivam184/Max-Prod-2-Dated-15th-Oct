/*created by:Nitya(IRT)
 * created Date:13th May 2022
 * */
@isTest
public class UpdateHcfOnBillingSummary_recursionTest {
@isTest
    public static void test(){
        Id recordTypeId=Schema.SObjectType.account.getrecordtypeInfosByName().get('Patient').getRecordTypeId();
        account a=new account();
        a.recordtypeId=recordtypeId;
        a.Max_ID__c='123';
        a.LastName='Test';
        insert a;
        
        List<billing_summary__c> bList=new list<billing_summary__c>();
        billing_summary__c bs=new billing_summary__c();
        bs.name__c='123';
        bs.Patient__c=a.id;
        bs.alletec_billdate__c=system.today();
        bList.add(bs);
        
        billing_summary__c bs1=new billing_summary__c();
        bs1.name__c='123';
        bs1.Patient__c=a.id;
        bs1.alletec_billdate__c=system.today()-10;
        bList.add(bs1);
        
        billing_summary__c bs2=new billing_summary__c();
        bs2.name__c='123';
        bs2.Patient__c=a.id;
        bs2.alletec_billdate__c=system.today()-91;
        bList.add(bs2);
        
        insert bList;
        List<id> ids=new list<id>();
        ids.add(bList[0].id);
        
        UpdateHcfOnBillingSummary_recursion.updateHcfOnBillingRecords(ids);
    }
}