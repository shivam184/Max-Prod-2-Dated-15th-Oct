/***************************************************
 * Date: 10th August 2022                          *
 * Written By: Shivam Gupta                        *
 * Class for Email Triggering on MH service Leads  *
 * Trigger:EmailMAXServicesTrigger                 *
 * Custom Metadata:MH Service Lead                 *
 * ************************************************/


public class EmailMAXServicesHelper {
    
    public static list<Service_Lead__c> EmailService(list<Service_Lead__c>Servicelead){
        system.debug(Servicelead); 
        list<Service_Lead__c> Service = new list<Service_Lead__c>();
        list<Service_Lead__c> servicefinal= new list<Service_Lead__c>();
        Service=[Select Hospital__c,Name,Primary_Disposition__c,Service_Name__c,Sub_Disposition__c from Service_Lead__c where id=:Servicelead];
        system.debug(Service);
        for(Service_Lead__c ser:Service){
            if(ser.Primary_Disposition__c=='Lead confirmed' && ser.Sub_Disposition__c=='Same Day'){
                servicefinal.add(ser);
            }
            else if(ser.Primary_Disposition__c=='Cancellation'&& ser.Sub_Disposition__c=='All Service name In Dropdown'){
                servicefinal.add(ser);
            }
            else if(ser.Primary_Disposition__c=='Not Required'&& ser.Sub_Disposition__c=='Already services availed from Max Units'||ser.Sub_Disposition__c=='Price issues'||ser.Sub_Disposition__c=='NI for Home services'||ser.Sub_Disposition__c==' Want Hard copy of Reports'||ser.Sub_Disposition__c=='Will decide Later- NO CB required'||ser.Sub_Disposition__c=='Medicine Aleady in Stock with pt.'||ser.Sub_Disposition__c=='Seeking More discount than approved slabs')
            {
                servicefinal.add(ser); 
            }
            SendEmailTemplateWithTemplate(servicefinal,Servicelead);
        }
        
        return servicefinal; 
    }
    
    public static void SendEmailTemplateWithTemplate(list<Service_Lead__c>servicefinal,list<Service_Lead__c>Servicelead) {
        System.debug('servicefinal'+servicefinal);
        system.debug('Servicelead'+Servicelead);
        id relatedid;
        for(Service_Lead__c ser:Servicelead){
            relatedid=ser.Related_To__c;
        }
        system.debug(relatedid);
        list<Max_at_Home_OP_Process__c> maxop = new list<Max_at_Home_OP_Process__c>();
        maxop=[select id,Name,Patient_Name__c,Hospital_Location__c,source__c, Age__c ,Phone_Number__c ,Max_ID__c ,Address__c, Remark__c,Service_Delivery_Address__c  from Max_at_Home_OP_Process__c where id=:relatedid];
        system.debug(maxop);
                
        
        string Hospitallocation;
        string servicetype;
        if(!servicefinal.isEmpty()){
            for(Service_Lead__c service:servicefinal){
                servicetype=service.Service_Name__c;
                Hospitallocation=service.Hospital__c;
                system.debug(servicetype);
                            }
            if(Hospitallocation!=null){
            if(Hospitallocation=='Saket (DDF)'|| Hospitallocation=='Saket (MSSH)'||Hospitallocation=='Max Smart-MSSSH'||Hospitallocation=='Panchsheel Park'||Hospitallocation=='MAX Lajpat Nagar'||Hospitallocation=='Max MedCentre(LJPT)'){
                Hospitallocation='Saket (DDF),Saket (MSSH),Max Smart-MSSSH,Panchsheel Park,MAX Lajpat Nagar,Max MedCentre(LJPT),';
            }
            else if(Hospitallocation=='Vaishali'||Hospitallocation=='Patparganj'||Hospitallocation=='Noida'){
                 Hospitallocation='Vaishali,Patparganj,Noida';
            }
            else if(Hospitallocation=='BLK Hospital'||Hospitallocation=='Shalimar Bagh'||Hospitallocation=='Noida'){
               Hospitallocation='BLK Hospital,Shalimar Bagh';
            }
            else if(Hospitallocation=='Mohali'||Hospitallocation=='Bhatinda'){
                Hospitallocation='Mohali,Bhatinda';
            }
            else if(Hospitallocation=='Dehradun'){
                Hospitallocation='Dehradun';
            }
            else if(Hospitallocation=='Gurgaon'){
                Hospitallocation='Gurgaon';
            }
            else if(Hospitallocation=='Nanavati Hospital'){
                Hospitallocation='Nanavati Hospital';
            }}
            system.debug(Hospitallocation);
            List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
            List<MH_Service_Lead__mdt> listEmailDomain = [SELECT Id,MasterLabel,Email__c,Hospital__c,Service_type__c,cc__c from MH_Service_Lead__mdt where Hospital__c=:Hospitallocation AND Service_type__c=:servicetype];
            system.debug(listEmailDomain);
            if(listEmailDomain.size()>0){
               
            System.debug(listEmailDomain);
               
                list<string> vr1 =new list<string>();
                for(MH_Service_Lead__mdt a:listEmailDomain){
                    if(a.Email__c!=null){
                        system.debug(a.Email__c);
                    vr1=a.Email__c.split(',');
                    }}
                system.debug(vr1);
              
            list<string> vr2= new list<string>();
                for(MH_Service_Lead__mdt b:listEmailDomain){
                    if(b.cc__c!=null){
                    vr2=b.cc__c.split(',');
                    }}
                system.debug(vr2);
                for(Max_at_Home_OP_Process__c Maxathome:maxop){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setSubject('MAH Lead |'+ servicetype +' '+'for'+' '+ Maxathome.Patient_Name__c );
                 
            String body = 'Dear Team,'+'<br>'+'<br>'+'Please find the below Lead details.We request you to contact the patient/attendant ASAP in order to provide service'+'<br>'+'<br>'+'<br>';
            body +=  '<B>Patient Name :- </B>' + Maxathome.Patient_Name__c +'<br>';
            body += '<B>Age :- </B>'+Maxathome.Age__c+'<br>';
            body += '<B>Contact Number :- </B>'+Maxathome.Phone_Number__c+'<br>';
            body += '<B>Service Line Interested In :- </B>'+servicetype+'<br>';
            body += '<B>Max ID :- </B>'+Maxathome.Max_ID__c+'<br>'; 
            body += '<B>Location/Address :- </B>'+Maxathome.Address__c+'<br>';
            body += '<B>OPD Hospital Location :- </B>'+Maxathome.Hospital_Location__c+'<br>';
            body += '<B>Source :- </B>'+Maxathome.Source__c+'<br>'; 
            body += '<B>Service Delivery Address :- </B>'+Maxathome.Service_Delivery_Address__c+'<br>'+'<br>';
            
            body += '<B>Remarks of Agent :- </B>'+Maxathome.Remark__c+'<br>';
            body += '<br>Regards<br>Team CC<br>';       
            
            mail.setHtmlBody(body);
            mail.setToAddresses(vr1);
            mail.setCcAddresses(vr2);
            emailList.add(mail);
            system.debug('Mail Sent check Inbox');
            if(!emailList.isEmpty()){
                Messaging.sendEmail(emailList);
            }
            }
            } 
        }
        }
        
        
        
    }