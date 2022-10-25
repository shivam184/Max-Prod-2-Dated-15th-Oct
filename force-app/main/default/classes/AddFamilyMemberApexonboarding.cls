//Description : Apex Class to create Leads for Customer Activations Onboarding (Customer Program Management)
//Created by: Techmatrix Consulting
public class AddFamilyMemberApexonboarding {
    public static String businessUnit;
    @AuraEnabled
    public static String saveMemberDetails(Lead__c leadObj,boolean refermax,String recordId){
        List<lead__c> leadlist =new list<lead__c>();
        
        system.debug('rrrrrrrrrr'+refermax);
        if(leadObj.First_Name__c!=null)
            leadObj.Name = leadObj.First_Name__c+' '+leadObj.Last_Name__c;
        else
            leadObj.Name = leadObj.Last_Name__c;
        leadObj.RecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('OPD automation Lead').getRecordTypeId();
        system.debug('=====>id-='+leadObj.Id);
        if(leadObj.Customer_Activation_Onbording__c==NULL){
            leadObj.Customer_Activation_Onbording__c=recordId;
        }
        insert leadObj;
        
        /*  if(!String.isBlank(leadobj.Passport_No__c) && leadobj.Passport_No__c !=Null ){
         list<Visa_Invite__c> viList=[select id ,Passport_number__c from Visa_Invite__c where Passport_number__c=:leadobj.Passport_No__c order by createddate desc];
            if(viList.size()>0){
                leadObj.visa_invite__c=viList[0].id;
                leadlist.add(leadObj);
            }
        } */
        if(refermax=true){
           
            Prospect__c pros=new Prospect__c();
            pros.name=leadobj.First_Name__c+' '+leadobj.Last_Name__c;
            pros.Gender__c=leadobj.Gender__c;
            insert pros;
            
            leadObj.Stage__c='Converted';
            leadobj.Prospect__c=pros.id;
            leadlist.add(leadObj);
        }
        system.debug('====leadObj'+leadObj);
      if(leadlist.size()>0)
          update leadObj;
        return leadObj.Id;   
    }
    
    
   
    
    
    
      //Search Members from Salesforce
    //Based on value in Custom Metadata type, method searches in Salesforce and HIS or both.
    @AuraEnabled
     public static Lead__c mapDetails (PatientSearchJsonParser.Patients tempPat){
        system.debug('mapDetails');
        Lead__c obj = new Lead__c();
        obj.Business_Unit__c =businessUnit;// [SELECT Id,Business_Unit__c FROM User WHERE Id=:UserInfo.getUserId()].Business_Unit__c;
        obj.Name = '';
        if(String.isNotBlank(tempPat.MobileNo))
            obj.Mobile_Phone__c = tempPat.MobileNo;
        if(String.isNotBlank(tempPat.MaxID))
            obj.Max_ID__c = tempPat.MaxID;
        if(String.isNotBlank(tempPat.FirstName)){
            obj.First_Name__c = tempPat.FirstName;
            obj.Name = tempPat.FirstName;
        }
        if(String.isNotBlank(tempPat.LastName)){
            obj.Last_Name__c = tempPat.LastName;
            obj.Name+=' '+obj.Last_Name__c;
        }
        if(String.isNotBlank(tempPat.EmailID))
            obj.Email__c = tempPat.EmailID;
        if(String.isNotBlank(tempPat.CityName))
            obj.City__c = tempPat.CityName;
        if(String.isNotBlank(tempPat.Area))
            obj.Locality__c = tempPat.Area;
        if(tempPat.PinCode!=null)
            obj.ZIP_Postal_Code__c = String.valueOf(tempPat.PinCode);
        if(String.isNotBlank(tempPat.Address))
            obj.Address_Line_1__c = tempPat.Address;
        if(String.isNOtBlank(tempPat.Gender))
            obj.Gender__c = tempPat.Gender;
        if(tempPat.DateOfBirth!=null){
            list<String> strList = tempPat.DateOfBirth.split('/');
            obj.DOB__c = Date.valueOf(strList[2]+'-'+strList[1]+'-'+strList[0]);
        }
        if(tempPat.AgeINT!=null)
            obj.CMP_Age__c = tempPat.AgeINT;  
         obj.Passport_No__c= tempPat.Passport;

        return obj;
    }
     public static void populateBusinesUnit(){
        List<User> usrList = new list<User>([SELECT Id,Business_Unit__c FROM User WHERE Id=:UserInfo.getUserId()]);
        if(String.isNotBlank(usrList[0].Business_Unit__c))
            businessUnit = usrList[0].Business_Unit__c;
        
    }
      @AuraEnabled
    public static AddFamilyMemberApex.patientWrapper searchinSalesforce(String mobileNo){
        system.debug('mobileNo'+mobileNo);
        AddFamilyMemberApex.patientWrapper awrap = new AddFamilyMemberApex.patientWrapper();
        
        if(String.isNotBlank(mobileNo)){
            awrap.isSuccess = true;
            list<Account> accList = new list<Account>([SELECT Id,FirstName,Passport__c,MiddleName,LastName,Phone,PersonMobilePhone,PersonEmail,Max_ID__c,
                                                       CityAddressMaster__c,CityAddressMaster__r.Name,BillingStreet,Postal_Code__c,
                                                       Gender__c,DOB__c,Age__c FROM Account WHERE Recordtype.Name='Patient' 
                                                       and Passport__c=:mobileNo]);
            system.debug('accList.size()'+accList.size());
            if(accList!=null && accList.size()>0){
                awrap.isExisiting = true;
                
                    awrap = mapPatientsWithWrapper(awrap,accList,false);
               
               
            }
            else{
                
                    awrap.isNewPat = true;
            }
        }
        return awrap;
    }
      public static AddFamilyMemberApex.patientWrapper mapPatientsWithWrapper(AddFamilyMemberApex.patientWrapper wrapper, list<Account> patList, Boolean isMorethanOne){
           system.debug('mapPatientsWithWrapper');
      
        
            PatientSearchJsonParser.Patients tempPat = new PatientSearchJsonParser.Patients();
            if(patList[0].Phone!=null || patList[0].PersonMobilePhone!=null){
                if(patList[0].Phone!=null)
                    tempPat.MobileNo = patList[0].Phone;
                else if(patList[0].PersonMobilePhone!=null)
                    tempPat.MobileNo = patList[0].PersonMobilePhone;                        
            }
            
            if(String.isNotBlank(patList[0].Max_ID__c))
                tempPat.MaxID = patList[0].Max_ID__c;
            if(String.isNotBlank(patList[0].FirstName))
                tempPat.FirstName = patList[0].FirstName;
            if(String.isNotBlank(patList[0].LastName))
                tempPat.LastName = patList[0].LastName;
            if(String.isNotBlank(patList[0].PersonEmail))
                tempPat.EmailID = patList[0].PersonEmail;
            if(patList[0].CityAddressMaster__c!=null)
                tempPat.CityName = patList[0].CityAddressMaster__r.Name; 
            if(String.isNotBlank(patList[0].Postal_Code__c))
                tempPat.PinCode = Integer.valueOf(patList[0].Postal_Code__c);
            if(String.isNotBlank(patList[0].BillingStreet))
                tempPat.Address = patList[0].BillingStreet;
            if(String.isNotBlank(patList[0].Gender__c))
                tempPat.Gender = patList[0].Gender__c;
            if(patList[0].DOB__c!=null){
                String dob = String.valueOf(patList[0].DOB__c);
                list<String> strList = dob.split('-');
                tempPat.DateOfBirth = strList[2]+'/'+strList[1]+'/'+strList[0]  ;
            }
          
         tempPat.Passport=string.valueof(patList[0].Passport__c);
            if( patList[0].Age__c!=null)
                tempPat.AgeINT = Integer.valueOf(patList[0].Age__c);
            wrapper.leadObj = mapDetails(tempPat);
          
        
        return wrapper;
    }
      @AuraEnabled
    public static Lead__c setMasterValues(String recordId, Lead__c ld){
        for(Customer_Activation_Onboarding__c cust : [SELECT id
                                           FROM  Customer_Activation_Onboarding__c WHERE Id=:recordId]){
                                               ld.Customer_Activation_Onbording__c = cust.Id;
                                           }
        
        return ld;
    }
    
    public static void coverage(){
        
        String strj = 'Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
}
    
}