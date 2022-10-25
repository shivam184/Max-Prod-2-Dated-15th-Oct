@isTest
public class IOPPopulationOnBillingSummaryHandlerTest {
@isTest
    public static void test(){
        International_OP_Patient_Journey__c IOP = new International_OP_Patient_Journey__c ();
        IOP.Name = 'Test';
        IOP.Patient_Max_id__c ='MAX123';
        IOP.First_OP_Bill_Date__c=system.today()-2;
        Insert IOP;
        
        List<Billing_Summary__c> bsList=new list<Billing_Summary__c>();
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
        bs.IOP_Journey__c=Iop.id;
		bsList.add(bs);
        
        Billing_Summary__c bs1 = new Billing_Summary__c();
        bs1.alletec_hisamount__c = 100;
        bs1.billto_city__c='34';
        bs1.alletec_state__c ='22' ; 
        bs1.billto_country__c = '149';     
        bs1.Hospital_Location_HIS__c = 'BU1';
        bs1.name__c = 'MAX123';
        bs1.alletec_transactiontype__c='IP';       
        bs1.alletec_doctorid__c = '13254';        
        bs1.alletec_locality__c = '42';
        bs1.GL_Code__c='test23';
        bs1.alletec_ipid__c='al123';
        bs1.IOP_Journey__c=Iop.id;
        bsList.add(bs1);
        insert bsList;
        
        Test.startTest();
        IOPPopulationOnBillingSummaryHandler.iopAutoPopulationMethod(bsList);
        Test.stopTest();
    }
}