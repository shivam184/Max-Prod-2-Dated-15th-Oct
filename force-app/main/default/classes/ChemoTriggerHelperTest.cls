@isTest
public class ChemoTriggerHelperTest {
@isTest
    public static void FinalTest1(){
        Test.startTest();
          String oncorecordTypeId = Schema.SObjectType.Prospect__c.getRecordTypeInfosByName().get('Onco Patient Prospect').getRecordTypeId();
        Prospect__c pros = new Prospect__c();
        pros.name = 'Abhi test';
        pros.Max_Id__c = '1234';
        pros.RecordTypeId = oncorecordTypeId;
        pros.Treatment_Completed__c = false;
        insert pros;
        
         Chemo_Appointment__c chemo = new Chemo_Appointment__c ();
        chemo.Prospect__c= pros.id;
        insert chemo;
        
        test.Stoptest();
    }
    
}