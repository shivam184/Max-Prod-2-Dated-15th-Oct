@istest
public class billingsummaryupdateschedulableTest {
    
    public static testmethod void mytest(){
        
        Test.startTest();
        billingsummaryupdateschedulable sh1 = new billingsummaryupdateschedulable();
        String sch = '0 0 2 * * ?'; 
        system.schedule('Test', sch, sh1); 
        Test.stopTest();
        
    }
    
}