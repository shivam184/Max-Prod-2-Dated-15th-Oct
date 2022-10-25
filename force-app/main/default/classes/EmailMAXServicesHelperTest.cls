@istest
public class EmailMAXServicesHelperTest {
    public static testmethod void EmailTest(){
        Max_at_Home_OP_Process__c  mh = new Max_at_Home_OP_Process__c();
        mh.Hospital_Location__c='Saket (DDF)';
        mh.Patient_Name__c ='Test';
        mh.Phone_Number__c='1234567890';
        mh.Max_ID__c ='Test@max12';
        insert mh;
        
        Max_at_Home_OP_Process__c  mh1 = new Max_at_Home_OP_Process__c();
        mh1.Hospital_Location__c='Vaishali';
        mh1.Patient_Name__c ='Test1';
        mh1.Max_ID__c ='Test@max123';
        insert mh1;
        
        Max_at_Home_OP_Process__c  mh2 = new Max_at_Home_OP_Process__c();
        mh2.Hospital_Location__c='Shalimar Bagh';
        mh2.Patient_Name__c ='Test1';
        mh2.Max_ID__c ='Test@max123';
        insert mh2;
        
        Max_at_Home_OP_Process__c  mh7 = new Max_at_Home_OP_Process__c();
        mh7.Hospital_Location__c='Gurgaon';
        mh7.Patient_Name__c ='Test1';
        mh7.Max_ID__c ='Test@max123';
        insert mh7;
        
        Max_at_Home_OP_Process__c  mh8 = new Max_at_Home_OP_Process__c();
        mh8.Hospital_Location__c='Nanavati Hospital';
        mh8.Patient_Name__c ='Test1';
        mh8.Max_ID__c ='Test@max123';
        insert mh8;
       
        Service_Lead__c sv = new Service_Lead__c();
        sv.Related_To__c=mh.id;
        sv.Service_Name__c='X Ray';
        sv.Primary_Disposition__c='Lead confirmed';
        sv.Sub_Disposition__c='Same Day';
        insert sv;
        
        Service_Lead__c sv10 = new Service_Lead__c();
        sv10.Related_To__c=mh8.id;
        sv10.Service_Name__c='X Ray';
        sv10.Primary_Disposition__c='Lead confirmed';
        sv10.Sub_Disposition__c='Same Day';
        insert sv10;
        
        Service_Lead__c sv9 = new Service_Lead__c();
        sv9.Related_To__c=mh7.id;
        sv9.Service_Name__c='X Ray';
        sv9.Primary_Disposition__c='Lead confirmed';
        sv9.Sub_Disposition__c='Same Day';
        insert sv9;
        
          
        Service_Lead__c sv4 = new Service_Lead__c();
        sv4.Related_To__c=mh2.id;
        sv4.Service_Name__c='X Ray';
        sv4.Primary_Disposition__c='Lead confirmed';
        sv4.Sub_Disposition__c='Same Day';
        insert sv4;

        
        Service_Lead__c sv3 = new Service_Lead__c();
        sv3.Related_To__c=mh1.id;
        sv3.Service_Name__c='X Ray';
        sv3.Primary_Disposition__c='Lead confirmed';
        sv3.Sub_Disposition__c='Same Day';
        insert sv3;
        
        Service_Lead__c sv1 = new Service_Lead__c();
        sv1.Related_To__c=mh.id;
        sv1.Service_Name__c='X Ray';
        sv1.Primary_Disposition__c='Cancellation';
        sv1.Sub_Disposition__c='All Service name In Dropdown';
        insert sv1;
        
        Service_Lead__c sv2 = new Service_Lead__c();
        sv2.Related_To__c=mh.id;
        sv2.Service_Name__c='X Ray';
        sv2.Primary_Disposition__c='Not Required';
        sv2.Sub_Disposition__c='Price issues';
        insert sv2;
        
        system.debug(sv);
        list<Service_Lead__c> svlist = new list<Service_Lead__c>();
        svlist = [Select Service_Name__c,Primary_Disposition__c,Sub_Disposition__c,Hospital__c,Service_Lead__c.Related_To__c from Service_Lead__c  where Service_Lead__c.Related_To__c=:mh.Id];
        test.startTest();
        EmailMAXServicesHelper.EmailService(svlist);
        test.stopTest();
        
    }
}