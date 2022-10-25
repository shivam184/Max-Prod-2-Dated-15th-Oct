public class DoctorCoordinatorTriggerHelper {
    
    public static void beforeInsert(List<Doctor_Coordinator_Master__c> triggerNew) {
        
        Set<Id> setDoctorId = new Set<Id>();      
        Set<Id> setSpecializationId = new Set<Id>();
        Set<Id> setBusinessId = new Set<Id>();
        Set<String> setChannel = new Set<String>();
        Set<String> setDuplicateCheck = new Set<String>();
        Set<String> setDuplicateCoordinatorCheck = new Set<String>();
        
        for(Doctor_Coordinator_Master__c dcm : triggerNew) {
            if(dcm.Doctor__c != NULL)
                setDoctorId.add(dcm.Doctor__c);            
            if(dcm.Specialization__c != NULL)
                setSpecializationId.add(dcm.Specialization__c);
            if(dcm.Business_Unit__c != NULL)
                setBusinessId.add(dcm.Business_Unit__c);
            if(dcm.Channel__c != NULL)
                setChannel.add(dcm.Channel__c);     
        }                
        
        if(setDoctorId.size() > 0 && setSpecializationId.size() > 0 && setBusinessId.size() > 0 && setChannel.size() > 0) {
            for(Doctor_Coordinator_Master__c dcm : [SELECT Doctor__c,Co_ordinator__c,Specialization__c,Business_Unit__c,Channel__c 
                                                    FROM Doctor_Coordinator_Master__c 
                                                    WHERE Doctor__c IN : setDoctorId 
                                                   	AND Specialization__c IN :setSpecializationId 
                                                    AND Business_Unit__c IN :setBusinessId 
                                                    AND Channel__c IN :setChannel 
                                                    AND Id NOT IN :triggerNew]) {
                                                        
                                                        String key1 = dcm.Doctor__c + '*' + dcm.Co_ordinator__c + '*' + dcm.Specialization__c + '*' + dcm.Business_Unit__c + '*' + dcm.Channel__c;
                                                        String key2 = dcm.Doctor__c + '*' + dcm.Specialization__c + '*' + dcm.Business_Unit__c + '*' + dcm.Channel__c;
                                                        
                                                        setDuplicateCheck.add(key1);
                                                        setDuplicateCoordinatorCheck.add(key2);
                                                        
                                                    }
        }
        
        for(Doctor_Coordinator_Master__c dcm : triggerNew) {
            if(dcm.Doctor__c != NULL && dcm.Co_ordinator__c != NULL && dcm.Specialization__c != NULL && dcm.Business_Unit__c != NULL && dcm.Channel__c != NULL) {
                String key1 = dcm.Doctor__c + '*' + dcm.Co_ordinator__c + '*' + dcm.Specialization__c + '*' + dcm.Business_Unit__c + '*' + dcm.Channel__c;
                String key2 = dcm.Doctor__c + '*' + dcm.Specialization__c + '*' + dcm.Business_Unit__c + '*' + dcm.Channel__c; 
                                
                if(setDuplicateCheck.contains(key1))
                    dcm.addError('Duplicate Record: A record with these details already exists.');
                else if(setDuplicateCoordinatorCheck.contains(key2))
                     dcm.addError('Doctor Cordinator Master with same details exists. You can change coordinator from that record.');
            }    
        }
    }
}