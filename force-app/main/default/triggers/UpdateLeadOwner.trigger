trigger UpdateLeadOwner on Lead__c (before update) {
 list<string> DoctorchannelBusinessUnitList=new list<String>();
    set<string> doctorset =new set<string>();
    set<string> Channelset =new set<string>();
    map<String,String> DoctorchannelBusinessUnitMap=new map<string,string>();
    map<lead__c,String> LeadDoctorchannelBusinessUnitMap=new map<lead__c,string>();
    List<Lead__c> listLead=new list<Lead__c>();
    set<string> BusinessUnitset =new set<string>();  
    if(label.LeadownerupdatetriggerOnOff=='On'){
    for(Lead__c lead:trigger.new){
        if(lead.APISave__c==true){
            //system.debug(lead.Doctor__c+'>>>>>'+lead.Speciality_Text__c+'>>>>>>'+lead.Business_Unit__c);
            if(lead.Doctor__c != Null && lead.Speciality_Text__c != Null  && lead.Business_Unit__c != Null){
                doctorset.add(lead.Doctor__c);
                Channelset.add(lead.Speciality_Text__c);
                BusinessUnitset.add(lead.Business_Unit__c);  
                DoctorchannelBusinessUnitMap.put(lead.Doctor__c+lead.Speciality_Text__c+lead.Business_Unit__c,lead.id);
                DoctorchannelBusinessUnitList.add(lead.Doctor__c+lead.Speciality_Text__c+lead.Business_Unit__c);
                LeadDoctorchannelBusinessUnitMap.put(lead,lead.Doctor__c+lead.Speciality_Text__c+lead.Business_Unit__c);

            }
        }
    }
    
  //  system.debug('LeadDoctorchannelBusinessUnitMap'+LeadDoctorchannelBusinessUnitMap);
    //    system.debug('DoctorchannelBusinessUnitMap'+DoctorchannelBusinessUnitMap);

    map<id,string> leaddocMasterMap=new map<id,string>();
    
    list<Doctor_Co_Ordinator_OP_OP__c> DoctorCoordinator=[select id,Doctor__c,Business_Unit__r.name,Co_Ordinator__c,Doctor_Speciality__c,ownerid,Channel__c,Business_Unit__c from Doctor_Co_Ordinator_OP_OP__c where Doctor__c IN:doctorset AND  Doctor_Speciality__c IN: Channelset AND Business_Unit__r.name IN: BusinessUnitset];
 //system.debug(DoctorCoordinator.size());
    if(DoctorCoordinator.size()>0){
    for(Doctor_Co_Ordinator_OP_OP__c docmaster:DoctorCoordinator ) {
                    //system.debug(docmaster.Doctor__c+'>>>>>'+docmaster.Doctor_Speciality__c+'>>>>>>'+docmaster.Business_Unit__c);

        if(DoctorchannelBusinessUnitList.contains(docmaster.Doctor__c+docmaster.Doctor_Speciality__c+docmaster.Business_Unit__r.name))
            leaddocMasterMap.put(DoctorchannelBusinessUnitMap.get(docmaster.Doctor__c+docmaster.Doctor_Speciality__c+docmaster.Business_Unit__r.name),docmaster.Co_Ordinator__c);
    }
    }
            //system.debug('leaddocMasterMap'+leaddocMasterMap);

    if(!LeadDoctorchannelBusinessUnitMap.isEmpty()){
        for(lead__c ld:LeadDoctorchannelBusinessUnitMap.keySet()){
            if(leaddocMasterMap.containskey(ld.id)){
                if(ld.Disposition_Option__c=='Assign to Unit SPOC'){
                ld.OwnerId=leaddocMasterMap.get(ld.id);
                ld.Stage__c='Assigned to Unit';    
                listLead.add(ld);
                }
                if(ld.Disposition_Option__c=='Assign to Max@Home' || ld.Disposition_Option__c=='Follow Up'){
                ld.OwnerId=leaddocMasterMap.get(ld.id);
                ld.Stage__c='Assigned to Max@Home';    
                listLead.add(ld);
                } 
                if(ld.Disposition_Option__c=='Not Interested' && ld.Sub_Option__c=='Discount offered'){
                ld.OwnerId=leaddocMasterMap.get(ld.id);
                ld.Stage__c='Assigned to Unit';    
                listLead.add(ld);
                }
                if(ld.Disposition_Option__c=='Not Interested' && (ld.Sub_Option__c=='Not required Immediately' || ld.Sub_Option__c=='Pricing issue' || ld.Sub_Option__c=='Done from Nearby Lab')){
                ld.OwnerId=leaddocMasterMap.get(ld.id);
                ld.Stage__c='Closed Lost';    
                listLead.add(ld);
                }
            }
            
        }
    }
       // if( listLead.size()>0)
    }       // update listLead;

}