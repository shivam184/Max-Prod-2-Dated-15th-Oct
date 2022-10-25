public class PreIntimationTaggingApex {
    
    @auraEnabled
    public static WrapperClass fetchDataApex(String selectedUserId,String patientNameLead,String mecpAccountName) {
        integer old30Dates=0,old90Dates=0;
        try{old90Dates = Integer.valueOf(Label.Ninety);}catch(exception e){}
        try{old30Dates = Integer.valueOf(Label.Thirty);}catch(exception e){}
        try {
            WrapperClass wrpCls = new WrapperClass();
            List<Lead__c> listLeadOfMecpType;
            
            List<string>  departmentList = Label.Preintimation_Visibility_For_90_Days!=NULL?Label.Preintimation_Visibility_For_90_Days.split(','):new List<string>();
            
            Date currentDate = system.today();
            
            date date90DaysAgo = currentDate.addDays(-old90Dates);
            date date30DaysAgo = currentDate.addDays(-old30Dates);
            
            String query = 'SELECT Id,Is_Document_Uploaded__c,Name,Owner.Name,Intimation_Date_Time__c,CreatedDate,Doctor__c,Doctor__r.Name,MECP_Source__c,MECP_Name__c,MECP_Name__r.Name,Ailment__c';
            query += ' FROM Lead__c WHERE RecordType.Name = \'MECP\' AND Pre_Intimation_Status__c = NULL';
            query +=  ' AND ((Treating_Doctor__r.SF_Speciality__r.alletec_department__r.name IN :departmentList AND Intimation_Date_Time__c >= :date90DaysAgo) OR Intimation_Date_Time__c >= :date30DaysAgo)';
            
            if(String.isNotBlank(selectedUserId))
                query += ' AND OwnerId = :selectedUserId';
            
            if(String.isNotBlank(patientNameLead))
                query += ' AND NAME LIKE \'%'+patientNameLead+'%\'';
            
            if(String.isNotBlank(mecpAccountName)) 
                query += ' AND (MECP_Name__r.Name LIKE \'%'+mecpAccountName+'%\' OR MECP_Source__c LIKE \'%'+mecpAccountName+'%\')';    
            
            
            query += ' ORDER BY Intimation_Date_Time__c DESC LIMIT 100';            
            
            listLeadOfMecpType =  Database.query(query);            
            if(listLeadOfMecpType != NULL && listLeadOfMecpType.size() > 0) {
                wrpCls.status = 'SUCCESS';
                wrpCls.listLeadOfMecpType = listLeadOfMecpType;
                return wrpCls;
            }
            else {
                wrpCls.status = 'No Pre-Intimation Found';
                return wrpCls;          
            }
        }   
        catch(Exception e) {
            WrapperClass wrpCls = new WrapperClass();
            wrpCls.status = e.getMessage();
            return wrpCls;
        }
    }
    
    @auraEnabled 
    public static WrapperClass doSearchApex(String maxId,String patientName,String treatingDoctorName,String selectedMECPId,Boolean tagged) {
        try {
            WrapperClass wrpCls = new WrapperClass();
            Integer noOfDays = Integer.valueOf(Label.NumberOfDays);
            List<Admission_Acknowledgement__c> listAdmission;
            List<String> channelList = new List<String>{'Walk-In','TPA','Cash'};
                String query = 'SELECT Id,Max_ID__c,OPID__c,IPID__c,Patient_Name__c,Coupon_Code__c,Date_Time_of_Admission__c,MECP_Source__c,MECP_Source__r.Name,Last_OPD_Speciality__r.Name,Doctor_Name__c,Last_OPD_Speciality__c,alletec_speciality__c,alletec_speciality__r.Name FROM Admission_Acknowledgement__c WHERE RecordType.Name = \'Domestic\' AND (((No_Of_Days_From_Discharge__c <= :noOfDays OR No_Of_Days_From_Discharge__c = NULL) AND Pre_Intimation_Status__c';
            Integer count = 0;
            if(tagged) {
                query += ' != NULL))';
                count = 1;
            }
            else
                query += ' = NULL AND Channel_Name__c IN :channelList) OR (Tagging_Availability__c = true))';
            
            if(maxId != NULL && maxId != '') {
                query += ' AND Max_ID__c = :maxId';
                count = 1;
            }
            
            if(patientName != NULL && patientName != '') {
                query += ' AND Patient_Name__c LIKE \'%'+patientName+'%\''; 
                count = 1;
            }
            
            if(treatingDoctorName != NULL && treatingDoctorName != '') {
                query += ' AND Doctor_Name__c LIKE \'%'+treatingDoctorName+'%\'';
                count = 1; 
            }
            
            //------Added On 25 Feb 2018------------------------------
            if(String.isNotBlank(selectedMECPId)) {
                query += ' AND MECP_Source__c = :selectedMECPId';
                count = 1;
            }
            //--------------------------------------------------------
            if(count == 1)
                listAdmission = Database.query(query);  
            
            if(listAdmission != NULL && listAdmission.size() > 0) {
                wrpCls.status = 'SUCCESS';
                wrpCls.listAdmission = listAdmission;
                return wrpCls;      
            }
            else {
                if(count == 1)
                    wrpCls.status = 'No Admission Acknowledgement Found';
                else
                    wrpCls.status = 'Apply filter to find Admission Acknowledgement';
                return wrpCls;    
            }
        }
        catch(Exception e) {
            WrapperClass wrpCls = new WrapperClass();
            wrpCls.status = e.getMessage();
            return wrpCls;    
        }
    }
    
    @auraEnabled 
    public static String tagWithPreIntimationApex(String selectedLeadId,String selectedAdmissionId,String selectedMecpSource ) {
        Savepoint sp = Database.setSavepoint();
        try {
            Boolean checkPre =  false;
            List<Admission_Acknowledgement__c> listAdmission = [SELECT Coupon_Code__c,Date_Time_of_Admission__c,Is_Emergency__c,Channel_Name__c,MECP_Status__c,
                                                                Previous_Channel_Name__c,Referrer_Account__c,Referrer_Account__r.Type,Tagged_Pre_Intimation__c,
                                                                MECP__c,Pre__c,Mecp_Source__c,Is_Tagged_By_Referral__c,Referrer_Channel__c,
                                                                Pre_Intimation_Status__c FROM Admission_Acknowledgement__c
                                                                WHERE Id = :selectedAdmissionId];
            
            if(listAdmission != NULL && listAdmission.size() > 0) {
                
                List<Lead__c> listLead = [SELECT Id,Pre_Intimation_Status__c,Lead_Channel__c,Intimation_Date_Time__c,CreatedDate,Dr_Intimation_Date_Time__c FROM Lead__c WHERE Id = :selectedLeadId]; 
                if(listLead != NULL && listLead.size() > 0) {
                    Integer count = 0;
                    if(!String.isBlank(listAdmission[0].Coupon_Code__c)) {
                        listAdmission[0].Pre_Intimation_Status__c = 'Pre';
                        listLead[0].Pre_Intimation_Status__c = 'Pre';
                        listAdmission[0].MECP__c = 'MECP Coupons';
                        listAdmission[0].Pre__c = true;
                        count = 1;
                        checkPre = true;
                    }
                    
                    if(!checkPre) {
                        if(String.isNotBlank(selectedMecpSource)) {
                            List<Account> listAccount = [SELECT Type FROM Account WHERE Id = :selectedMecpSource];
                            if(listAccount != NULL && listAccount.size() > 0) {
                                if(String.isNotBlank(listAccount[0].Type)) {
                                    if(listAccount[0].Type == 'MACN' || listAccount[0].Type == 'Pehel'){
                                        listAdmission[0].Pre_Intimation_Status__c = 'Pre';
                                        listLead[0].Pre_Intimation_Status__c = 'Pre';
                                        if(listAccount[0].Type == 'MACN')
                                            listAdmission[0].MECP__c = 'MACN';
                                        else
                                            listAdmission[0].MECP__c = 'Pehel';
                                        listAdmission[0].Pre__c = true;
                                        count = 1;
                                        checkPre = true;
                                    }
                                }
                            }
                        }    
                    }
                    
                    if(count==0) {
                        if(listAdmission[0].Date_Time_of_Admission__c != NULL)  {
                            Long dt1Long = listLead[0].Intimation_Date_Time__c.getTime();
                            Long dt2Long = listAdmission[0].Date_Time_of_Admission__c.getTime();
                            Long milliseconds = dt2Long - dt1Long;
                            Long seconds = milliseconds / 1000;
                            Long minutes = seconds / 60;
                            Long hours = minutes / 60;
                            Long days = hours / 24; 
                            
                            if(listAdmission[0].Is_Emergency__c) {
                                if(minutes >= Integer.valueOf(Label.minutesOfEmergencyEPrescription)) {
                                    listAdmission[0].Pre_Intimation_Status__c = 'Pre';
                                    listLead[0].Pre_Intimation_Status__c = 'Pre';
                                    listAdmission[0].MECP__c = 'Pre-Intimations ER';
                                    listAdmission[0].Pre__c = true;
                                    count = 1;   
                                    checkPre = true;
                                }
                                else {
                                    listAdmission[0].Pre_Intimation_Status__c = 'Post';
                                    listLead[0].Pre_Intimation_Status__c = 'Post';
                                    listAdmission[0].MECP__c = 'Pre-Intimations ER';
                                    count = 1;
                                }
                            }
                            else{
                                if(hours >= Integer.valueOf(Label.NumberOfHoursForDoctorPrescription)) {
                                    listAdmission[0].Pre_Intimation_Status__c = 'Pre';
                                    listLead[0].Pre_Intimation_Status__c = 'Pre';
                                    listAdmission[0].MECP__c = 'Pre-Intimations';
                                    listAdmission[0].Pre__c = true;
                                    count = 1;
                                    checkPre = true;
                                }
                                else {
                                    listAdmission[0].Pre_Intimation_Status__c = 'Post';
                                    listLead[0].Pre_Intimation_Status__c = 'Post';  
                                    listAdmission[0].MECP__c = 'Pre-Intimations';
                                    count = 1;
                                }
                            }
                        }
                        
                        if(!checkPre) {
                            Set<Id> setContentDocumentId = new Set<Id>();
                            for(ContentDocumentLink cdl : [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :selectedLeadId])
                                setContentDocumentId.add(cdl.ContentDocumentId);
                            if(setContentDocumentId != NULL && setContentDocumentId.size() > 0) {
                                List<ContentVersion> listContentVersion = [SELECT CreatedDate,File_Type__c FROM ContentVersion WHERE ContentDocumentId IN :setContentDocumentId AND File_Type__c = 'E-Prescription'];
                                if(listContentVersion != NULL && listContentVersion.size() > 0) {
                                    if(listAdmission[0].Date_Time_of_Admission__c != NULL) {
                                        Long dt1Long = listAdmission[0].Date_Time_of_Admission__c.getTime();
                                        Long dt2Long = listContentVersion[0].CreatedDate.getTime();
                                        Long milliseconds = dt2Long - dt1Long;
                                        Long seconds = milliseconds / 1000;
                                        Long minutes = seconds / 60;
                                        Long hours = minutes / 60;
                                        Long days = hours / 24;  
                                        
                                        if(hours <= Integer.valueOf(Label.HoursOfEPrescription)) {
                                            listAdmission[0].Pre_Intimation_Status__c = 'Pre';
                                            listLead[0].Pre_Intimation_Status__c = 'Pre';
                                            listAdmission[0].MECP__c = 'Prescriptions';
                                            listAdmission[0].Pre__c = true;
                                            count = 1;   
                                            checkPre = true;
                                        }
                                        else {
                                            listAdmission[0].Pre_Intimation_Status__c = 'Post';
                                            listLead[0].Pre_Intimation_Status__c = 'Post';
                                            listAdmission[0].MECP__c = 'Prescriptions';
                                            count = 1;
                                        }       
                                        
                                    }       
                                }
                                
                                if(!checkPre) {
                                    List<ContentVersion> listContentVersion1 = [SELECT CreatedDate,File_Type__c FROM ContentVersion WHERE ContentDocumentId IN :setContentDocumentId AND File_Type__c = 'Screenshot'];
                                    if(listContentVersion1 != NULL && listContentVersion1.size() > 0) {
                                        if(listLead[0].Dr_Intimation_Date_Time__c != NULL) {
                                            Integer hour1 = listLead[0].Dr_Intimation_Date_Time__c.hour();
                                            Date date1 = listLead[0].Dr_Intimation_Date_Time__c.date();
                                            Integer hour2 = listContentVersion1[0].CreatedDate.hour();
                                            Date date2 = listContentVersion1[0].CreatedDate.date();
                                            
                                            if(date1 == date2 && hour1 >= Integer.valueOf(Label.TwentyThree) && hour2 >= Integer.valueOf(Label.TwentyThree)) {
                                                listAdmission[0].Pre_Intimation_Status__c = 'Pre';
                                                listLead[0].Pre_Intimation_Status__c = 'Pre';
                                                listAdmission[0].MECP__c = 'Pre-Intimations';
                                                listAdmission[0].Pre__c = true;
                                                count = 1;    
                                            }
                                            
                                            if(date1 == date2 && hour1 <= Integer.valueOf(Label.Six) && hour2 <= Integer.valueOf(Label.Eight)) {
                                                listAdmission[0].Pre_Intimation_Status__c = 'Pre';
                                                listLead[0].Pre_Intimation_Status__c = 'Pre';
                                                listAdmission[0].MECP__c = 'Pre-Intimations';
                                                listAdmission[0].Pre__c = true;
                                                count = 1;    
                                            }
                                            
                                            if(date1.daysBetween(date2) == 1 && (hour1 >= Integer.valueOf(Label.TwentyThree) || hour1 <= Integer.valueOf(Label.Six)) && hour2 <= Integer.valueOf(Label.Eight)) {
                                                listAdmission[0].Pre_Intimation_Status__c = 'Pre';
                                                listLead[0].Pre_Intimation_Status__c = 'Pre';
                                                listAdmission[0].MECP__c = 'Pre-Intimations';
                                                listAdmission[0].Pre__c = true;
                                                count = 1;     
                                            }
                                        }
                                    }    
                                }
                                
                            }
                        }
                    }
                    
                    listLead[0].Lead_Channel__c = 'MECP';
                    listAdmission[0].Tagged_Pre_Intimation__c = selectedLeadId;
                    listAdmission[0].Mecp_Source__c = selectedMecpSource;
                    listAdmission[0].Previous_Channel_Name__c = listAdmission[0].Channel_Name__c;
                    listAdmission[0].Channel_Name__c = 'MECP';
                    listAdmission[0].MECP_Status__c = 'MECP';
                    listAdmission[0].Is_Tagged_By_Referral__c = true;
                    listAdmission[0].Referrer_Channel__c = 'MECP';
                    if(count == 0) {
                        listAdmission[0].Pre_Intimation_Status__c = 'Post';
                        listLead[0].Pre_Intimation_Status__c = 'Post';  
                        listAdmission[0].MECP__c = 'Pre-Intimations';
                    }
                    
                    update listLead[0];
                    update listAdmission[0];
                    return 'SUCCESS';
                }
                else {
                    return 'No Lead Found';    
                }    
                
            }
            else {
                return 'No Admission Acknowledgement Found';    
            }
        }
        catch(Exception e) {
           Database.rollback(sp);
           return e.getMessage();
        }
    }
    
    @AuraEnabled
    public static String tagWithoutPreIntimationApex(String selectedLead,String selectedAdmissionId, String remark,Boolean couponCode) {
        Savepoint sp = Database.setSavepoint();
        try {
            List<Admission_Acknowledgement__c> listAdmission = [SELECT Id,MECP_Source__c,Tagged_Pre_Intimation__c,Remarks__c,
                                                                Pre_Intimation_Status__c,Channel_Name__c,MECP_Status__c,Pre__c,
                                                                Is_Tagged_By_Referral__c,MECP__c
                                                                FROM Admission_Acknowledgement__c
                                                                WHERE Id = :selectedAdmissionId];   
            if(listAdmission != NULL && listAdmission.size() > 0) {
                
                listAdmission[0].Mecp_Source__c = selectedLead;
                listAdmission[0].Remarks__c = remark;
                listAdmission[0].Pre_Intimation_Status__c = 'Pre';
                listAdmission[0].Channel_Name__c = 'MECP';
                listAdmission[0].MECP_Status__c = 'MECP';
                listAdmission[0].Pre__c = true;
                listAdmission[0].Is_Tagged_By_Referral__c = true;
                if(couponCode)
                    listAdmission[0].MECP__c = 'MECP Coupons';
                else {
                    if(String.isNotBlank(selectedLead)) {
                        List<Account> listAccount = [SELECT Type FROM Account WHERE Id = :selectedLead];
                        System.debug('listAccount-->'+listAccount);
                        if(listAccount != NULL && listAccount.size() > 0) {
                            if(String.isNotBlank(listAccount[0].Type)) {
                                if(listAccount[0].Type == 'MACN')
                                    listAdmission[0].MECP__c = 'MACN';                                    
                                else if(listAccount[0].Type == 'Pehel')
                                    listAdmission[0].MECP__c = 'Pehel';
                            }
                        }
                    }    
                }
                update listAdmission[0];
                
                return 'SUCCESS';
            }
            else {
                return 'No Admission Acknowledgement found';
            }
        }
        catch(Exception e) {
            Database.rollback(sp);
            return e.getMessage();   
        }
    }
    
    @auraEnabled
    public static String untag(String selectedLead,String selectedAdmissionId,String reason) {
        Savepoint sp = Database.setSavepoint();
        try {
            List<Admission_Acknowledgement__c> listAdmission = [SELECT Id,Previous_Channel_Name__c,Channel_Name__c,MECP_Source__c,Tagged_Pre_Intimation__c,Remarks__c,
                                                                Pre_Intimation_Status__c FROM Admission_Acknowledgement__c
                                                                WHERE Id = :selectedAdmissionId];   
            if(listAdmission != NULL && listAdmission.size() > 0) {
                
                listAdmission[0].Mecp_Source__c = selectedLead;
                listAdmission[0].Remarks__c = reason;
                listAdmission[0].Channel_Name__c = listAdmission[0].Previous_Channel_Name__c;
                update listAdmission[0];
                
                return 'SUCCESS';
            }
            else {
                return 'No Admission Acknowledgement found';
            }
        }
        catch(Exception e) {
            Database.rollback(sp);
            return e.getMessage();   
        }
    }
    
    @AuraEnabled
    public static String checkAccountType(String selAdmId){
        String actType ='NO';
        list<Admission_Acknowledgement__c> ack = new list<Admission_Acknowledgement__c>([SELECT Id,Coupon_Code__c, Referrer_Account__c,Referrer_Account__r.Type
                                                                                         FROM Admission_Acknowledgement__c WHERE 
                                                                                         Id=:selAdmId]);
        if(ack!=null && ack.size()>0){
            if(String.isNotBlank(ack[0].Coupon_Code__c))
                actType = 'YES';
        }
        return actType;
    }
    
    
    
    @auraEnabled
    public static WrapperClass doGetMecpDoctor(String mecpName) {
        WrapperClass wrpCls = new WrapperClass();
        try {
            if(String.isNotBlank(mecpName)) {
                String query = 'SELECT Id,Name,Owner.Name,Account_Territory__c,Account_Territory__r.Name,AccountNumber,Type,Phone FROM Account WHERE RecordType.Name = \'MECP Doctor Business\' AND Name LIKE \'%' + mecpName+ '%\'';
                wrpCls.listAccount = Database.query(query);
                wrpCls.status = 'SUCCESS';
                return wrpCls;
            }
            else {
                wrpCls.status = 'Please fill MECP Name';
                return wrpCls;
            }
        }
        catch(Exception e) {
            wrpCls.status = e.getMessage();
            return wrpCls;    
        }
    }
    
    @AuraEnabled
    public static String retaggingApex(String selectedAdmissionId,String selectedMecpSource) {
        try {
            if(String.isNotBlank(selectedAdmissionId) && String.isNotBlank(selectedMecpSource)) {
                Admission_Acknowledgement__c adm = new Admission_Acknowledgement__c();
                adm.Id = selectedAdmissionId;
                adm.MECP_Source__c = selectedMecpSource;
                adm.Re_Tagged__c = true;
                update adm;
                
                return 'SUCCESS';
            }   
            
            return 'Please Select Admission Acknowledgement And MECP Source';
        }   
        catch(Exception e) {
            return e.getMessage();
        }
    }
    
    @AuraEnabled
    public static String getMECPType(String selectedMecpSource) {
        if(String.isNotBlank(selectedMecpSource)) {
            List<Account> listAccount = [SELECT Type FROM Account WHERE Id = :selectedMecpSource];
            if(listAccount != NULL && listAccount.size() > 0) {
                if(String.isNotBlank(listAccount[0].Type)) {
                    if(listAccount[0].Type == 'MACN' || listAccount[0].Type == 'Pehel')
                        return 'YES';
                    else
                        return 'NO';
                }	
                return 'NO';
            }
            return 'NO';
        }
        return 'NO';
    }
    
    public class WrapperClass {
        @auraEnabled
        public String status;
        @auraEnabled
        public List<Lead__c> listLeadOfMecpType;
        @auraEnabled
        public List<Admission_Acknowledgement__c> listAdmission;
        @auraEnabled
        public List<Account> listAccount;
        public WrapperClass() {
            status = '';
            listLeadOfMecpType = new List<Lead__c>();
            listAdmission = new List<Admission_Acknowledgement__c>();
            listAccount = new List<Account>();
        }
    }
}