@isTest
public class BillingItemwiseTriggerHandlerTest {
@isTest
    public static void test1(){
        test.startTest();
        International_OP_Patient_Journey__c IOP = new International_OP_Patient_Journey__c ();
        IOP.Name = 'Test';
        IOP.Patient_Max_id__c ='MAX123';
        //IOP.First_OP_Bill_Date__c=system.today()-2;
        Insert IOP;
        
        Billing_Summary__c bs = new Billing_Summary__c();
        bs.alletec_hisamount__c = 100;
        bs.billto_city__c='34';
        bs.alletec_state__c ='22' ; 
        bs.billto_country__c = '149';     
        bs.Hospital_Location_HIS__c = 'BU1';
        bs.name__c = 'MAX123';
        bs.alletec_transactiontype__c='IP';       
        bs.alletec_doctorid__c = '13254';        
        bs.alletec_locality__c = '42';
        bs.GL_Code__c='test23';
        bs.alletec_ipid__c='al123';
        bs.IOP_Journey__c=iop.id;
        insert bs;
        list<billing_itemwise__c>biList=new list<billing_itemwise__c>();
		billing_itemwise__c bi=new billing_itemwise__c();
        bi.invoiceid__c=bs.id;
        bi.alletec_service__c='Investigations';
        biList.add(bi);
        billing_itemwise__c bi2=new billing_itemwise__c();
        bi2.invoiceid__c=bs.id;
        bi2.alletec_service__c='Consultations';
        biList.add(bi2);
        insert biList;
        biList[0].alletec_service__c='OP Consultations';
        update biList;
        test.stoptest();
    }
}