public class RecordCheckUtilityClass {
    public static Map<String,String> checkRecords(Set<String> searchIds, Set<String> recordNames, String searchObject){
        Map<String, String> idMap = new Map<String, String>();
        if(String.isNotBlank(searchObject) && !searchIds.isEmpty()) {
            if(searchObject == Label.Business_Unit) {
                for(Business_Unit__c bussinessUnit : [SELECT Id, HIS_ID__c FROM Business_Unit__c WHERE HIS_ID__c IN : searchIds]){
                    idMap.put(bussinessUnit.HIS_ID__c, bussinessUnit.Id);
                }                
            }
            else if(searchObject == Label.Account) {
                for(Account doctor : [SELECT Id, alletec_doctorid__c FROM Account WHERE RecordType.Name = 'Doctor' AND IsPersonAccount = true AND alletec_doctorid__c IN : searchIds]){
                    idMap.put(doctor.alletec_doctorid__c, doctor.Id);
                }
                List<Account> doctors = new List<Account>();                
                Id doctorRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Doctor').getRecordTypeId();
                for(String idName : recordNames){
                    String doctorId = idName.split('-').get(0);
                    String doctorName = idName.split('-').get(1);                    
                    if(!idMap.containsKey(doctorId)){
                        Account doctor = new Account();
                        doctor.LastName = doctorName;
                        doctor.alletec_doctorid__c = doctorId;
                        doctor.RecordTypeId = doctorRecordTypeId;
                        doctors.add(doctor);
                    }
                }
                
                if(!doctors.isEmpty()){
                    insert doctors;
                }                
                for(Account doctor : doctors){
                    idMap.put(doctor.alletec_doctorid__c, doctor.Id);
                }
            }
            else if(searchObject == Label.Department) {
                Set<Integer> searchIdInteger = new Set<Integer>();
                for(String searchId : searchIds){
                    searchIdInteger.add(Integer.valueOf(searchId));
                }
                for(Department__c department : [SELECT Id,alletec_id__c FROM Department__c WHERE alletec_id__c IN : searchIdInteger]){
                    idMap.put((department.alletec_id__c+''), department.Id);
                }
                
                List<Department__c> departments = new List<Department__c>();      
                for(String idName : recordNames){
                    String departmentId = idName.split('-').get(0);
                    String departmentName = idName.split('-').get(1);                    
                    if(!idMap.containsKey(departmentId)){
                        Department__c department = new Department__c();
                        department.Name = departmentName;
                        department.alletec_id__c = Integer.valueOf(departmentId);
                        departments.add(department);
                    }
                }
                
                if(!departments.isEmpty()){
                    insert departments;
                }                
                for(Department__c department : departments){
                    idMap.put((department.alletec_id__c+''), department.Id);
                }
            }
            else if(searchObject == Label.Specialization) {
                for(Speciality__c spec : [SELECT Id, HIS_ID__c FROM Speciality__c WHERE HIS_ID__c IN :searchIds]){
                    idMap.put((spec.HIS_ID__c), spec.Id);
                }     
                List<Speciality__c> specialities = new List<Speciality__c>();     
                
                for(String idName : recordNames){
                    String specId = idName.split('-').get(0);
                    String specName = idName.split('-').get(1);                    
                    if(!idMap.containsKey(specId)){
                        Speciality__c spec = new Speciality__c();
                        spec.Name = specName;
                        spec.HIS_ID__c = specId;
                        specialities.add(spec);
                    }
                }
                
                if(!specialities.isEmpty()){
                    insert specialities;
                }                
                for(Speciality__c spec : specialities){
                    idMap.put((spec.HIS_ID__c), spec.Id);
                }
            }
            else if(searchObject == Label.Patient) {
                for(Account patient : [SELECT Id, Max_ID__c FROM Account WHERE RecordType.Name = 'Patient' AND IsPersonAccount = true AND Max_ID__c IN :searchIds]){
                    idMap.put(patient.Max_ID__c, patient.Id);
                }
                List<Account> patients = new List<Account>();
                Id patientRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId();
                for(String idName : recordNames){
                    String patientId = idName.split('-').get(0);
                    String patientName = idName.split('-').get(1);                    
                    if(!idMap.containsKey(patientId)){
                        Account patient = new Account();
                        patient.LastName = patientName;
                        patient.Max_ID__c = patientId;
                        patient.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId();
                        patients.add(patient);
                    }
                }
                if(!patients.isEmpty()){
                    insert patients;
                }                
                for(Account patient : patients){
                    idMap.put(patient.Max_ID__c, patient.Id);
                }
            }
            else if(searchObject == Label.Lead) {
                
            }
            else if(searchObject == 'Gender') {
                Map<String, Gender__c> genders = new Map<String, Gender__c>();
                genders = Gender__c.getAll();             
                Map<String,String> genderMap = new Map<String,String>();
                for (String gn : genders.keySet()) {
                    Gender__c bg = genders.get(gn);
                    genderMap.put(bg.HIS_ID__c, bg.Name);
                }                
            }
            else if(searchObject == 'MaritalStatus') {
                Map<String, Marital_Status__c> maritals = new Map<String, Marital_Status__c>();
                maritals = Marital_Status__c.getAll();
                List<String> maritalStatuses = new List<String>();
                Map<String,String> maritalStatusMap = new Map<String,String>();
                for (String mat : maritals.keySet()) {
                    Marital_Status__c mats = maritals.get(mat);
                    maritalStatusMap.put(mats.HIS_ID__c, mats.Name);
                }                 
            }
            else if(searchObject == 'BloodGroup') {
                Map<String, Blood_Group__c> bloodGroups = new Map<String, Blood_Group__c>();
                bloodGroups = Blood_Group__c.getAll();
                Map<String,String> bloodGroupMap = new map<String,String>();
                for (String bgname : bloodGroups.keySet()) {
                    Blood_Group__c bg = bloodGroups.get(bgname);
                    bloodGroupMap.put(bg.HIS_ID__c, bg.Name);
                }
            }
            else if(searchObject == 'City') {
                for(Address_Master__c city : [SELECT Id, alletec_cityid__c FROM Address_Master__c WHERE Recordtype.Name = 'City'AND alletec_cityid__c IN :searchIds]){
                    idMap.put(city.alletec_cityid__c, city.Id);
                } 
            }
            else if(searchObject == 'Country') {
                for(Address_Master__c country : [SELECT Id, alletec_countryid__c FROM Address_Master__c WHERE Recordtype.Name='Country' AND alletec_countryid__c IN :searchIds]){
                    idMap.put(country.alletec_countryid__c, country.Id);
                } 
            }
            else if(searchObject == 'Locality') {
                for(Address_Master__c locality : [SELECT Id, alletec_localityid__c FROM Address_Master__c WHERE Recordtype.Name='Locality'AND alletec_localityid__c IN :searchIds]){
                    idMap.put(locality.alletec_localityid__c, locality.Id);
                } 
            }
            else if(searchObject == 'Pincode') {
                for(Address_Master__c pincode : [SELECT Id, alletec_pincode__c FROM Address_Master__c WHERE Recordtype.Name='Pin_Code'AND alletec_pincode__c IN :searchIds]){
                    idMap.put(pincode.alletec_pincode__c, pincode.Id);
                } 
            }
            else if(searchObject == 'State') {
                for(Address_Master__c state : [SELECT Id, alletec_state__c FROM Address_Master__c WHERE Recordtype.Name='State'AND alletec_state__c IN :searchIds]){
                    idMap.put(state.alletec_state__c, state.Id);
                } 
            }
            else if(searchObject == Label.Prospect) {
                for(Prospect__c prospect : [SELECT Id, Max_Id__c FROM Prospect__c WHERE Max_Id__c IN : searchIds AND Source__c IN ('E Prescription','ACD Page','Estimation') AND Stage__c NOT IN ('Patient Discharged','Closed Lost')]){
                    idMap.put(prospect.Max_Id__c, prospect.Id);
                } 
            }
            else if(searchObject == Label.ProspectEstimation) {
                for(Prospect__c prospect : [SELECT Id, Max_Id__c FROM Prospect__c WHERE Max_Id__c IN :searchIds AND Source__c IN ('Estimation','ACD Page','E Prescription') AND Stage__c NOT IN ('Patient Discharged','Closed Lost')]){
                    idMap.put(prospect.Max_Id__c, prospect.Id);
                } 
            }
            /*else if(searchObject == Label.DCALeads) {                
            }*/
        }
        return idMap;
    }
    
    
    public static String checkRecord(String searchId,String recordName,String searchObject) {
        if(String.isNotBlank(searchObject)) {
            if(searchObject == Label.Business_Unit) {
                List<Business_Unit__c> listBusinessUnit = [SELECT Id FROM Business_Unit__c WHERE HIS_ID__c = :searchId];
                system.debug('listBusinessUnit-->'+listBusinessUnit);
                if(listBusinessUnit != NULL && listBusinessUnit.size() > 0)
                    return listBusinessUnit[0].Id;
                else 
                    return NULL;
            }
            else if(searchObject == Label.Account) {
                List<Account> listDoctor = [SELECT Id FROM Account 
                                            WHERE RecordType.Name = 'Doctor' 
                                            AND IsPersonAccount = true 
                                            AND alletec_doctorid__c = :searchId];  
                
                if(listDoctor != NULL && listDoctor.size() > 0)
                    return listDoctor[0].Id;
                else {
                    Account acc = new Account();
                    acc.LastName = recordName;
                    acc.alletec_doctorid__c = searchId;
                    acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Doctor').getRecordTypeId();
                    insert acc;
                    return acc.Id;
                }
            }
            else if(searchObject == Label.Department) {
                
                List<Department__c> listDepartment = [SELECT Id FROM Department__c WHERE alletec_id__c = :Integer.valueOf(searchId)];
                if(listDepartment != NULL && listDepartment.size() > 0)
                    return listDepartment[0].Id;
                else {
                    Department__c department = new Department__c();
                    department.Name = recordName;
                    department.alletec_id__c = Integer.valueOf(searchId);
                    insert department;
                    return department.Id;
                }
            }
            else if(searchObject == Label.Specialization) {
                List<Speciality__c> listSpec = [SELECT Id FROM Speciality__c WHERE HIS_ID__c = :searchId];
                if(listSpec != NULL && listSpec.size() > 0)
                    return listSpec[0].Id;
                else {
                    Speciality__c spec = new Speciality__c();
                    spec.Name = recordName;
                    spec.HIS_ID__c = searchId;
                    insert spec;
                    return spec.Id;
                }
            }
            else if(searchObject == Label.Patient) {
                List<Account> listPatient = [SELECT Id FROM Account WHERE RecordType.Name = 'Patient' AND IsPersonAccount = true AND Max_ID__c = :searchId];
                if(listPatient != NULL && listPatient.size() > 0)
                    return listPatient[0].Id;
                else {
                    Account acc = new Account();
                    acc.LastName = recordName;
                    acc.Max_ID__c = searchId;
                    acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId();
                    insert acc;
                    return acc.Id;   
                }
            }
            else if(searchObject == Label.Lead) {
                List<Lead__c> listLead = [SELECT Id FROM Lead__c WHERE RecordType.Name = 'CMP' AND Max_ID__c = :searchId AND Stage__c != 'OPD Consult Taken'];
                String leadIds = '';
                if(listLead != NULL && listLead.size() > 0)
                    for(Lead__c l : listLead)
                    leadIds += l.Id + ',';
                
                if(String.isNotBlank(leadIds))
                    leadIds.removeEnd(',');
                
                return leadIds;
            }
            else if(searchObject == 'Gender') {
                Map<String, Gender__c> genders = Gender__c.getAll();
                List<String> genderNames = new List<String>();
                genderNames.addAll(genders.keySet());
                Map<String,String> genderMap = new Map<String,String>();
                for (String gn : genderNames) {
                    Gender__c bg = genders.get(gn);
                    genderMap.put(bg.HIS_ID__c,bg.Name);
                }
                if(genderMap.containsKey(searchId))
                    return genderMap.get(searchId);
            }
            else if(searchObject == 'MaritalStatus') {
                Map<String, Marital_Status__c > maritals = Marital_Status__c.getAll();
                List<String> maritalStatuses = new List<String>();
                maritalStatuses.addAll(maritals.keySet());
                Map<String,String> maritalStatusMap = new Map<String,String>();
                for (String mat : maritalStatuses) {
                    Marital_Status__c mats = maritals.get(mat);
                    maritalStatusMap.put(mats.HIS_ID__c,mats.Name);
                } 
                if(maritalStatusMap.containsKey(searchId))
                    return maritalStatusMap.get(searchId);
            }
            else if(searchObject == 'BloodGroup') {
                Map<String, Blood_Group__c> broups = Blood_Group__c.getAll();
                List<String> bgroupsNames = new List<String>();
                bgroupsNames.addAll(broups.keySet());
                Map<String,String> bloodGroupMap = new map<String,String>();
                for (String bgname : bgroupsNames) {
                    Blood_Group__c bg = broups.get(bgname);
                    bloodGroupMap.put(bg.HIS_ID__c,bg.Name);
                }
                if(bloodGroupMap.containsKey(searchId))
                    return bloodGroupMap.get(searchId);
            }
            else if(searchObject == 'City') {
                List<Address_Master__c> listAddressMaster = [SELECT Id FROM Address_Master__c WHERE Recordtype.Name='City'AND alletec_cityid__c =:searchId];
                if(listAddressMaster != NULL && listAddressMaster.size() > 0)
                    return listAddressMaster[0].Id;
            }
            else if(searchObject == 'Country') {
                List<Address_Master__c> listAddressMaster = [SELECT Id FROM Address_Master__c WHERE Recordtype.Name='Country' AND alletec_countryid__c =:searchId];
                if(listAddressMaster != NULL && listAddressMaster.size() > 0)
                    return listAddressMaster[0].Id;
            }
            else if(searchObject == 'Locality') {
                List<Address_Master__c> listAddressMaster = [SELECT Id FROM Address_Master__c WHERE Recordtype.Name='Locality'AND alletec_localityid__c =:searchId];
                if(listAddressMaster != NULL && listAddressMaster.size() > 0)
                    return listAddressMaster[0].Id;
            }
            else if(searchObject == 'Pincode') {
                List<Address_Master__c> listAddressMaster = [SELECT Id FROM Address_Master__c WHERE Recordtype.Name='Pin_Code'AND alletec_pincode__c =:searchId];
                if(listAddressMaster != NULL && listAddressMaster.size() > 0)
                    return listAddressMaster[0].Id;
            }
            else if(searchObject == 'State') {
                List<Address_Master__c> listAddressMaster = [SELECT Id FROM Address_Master__c WHERE Recordtype.Name='State'AND alletec_state__c =:searchId];
                if(listAddressMaster != NULL && listAddressMaster.size() > 0)
                    return listAddressMaster[0].Id;
            }
            
            else if(searchObject == Label.Prospect) {
                List<Prospect__c> listProspect = [SELECT Id FROM Prospect__c WHERE Max_Id__c = :searchId AND Source__c IN ('E Prescription','ACD Page','Estimation') AND Stage__c NOT IN ('Patient Discharged','Closed Lost')]; 
                if(listProspect != NULL && listProspect.size() > 0)
                    return listProspect[0].Id;
            }
            else if(searchObject == Label.ProspectEstimation) {
                List<Prospect__c> listProspect = [SELECT Id FROM Prospect__c WHERE Max_Id__c = :searchId AND Source__c IN ('Estimation','ACD Page','E Prescription') AND Stage__c NOT IN ('Patient Discharged','Closed Lost')]; 
                if(listProspect != NULL && listProspect.size() > 0)
                    return listProspect[0].Id;
            }else if(searchObject == Label.DCALeads) {
                //changed by uzair first filter on the basis of max id and if it is blank then search on the basis of name and phone
                String query = 'SELECT Id FROM Lead__c WHERE RecordType.Name = \'Digital Customer Acquisition\' AND ';
                if(recordName=='')
                    query+='Max_ID__c = :searchId';
                else
                    query+='Name LIKE \'%'+searchId+'%\' AND Mobile_Phone__c = :recordName';
                String leadIds='';
                
                for(Lead__c lead : Database.query(query)) 
                    leadIds += lead.Id + ',';
                
                if(String.isNotBlank(leadIds))
                    leadIds = leadIds.removeEnd(',');
                return leadIds;
                
            }
        }
        return NULL;
    }
    
}