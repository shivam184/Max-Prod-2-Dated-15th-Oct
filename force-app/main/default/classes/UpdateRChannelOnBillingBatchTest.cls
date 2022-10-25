@isTest
public class UpdateRChannelOnBillingBatchTest{
    @isTest
    public static void test1(){
        String recordTypeIdd = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId();
        Account ac = new Account();
        ac.RecordTypeId = recordTypeIdd;
        ac.LastName = 'Test';
        ac.Max_ID__c = 'test123';
        ac.PersonMobilePhone = '9876543210';
        ac.PersonEmail = 'test@gm.com';
        ac.max_id__c = 'max.123';

        insert ac;

        Business_Unit__c bu = new Business_Unit__c();
        bu.Business_Unit_Code__c = 'test';
        bu.Name = 'tsetBusinessUnit';
        insert bu;

        billing_summary__c b = new billing_summary__c();
        b.alletec_channelType__c = 'PSU';
        b.name__c = 'max.123';
        b.alletec_hospitallocation__c = bu.id;
        b.alletec_ipid__C = '0';
        b.patient__c = ac.id;
        insert b;
        test.startTest();
        database.executeBatch(new updateRChannelOnBillingBatch());
        test.stoptest();
    }
    @isTest
    public static void test2(){
        String recordTypeIdd = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId();
        Account ac = new Account();
        ac.RecordTypeId = recordTypeIdd;
        ac.LastName = 'Test';
        ac.Max_ID__c = 'test123';
        ac.PersonMobilePhone = '9876543210';
        ac.PersonEmail = 'test@gm.com';
        ac.max_id__c = 'max.123';

        insert ac;

        Business_Unit__c bu = new Business_Unit__c();
        bu.Business_Unit_Code__c = 'test';
        bu.Name = 'tsetBusinessUnit';
        insert bu;

        billing_summary__c b = new billing_summary__c();
        b.alletec_channelType__c = 'international';
        b.name__c = 'max.123';
        b.alletec_isInternational__c=true;
        b.alletec_hospitallocation__c = bu.id;
        b.alletec_ipid__C = '0';
        b.patient__c = ac.id;
        insert b;
        test.startTest();
        database.executeBatch(new updateRChannelOnBillingBatch());
        test.stoptest();
    }
    @istest
    public static void test3(){
        String recordTypeIdd = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId();
        Account ac = new Account();
        ac.RecordTypeId = recordTypeIdd;
        ac.LastName = 'Test';
        ac.Max_ID__c = 'test123';
        ac.PersonMobilePhone = '9876543210';
        ac.PersonEmail = 'test@gm.com';
        ac.max_id__c = 'max.123';

        insert ac;

        Business_Unit__c bu = new Business_Unit__c();
        bu.Business_Unit_Code__c = 'test';
        bu.Name = 'tsetBusinessUnit';
        insert bu;

        admission_acknowledgement__c adm=new admission_Acknowledgement__C();
adm.max_id__c='max.123';
adm.ipid__C='0';
insert adm;

        billing_summary__c b = new billing_summary__c();
        b.alletec_channelType__c = 'PSU';
        b.name__c = 'max.123';
        b.alletec_hospitallocation__c = bu.id;
        b.alletec_ipid__C = '0';
        b.admission_acknowledgement__C=adm.id;
        b.patient__c = ac.id;
        insert b;
        test.startTest();
        database.executeBatch(new updateRChannelOnBillingBatch());
        test.stoptest();
    }
    @istest
    public static void test4(){
        String recordTypeIdd = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId();
        Account ac = new Account();
        ac.RecordTypeId = recordTypeIdd;
        ac.LastName = 'Test';
        ac.Max_ID__c = 'test123';
        ac.PersonMobilePhone = '9876543210';
        ac.PersonEmail = 'test@gm.com';
        ac.max_id__c = 'max.123';

        insert ac;

        Business_Unit__c bu = new Business_Unit__c();
        bu.Business_Unit_Code__c = 'test';
        bu.Name = 'tsetBusinessUnit';
        insert bu;

        admission_acknowledgement__c adm=new admission_Acknowledgement__C();
adm.max_id__c='max.123';
adm.ipid__C='0';
insert adm;

        billing_summary__c b = new billing_summary__c();
        b.alletec_channelType__c = 'International';
        b.name__c = 'max.123';
        b.alletec_isInternational__c=true;
        b.alletec_hospitallocation__c = bu.id;
        b.alletec_ipid__C = '0';
        b.admission_acknowledgement__C=adm.id;
        b.patient__c = ac.id;
        insert b;
        test.startTest();
        database.executeBatch(new updateRChannelOnBillingBatch());
        test.stoptest();
    }
@isTest
    public static void test5(){
        String recordTypeIdd = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId();
        Account ac = new Account();
        ac.RecordTypeId = recordTypeIdd;
        ac.LastName = 'Test';
        ac.Max_ID__c = 'test123';
        ac.PersonMobilePhone = '9876543210';
        ac.PersonEmail = 'test@gm.com';
        ac.max_id__c = 'max.123';

        insert ac;

        Business_Unit__c bu = new Business_Unit__c();
        bu.Business_Unit_Code__c = 'test';
        bu.Name = 'tsetBusinessUnit';
        insert bu;

        billing_summary__c b = new billing_summary__c();
        b.alletec_channelType__c = 'Walk-in';
        b.name__c = 'max.123';
        b.alletec_hospitallocation__c = bu.id;
        b.alletec_ipid__C = '0';
        b.patient__c = ac.id;
        insert b;
        test.startTest();
        database.executeBatch(new updateRChannelOnBillingBatch());
        test.stoptest();
    }
    @isTest
    public static void test6(){
        String recordTypeIdd = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId();
        Account ac = new Account();
        ac.RecordTypeId = recordTypeIdd;
        ac.LastName = 'Test';
        ac.Max_ID__c = 'test123';
        ac.PersonMobilePhone = '9876543210';
        ac.PersonEmail = 'test@gm.com';
        ac.max_id__c = 'max.123';

        insert ac;

        Business_Unit__c bu = new Business_Unit__c();
        bu.Business_Unit_Code__c = 'test';
        bu.Name = 'tsetBusinessUnit';
        insert bu;

        billing_summary__c b = new billing_summary__c();
        b.alletec_channelType__c = 'Cash';
        b.name__c = 'max.123';
        b.alletec_hospitallocation__c = bu.id;
        b.alletec_ipid__C = '0';
        b.patient__c = ac.id;
        insert b;
        test.startTest();
        database.executeBatch(new updateRChannelOnBillingBatch());
        test.stoptest();
    }
}