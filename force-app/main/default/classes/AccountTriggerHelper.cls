public class AccountTriggerHelper {
    
    public static void doInsert(){
        String recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('MECP Doctor Business').getRecordTypeId();        
        Map<Id,Account_Territory__c> mapToAccTerr;             
        //AccountNumberGeneration__c ang = AccountNumberGeneration__c.getOrgDefaults();  //custom setting
        AccountNumberGeneration__c ang = [SELECT id,AutoNumber__c,Name FROM AccountNumberGeneration__c LIMIT 1]; //custom setting
        Integer oldValue = Integer.valueOf(ang.AutoNumber__c);
        Set<Id> accTerritory = new Set<Id>();
        for(SObject sObj : trigger.New){           
            Account acc = (Account)sObj;
            if(recordTypeId == acc.RecordTypeId){
                if(acc.Account_Territory__c != NULL)
                    accTerritory.add(acc.Account_Territory__c);                               
            }
        }
        
        if(accTerritory.size()>0 && accTerritory != NULL)            
            mapToAccTerr = new Map<Id,Account_Territory__c>([SELECT Id,Business_Unit__r.Business_Unit_Code__c FROM Account_Territory__c WHERE Id IN : accTerritory]);
        
        for(SObject sObj : trigger.New){           
            Account acc = (Account)sObj;
            if(recordTypeId == acc.RecordTypeId){
                if(acc.Account_Territory__c != NULL){
                    if(mapToAccTerr.containsKey(acc.Account_Territory__c)){                      
                        if(mapToAccTerr.get(acc.Account_Territory__c).Business_Unit__r.Business_Unit_Code__c != NULL){                            
                            if(acc.Account_Channel__c != NULL){
                                acc.AccountNumber=mapToAccTerr.get(acc.Account_Territory__c).Business_Unit__r.Business_Unit_Code__c+'-'+acc.Account_Channel__c.substring(0,1)+'-'+String.valueOf((Integer)ang.AutoNumber__c);
                                if(ang.AutoNumber__c !=NULL){
                                    ang.AutoNumber__c+=1;
                                }
                            }
                        }
                    }
                }
            }
        }    
        
        if(oldValue < Integer.valueOf(ang.AutoNumber__c))
          updateAccountNumberGeneration(Integer.valueOf(ang.AutoNumber__c));        
    }
    
    @future(callout=true)
    private static void updateAccountNumberGeneration(Integer numberOfTimes){
        AccountNumberGeneration__c ang = [SELECT id,AutoNumber__c,Name FROM AccountNumberGeneration__c LIMIT 1]; //custom setting
        update New AccountNumberGeneration__c(
          Id = ang.Id,
            AutoNumber__c = numberOfTimes
        );
    }    
    
    
    public static void accountFieldMapping(){ 
        map<String,String> bloodGroupMap = new map<String,String>();
        map<String,String> genderMap = new map<String,String>();
        map<String,String> maritalStatusMap = new map<String,String>();
        map<String,String> nationalityMap = new map<String,String>();
        map<String,String> occupationMap = new map<String,String>();
        map<String,String> titleMap = new map<String,String>();
        
        map<String,String> cityMap = new map<String,String>();
        map<String,String> countryMap = new map<String,String>();
        map<String,String> hslocationMap = new map<String,String>();
        map<Decimal,String> departmentMap = new map<Decimal,String>();
        
        for(Address_Master__c city : [SELECT Id,alletec_cityid__c FROM Address_Master__c WHERE Recordtype.Name=:'City']){
            if(String.isNotBlank(city.alletec_cityid__c ))
                cityMap.put(city.alletec_cityid__c,city.Id);
           // system.debug('====cityMap='+cityMap);
        }
        
        for(Address_Master__c country : [SELECT Id,alletec_countryid__c FROM Address_Master__c WHERE Recordtype.Name=:'Country']){
            if(String.isNotBlank(country.alletec_countryid__c))
                countryMap.put(country.alletec_countryid__c,country.Id);
            //system.debug('====countryMap='+countryMap);
            
        }   
        
        for(Business_Unit__c bu : [SELECT Id,HIS_ID__c FROM Business_Unit__c]){
            if(String.isNotBlank(bu.HIS_ID__c))
                hslocationMap.put(bu.HIS_ID__c,bu.Id);
            //system.debug('====hslocationMap='+hslocationMap);
            
        }
        for(Department__c dep : [SELECT Id, alletec_id__c FROM Department__c]){
            if(dep.alletec_id__c!=null)
                departmentMap.put(dep.alletec_id__c,dep.Id);
            //system.debug('====departmentMap='+departmentMap);
            
        }
        
        
        //--------------------------
        
        //BLOOD GROUP
        Map<String, Blood_Group__c> broups = Blood_Group__c.getAll();
        
        // Sort them by name
        List<String> bgroupsNames = new List<String>();
        bgroupsNames.addAll(broups.keySet());
        
        
        // Create the Select Options.
        for (String bgname : bgroupsNames) {
            Blood_Group__c bg = broups.get(bgname);
            bloodGroupMap.put(bg.HIS_ID__c,bg.Name);
            //system.debug('====bloodGroupMap='+bloodGroupMap);
            
        }
        
        
        Map<String, Marital_Status__c > maritals = Marital_Status__c.getAll();
        
        // Sort them by name
        List<String> maritalStatuses = new List<String>();
        maritalStatuses.addAll(maritals.keySet());
        
        
        // Create the Select Options.
        for (String mat : maritalStatuses) {
            Marital_Status__c mats = maritals.get(mat);
            maritalStatusMap.put(mats.HIS_ID__c,mats.Name);
           // system.debug('====maritalStatusMap='+maritalStatusMap);
            
        }
        
        
        Map<String, Gender__c> genders = Gender__c.getAll();
        
        // Sort them by name
        List<String> genderNames = new List<String>();
        genderNames.addAll(genders.keySet());
        
        
        // Create the Select Options.
        for (String gn : genderNames) {
            Gender__c bg = genders.get(gn);
            genderMap.put(bg.HIS_ID__c,bg.Name);
           // system.debug('====genderMap='+genderMap);
            
        }
        
        
        
        Map<String, Nationality__c> nationalities = Nationality__c.getAll();
        
        // Sort them by name
        List<String> natNames = new List<String>();
        natNames.addAll(nationalities.keySet());
        
        
        // Create the Select Options.
        for (String nat : natNames) {
            Nationality__c bg = nationalities.get(nat);
            nationalityMap.put(bg.HIS_ID__c,bg.Name);
           // system.debug('====nationalityMap='+nationalityMap);
            
        }
        
        
        
        
        Map<String, Occupation__c> occupations = Occupation__c.getAll();
        
        // Sort them by name
        List<String> occupationNames = new List<String>();
        occupationNames.addAll(occupations.keySet());
        
        
        // Create the Select Options.
        for (String occup : occupationNames) {
            Occupation__c bg = occupations.get(occup);
            occupationMap.put(bg.HIS_ID__c,bg.Name);
           // system.debug('====occupationMap='+occupationMap);
            
        }
        
        //-----------------DOCTOR-----------------//
        Map<String, Title__c > titles = Title__c.getAll();
        
        // Sort them by name
        List<String> titleNames = new List<String>();
        titleNames.addAll(titles.keySet());
        
        
        // Create the Select Options.
        for (String occup : titleNames) {
            Title__c bg = titles.get(occup);
            titleMap.put(bg.HIS_ID__c,bg.Name);
           // system.debug('====titleMap='+titleMap);
            
        }
        
        
        
        
        
        
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId();
      //  system.debug('======devRecordTypeId='+devRecordTypeId);
        
        Id doctorRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Doctor').getRecordTypeId();
        List<Account> accList = (List<Account>)trigger.new;
        //Map the values for Account Records
        for(Account acc : accList){
        //    system.debug('======RecordtypeId='+acc.RecordtypeId);
            
            if(acc.RecordtypeId==devRecordTypeId){
                
                if(String.isNotBlank(acc.alletec_bloodgroup__c) && bloodGroupMap.containsKey(acc.alletec_bloodgroup__c))
          //          acc.alletec_bloodgroup__c = bloodGroupMap.get(acc.alletec_bloodgroup__c);
                system.debug('====acc.alletec_bloodgroup__c='+acc.alletec_bloodgroup__c);
                if(String.isNotBlank(acc.Gender_HIS__c) && genderMap.containsKey(acc.Gender_HIS__c))
                    acc.Gender__c = genderMap.get(acc.Gender_HIS__c);
            //    system.debug('====acc.Gender_HIS__c='+acc.Gender__c);
                
                if(String.isNotBlank(acc.Marital_Status_HIS__c) && maritalStatusMap.containsKey(acc.Marital_Status_HIS__c))
                    acc.Marital_Status__c = maritalStatusMap.get(acc.Marital_Status_HIS__c);
              //  system.debug('====acc.Marital_Status__c='+acc.Marital_Status__c);
                
                if(String.isNotBlank(acc.address2_country__c) && nationalityMap.containsKey(acc.address2_country__c))
                    acc.address2_country__c = nationalityMap.get(acc.address2_country__c);
                //system.debug('====acc.address2_country__c='+acc.address2_country__c);
                
                if(String.isNotBlank(acc.jobtitle__c) && occupationMap.containsKey(acc.jobtitle__c))
                    acc.jobtitle__c = occupationMap.get(acc.jobtitle__c);
                //system.debug('====acc.jobtitle__c='+acc.jobtitle__c);
                
                if(String.isNotBlank(acc.City__c) && cityMap.containsKey(acc.City__c))
                    acc.CityAddressMaster__c = cityMap.get(acc.City__c);
                if(String.isNotBlank(acc.Country__c) && countryMap.containsKey(acc.Country__c))
                    acc.CountryAddressMaster__c = countryMap.get(acc.Country__c);
                if(String.isNotBlank(acc.Hospital_Location_HIS__c) && hslocationMap.containsKey(acc.Hospital_Location_HIS__c))
                    acc.alletec_mhulocation__c = hslocationMap.get(acc.Hospital_Location_HIS__c);
                //system.debug('====acc.alletec_mhulocation__c='+acc.alletec_mhulocation__c);
                
                if(String.IsNotBlank(acc.Department_ID__c) && departmentMap.containsKey(Integer.valueOf(acc.Department_ID__c)))
                    acc.Department__c = departmentMap.get(Integer.valueOf(acc.Department_ID__c));
            }
            else if(acc.RecordtypeId==doctorRecordTypeId){
                if(String.IsNotBlank(acc.Department_ID__c) && departmentMap.containsKey(Integer.valueOf(acc.Department_ID__c)))
                    acc.Department__c = departmentMap.get(Integer.valueOf(acc.Department_ID__c));
                //if(String.IsNotBlank(acc.Title_HIS__c) && titleMap.containsKey(acc.Title_HIS__c))
                //acc.Salutation = titleMap.get(acc.Title_HIS__c);
            }
        }
    }

    
    public static void validationDuplicate(List<Account> triggerNew) {
        map<string,Account> namemap = new map<string,Account>();
        Id recordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Corporate PSU').getRecordTypeId();
        
        for(Account acc : triggerNew){ 
            if(acc.RecordTypeId ==recordtypeId){
                if(Acc.Name!=null){
                    namemap.put(acc.Name.toLowerCase(),acc);
                }
            }
        }
        if(namemap!=null && namemap.size() > 0){
            for(Account existAcc : [SELECT Name from Account where RecordTypeId=:recordtypeId AND Name IN:namemap.keyset() Limit 50000]){
                if(namemap.containskey(existAcc.Name.toLowerCase())){
                    Account accou = namemap.get(existAcc.Name.toLowerCase());
                    accou.addError('There is already a Account with this Name');
                }
            }
        }
    }
    
    @future
    public static void mapMaxIDonDigtialLeads(Set<String> setOfAccountIds){
        
        String recordTypeAcntId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId();
        Integer mnth =  Integer.valueOf(System.Label.NmonthsDigitalLeads);
        map<string,Account> mapPhoneWithAcntId = new map<string,Account>();
        map<string,Account> mapEmailWithAcntId = new map<string,Account>();
        
        Set<string> accphpsetId = new Set<string>();
        Set<string> accemlsetId = new Set<string>();
        
        List<Account> triggerNew = [SELECT ID, RecordTypeId, PersonMobilePhone, PersonEmail, Max_ID__c FROM Account WHERE ID IN : setOfAccountIds];
        
        for(SObject sObj : triggerNew){           
            Account acc = (Account)sObj;
            if(String.isNotBlank(recordTypeAcntId)){
                if(acc.RecordTypeId == recordTypeAcntId){
                    if(acc.PersonMobilePhone!=null)
                        mapPhoneWithAcntId.put(acc.PersonMobilePhone,acc);
                    else if(acc.PersonEmail!=null)
                        mapEmailWithAcntId.put(acc.PersonEmail,acc);
                }
            }            
        }
    //    system.debug('-mapPhoneWithAcntId-->>>>'+mapPhoneWithAcntId.size());
      //  system.debug('-mapEmailWithAcntId-->>>>'+mapEmailWithAcntId.size());
        
        if(mapEmailWithAcntId.keySet().size()>0 || mapPhoneWithAcntId.keySet().size()>0){
            
            String query = 'Select Id,Max_ID__c,Mobile_Phone__c,Email__c  from Lead__c where RecordType.Name = \'Digital Customer Acquisition\' AND Max_ID__c  = NULL  ';
            if(mapPhoneWithAcntId.keySet().Size()>0){
                accphpsetId.addall(mapPhoneWithAcntId.keySet());
                query += ' AND Mobile_Phone__c IN:accphpsetId ';
            }
            if(mapEmailWithAcntId.keySet().Size()>0){
                accemlsetId.addall(mapEmailWithAcntId.keySet());
                query += ' AND Email__c IN:accemlsetId ';
            }
            query +=' AND createdDate>=LAST_N_MONTHS:'+mnth ;
            
           // system.debug('-query-->>>>'+Database.query(query));
            List<Lead__c> leadList = new List<Lead__c>();
            
            for(Lead__c ld : Database.query(query)){
                if(ld.Mobile_Phone__c!=null && mapPhoneWithAcntId.containsKey(ld.Mobile_Phone__c)){
                    ld.Max_ID__c = mapPhoneWithAcntId.get(ld.Mobile_Phone__c).Max_ID__c;
                    leadList.add(ld);
                }else if(ld.Email__c!=null && mapEmailWithAcntId.containsKey(ld.Email__c)){
                    ld.Max_ID__c = mapEmailWithAcntId.get(ld.Email__c).Max_ID__c;
                    leadList.add(ld);
                }
            }
            //system.debug('--->>>>'+leadList.size());
            if(leadList != NULL && leadList.size() > 0)
                update leadList;
        }
    }
}