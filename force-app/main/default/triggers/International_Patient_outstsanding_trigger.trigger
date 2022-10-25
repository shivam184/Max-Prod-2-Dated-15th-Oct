//Description: Apex Trigger to populate values of HCF Source, Specialty, Markup Type, 
//                and Estimate Amount on International Patient Outsatnding fields
//Created By: Techmatrix Consulting


trigger International_Patient_outstsanding_trigger on Internationalpatient_Outstanding__c (before insert,before update) {
    
    Map<String,Admission_Acknowledgement__c> admissionMap = new Map<String,Admission_Acknowledgement__c>();
    Map<string ,boolean> billmap = new map <string,boolean>();
    Id intlRecordTypeId = Schema.SObjectType.Admission_Acknowledgement__c.getRecordTypeInfosByName().get('International').getRecordTypeId();

    Set<String> ipIdSet = new Set<String>();
    Set<Id> locationSet = new Set<Id>();
    Set<String> maxIdSet = new Set<String>();

    
    
    for(Internationalpatient_Outstanding__c io : trigger.new){
        if(io.alletec_ipid__c != null && io.alletec_location__c != null){
            ipIdSet.add(String.valueOf(io.alletec_ipid__c));
            locationSet.add(io.alletec_location__c);
            maxIdSet.add(io.alletec_maxid__c);
            
            //custom key creation using map 
            admissionMap.put(String.valueOf(io.alletec_ipid__c)+'@@'+io.alletec_location__c,null);
            
            //system.debug('mapppp valuee 1  >>>>>>'+admissionMap);
        }
    }
    
    if(admissionMap.keySet().size() > 0){
        for(Admission_Acknowledgement__c admAck : [SELECT Id,IPID__c,Max_ID__c,recordtypeId,alletec_hospitallocation__c,HCF_Source__c,Sub_Speciality__c,
                                                   pcl_markuptype__c,Related_Prospect__r.Estimate_Amount__c,Is_Patient_Transfer__c,
                                                   (SELECT Id FROM Billing_Summary__r) 
                                                   FROM Admission_Acknowledgement__c
                                                   WHERE recordtypeId=:intlRecordTypeId 
                                                   AND Max_ID__c IN :maxIdSet 
                                                   AND IPID__c IN :ipIdSet
                                                   AND alletec_hospitallocation__c IN :locationSet
                                                   ]){
                                                       
                                                       
                                                      // system.debug('mappppppp>>>>'+admissionMap.keySet());
                                                      // system.debug('andr' + admAck.IPID__c+'@@'+admAck.alletec_hospitallocation__c);
                                                      
                                                       
                                                       //check if the same type of key exist or not 
                                                       if(admissionMap.containsKey(admAck.IPID__c+'@@'+admAck.alletec_hospitallocation__c)){
                                                           
                                                           //if key matches than put the record with the same key again 
                                                           admissionMap.put(admAck.IPID__c+'@@'+admAck.alletec_hospitallocation__c, admAck);
                                                           if(admAck.Billing_Summary__r!=null && admAck.Billing_Summary__r.size()>0)
                                                               billmap.put(admAck.IPID__c+'@@'+admAck.alletec_hospitallocation__c,true);
                                                           
                                                       }
                                                   }
         
         
        
        
        for(Internationalpatient_Outstanding__c io : trigger.new){
            if(io.alletec_ipid__c != null && io.alletec_location__c != null){
                
                
                // by using ternary condition insert the fields of admack recrd in the same key of io obj 
                io.HCF_Source__c = admissionMap.get(String.valueOf(io.alletec_ipid__c)+'@@'+io.alletec_location__c) != null ? admissionMap.get(String.valueOf(io.alletec_ipid__c)+'@@'+io.alletec_location__c).HCF_Source__c:null;
                io.Speciality__c = admissionMap.get(String.valueOf(io.alletec_ipid__c)+'@@'+io.alletec_location__c) != null ? admissionMap.get(String.valueOf(io.alletec_ipid__c)+'@@'+io.alletec_location__c).Sub_Speciality__c:null;
                io.Estimated_Amount__c=admissionMap.get(String.valueOf(io.alletec_ipid__c)+'@@'+io.alletec_location__c)!=null? admissionMap.get(String.valueOf(io.alletec_ipid__c)+'@@'+io.alletec_location__c).Related_Prospect__r.Estimate_Amount__c:null;
                io.Tarrif__c = admissionMap.get(String.valueOf(io.alletec_ipid__c)+'@@'+io.alletec_location__c) != null ? admissionMap.get(String.valueOf(io.alletec_ipid__c)+'@@'+io.alletec_location__c).pcl_markuptype__c:null;
                io.Is_Patient_Transfer__c = admissionMap.get(String.valueOf(io.alletec_ipid__c)+'@@'+io.alletec_location__c) != null ? admissionMap.get(String.valueOf(io.alletec_ipid__c)+'@@'+io.alletec_location__c).Is_Patient_Transfer__c:null;
                if(billmap.containsKey(String.valueOf(io.alletec_ipid__c)+'@@'+io.alletec_location__c) && billmap.get(String.valueOf(io.alletec_ipid__c)+'@@'+io.alletec_location__c) != null )
                    io.Discharged__c = true;
            }
        }
        
    }
}