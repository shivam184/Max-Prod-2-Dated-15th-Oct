@isTest
public class RecordCheckUtilityClassTest {
    @isTest
    static void testMe(){
        
        Business_Unit__c bu = new Business_Unit__c();
        bu.Name='Test Business'; 
        bu.HIS_ID__c = '123';
        insert bu;
        
        String testId = RecordCheckUtilityClass.checkRecord('123', '', 'Business Unit');
        
        
        Lead__c leadObj = new Lead__c();
        leadObj.Name = 'Test Lead';
        leadObj.RecordtypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('CMP').getRecordTypeId();
        leadObj.Max_Id__c = 'JJH.7878';
        leadObj.Stage__c='New';
        insert leadObj;
        RecordCheckUtilityClass.checkRecord('JJH.7878', '', 'Lead');
        
        
        Prospect__c prospect2 = new Prospect__c();
        prospect2.Name = 'TEST';
        prospect2.Stage__c = 'Admission Advised';
        prospect2.Max_Id__c = 'abcd';
        prospect2.Source__c = 'ACD Page';
        insert prospect2;
        RecordCheckUtilityClass.checkRecord('abcd', '', 'Prospect');
        
        Prospect__c prospect = new Prospect__c();
        prospect.Name = 'TEST';
        prospect.Stage__c = 'Admission Advised';
        prospect.Max_Id__c = 'KJH876';
        prospect.Source__c = 'ACD Page';
        insert prospect;
        
        RecordCheckUtilityClass.checkRecord('KJH876', '', 'ProspectEstimation');
        
        
        Account acc = new Account();
        
        String recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Doctor').getRecordTypeId();
        if(String.isNotBlank(recordTypeId))
            acc.RecordTypeId = recordTypeId;
        acc.FirstName = 'test';
        acc.LastName = 'test';
        acc.alletec_doctorid__c = '124';
        insert acc;
        
        String testId1 = RecordCheckUtilityClass.checkRecord('124', 'test', 'Doctor');
        
        
        String testId2 = RecordCheckUtilityClass.checkRecord('125', 'test', 'Doctor');
        
        
        Account acc1 = new Account();
        
        String recordTypeId1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId();
        if(String.isNotBlank(recordTypeId))
            acc1.RecordTypeId = recordTypeId1;
        acc1.FirstName = 'test';
        acc1.LastName = 'test';
        acc1.Max_ID__c = '124';
        insert acc1;
        
        String testId11 = RecordCheckUtilityClass.checkRecord('124', 'test', 'Patient');
        
        
        String testId21 = RecordCheckUtilityClass.checkRecord('125', 'test', 'Patient');
        
        
        Department__c dept = new Department__c();
        dept.name = 'test';
        dept.alletec_id__c = 123;
        insert dept;
        
        String testId3 = RecordCheckUtilityClass.checkRecord('123', 'test', 'Department');
        
        String testId4 = RecordCheckUtilityClass.checkRecord('128', 'test', 'Department');
        
        Speciality__c sp = new Speciality__c();
        sp.name = 'tes';
        sp.HIS_ID__c = '123';
        
        insert sp;
        
        
        String testId5 = RecordCheckUtilityClass.checkRecord('123', 'test', 'Specialization');
        
        String testId6 = RecordCheckUtilityClass.checkRecord('128', 'test', 'Specialization');        
        
        
        RecordCheckUtilityClass.checkRecord('abc', 'recordName', 'Gender');
        RecordCheckUtilityClass.checkRecord('abc', 'recordName', 'MaritalStatus');
        RecordCheckUtilityClass.checkRecord('abc', 'recordName', 'BloodGroup');
        RecordCheckUtilityClass.checkRecord('abc', 'recordName', 'City');
        RecordCheckUtilityClass.checkRecord('abc', 'recordName', 'Country');
        RecordCheckUtilityClass.checkRecord('abc', 'recordName', 'Locality');
        RecordCheckUtilityClass.checkRecord('abc', 'recordName', 'Pincode' );
        RecordCheckUtilityClass.checkRecord('abc', 'recordName', 'State');
        
    }
    
    @isTest
    static void testMe2(){
        Account acc = new Account();
        
        String recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Doctor').getRecordTypeId();
        if(String.isNotBlank(recordTypeId))
            acc.RecordTypeId = recordTypeId;
        acc.FirstName = 'test';
        acc.LastName = 'test';
        acc.alletec_doctorid__c = '124';
        insert acc;
        
        System.assertEquals(acc.LastName,'test');
        
        RecordCheckUtilityClass.checkRecords(new Set<String>{'124','12334'}, new Set<String>{'124-test','12334-test2'}, Label.Account);
        
        RecordCheckUtilityClass.checkRecords(new Set<String>{'124','125'}, new Set<String>{'124-test','125-test2'}, Label.Doctor);
        
        Business_Unit__c bu = new Business_Unit__c();
        bu.Name='Test Business'; 
        bu.HIS_ID__c = '123';
        insert bu;    
        
        System.assertEquals(bu.Name,'Test Business');
        
        Lead__c leadObj = new Lead__c();
        leadObj.Name = 'Test Lead';
        leadObj.RecordtypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('CMP').getRecordTypeId();
        leadObj.Max_Id__c = 'JJH.7878';
        leadObj.Stage__c='New';
        insert leadObj;
        
        System.assertEquals(leadObj.Name,'Test Lead');
        
        RecordCheckUtilityClass.checkRecords(new Set<String>{'JJH.7878','JJH.78781'}, new Set<String>{'JJH.7878-Test Lead','JJH.78781-Test Lead1'}, Label.Lead);
        
        set<String> setIds = new set<String>();
        setIds.add('JJH.7878');
        setIds.add('125');
        setIds.add('124');
        setIds.add('123');
        
        System.assert(setIds.size()>0,' Set Id is not Blank');
        
        set<String> setNames = new set<String>();
        setNames.add('JJH.7878-test');
        setNames.add('abc');
        setNames.add('Test');
        
        System.assertEquals(3,setNames.size());
        
        RecordCheckUtilityClass.checkRecords(setIds, setNames, 'Gender');
        RecordCheckUtilityClass.checkRecords(setIds, setNames, 'MaritalStatus');
        RecordCheckUtilityClass.checkRecords(setIds, setNames, 'BloodGroup');
        RecordCheckUtilityClass.checkRecords(setIds, setNames, 'City');
        RecordCheckUtilityClass.checkRecords(setIds, setNames, 'Country');
        RecordCheckUtilityClass.checkRecords(setIds, setNames, 'Locality');
        RecordCheckUtilityClass.checkRecords(setIds, setNames, 'Pincode');
        RecordCheckUtilityClass.checkRecords(setIds, setNames, 'State');
        
        
        RecordCheckUtilityClass.checkRecords(new Set<String>{'123','1235'}, new Set<String>{'123-test','1235-test2'}, Label.Business_Unit);
        
        Prospect__c prospect = new Prospect__c();
        prospect.Name = 'TEST';
        prospect.Stage__c = 'Admission Advised';
        prospect.Max_Id__c = 'KJH876';
        prospect.Source__c = 'ACD Page';
        insert prospect;        
        
        System.assertEquals(prospect.Name,'TEST');
        
        RecordCheckUtilityClass.checkRecords(new Set<String>{'KJH876','KJH8766'}, new Set<String>{'KJH876-TEST','KJH8766-TEST2'}, Label.Prospect);
        
        Prospect__c prospect2 = new Prospect__c();
        prospect2.Name = 'TEST';
        prospect2.Stage__c = 'Admission Advised';
        prospect2.Max_Id__c = 'abcd';
        prospect2.Source__c = 'ACD Page';
        insert prospect2;       
        
        System.assertEquals(prospect2.Max_Id__c,'abcd');
        
        RecordCheckUtilityClass.checkRecords(new Set<String>{'abcd','abcdd'}, new Set<String>{'abcd-TEST','abcdd-TEST2'}, Label.ProspectEstimation);

        
        Account acc1 = new Account();
        String recordTypeId1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId();
        if(String.isNotBlank(recordTypeId))
            acc1.RecordTypeId = recordTypeId1;
        acc1.FirstName = 'test';
        acc1.LastName = 'test';
        acc1.Max_ID__c = '124';
        insert acc1;
        
        System.assertEquals(acc1.FirstName,'test');
        
        RecordCheckUtilityClass.checkRecords(new Set<String>{'124','125'}, new Set<String>{'124-test','125-test2'}, Label.Patient);
        
        Department__c dept = new Department__c();
        dept.name = 'test';
        dept.alletec_id__c = 123;
        insert dept;
        
        System.assertEquals(dept.name,'test');
        
        Map<String, String> testId101 = RecordCheckUtilityClass.checkRecords(new Set<String>{'123','128'}, new Set<String>{'123-test','128-test2'}, Label.Department);
        
        System.assert(testId101 != NULL,'test101 compiled');
        
        Speciality__c sp = new Speciality__c();
        sp.name = 'tes';
        sp.HIS_ID__c = '123';        
        insert sp;
        
        System.assertEquals(sp.HIS_ID__c, '123');
        
        Map<String, String> testId102 = RecordCheckUtilityClass.checkRecords(new Set<String>{'123','128'}, new Set<String>{'123-tes','128-tes2'}, Label.Specialization);
        
        System.assert(testId102 != NULL,'test102 compiled');
    }
}