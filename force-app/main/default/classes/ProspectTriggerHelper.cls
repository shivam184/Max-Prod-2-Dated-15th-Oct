public class ProspectTriggerHelper{
    //added by Nitya on 27th May 2022 to tag international Iop journey records with prospect
    //on insertion and updation in before context
    public static void tagInternationalOpPatient(List<prospect__c>triggerNew){
        Map<string,prospect__c> prosMap=new Map<string,prospect__c>();
        for(prospect__c p:triggerNew){
            if(p.International_OP_Patient_Journey__c==null){
                prosMap.put(p.Max_Id__c,p);   
            }
        }
        if(prosMap.isEmpty())
            return;
        Map<string,International_OP_Patient_Journey__c> iopMap=new map<string,International_OP_Patient_Journey__c>();
        List<International_OP_Patient_Journey__c> iopList=[select id,patient_max_id__c from International_OP_Patient_Journey__c where patient_max_id__c in:prosMap.keySet() and journey_day__c<=90];
        for(International_OP_Patient_Journey__c iop:iopList){
            iopMap.put(iop.patient_max_id__c,iop);
        }
        for(prospect__c p:prosMap.values()){
            if(!iopMap.isEmpty())
                p.International_OP_Patient_Journey__c=iopMap.get(p.Max_Id__c).id;
        }
    }
    //@Nitya added to replace process builder
    //updated by Nitya on 27th MAy 2022
    public static void updateIopjRecord(list<Prospect__c> triggerNew){
        List<International_OP_Patient_Journey__c> ipojList=new List<International_OP_Patient_Journey__c>();
        set<id> prosSet=new set<id>();
        for(prospect__c p:triggerNew){
            prosSet.add(p.id);
        }
        list<prospect__c> prosList=[select id,International_OP_Patient_Journey__c,International_OP_Patient_Journey__r.Journey_Day__c,stage__c,
                                    International_OP_Patient_Journey__r.stage__c from prospect__c where id in:prosSet ];
        if(prosList==null){return;}
        for(prospect__c pro:prosList){
            if(pro.International_OP_Patient_Journey__c==null){continue;}
            if( pro.International_OP_Patient_Journey__c!=null && pro.International_OP_Patient_Journey__r.Journey_Day__c<90){
                if(pro.stage__c=='Admission' && pro.International_OP_Patient_Journey__r.stage__c!='Closed Lost' && pro.International_OP_Patient_Journey__r.stage__c!='Closed Won' && pro.International_OP_Patient_Journey__r.stage__c!='Admitted' && pro.International_OP_Patient_Journey__r.stage__c!='Discharged'){
                    // system.debug(pro.stage__c);
                    ipojList.add(new International_OP_Patient_Journey__c(id=pro.International_OP_Patient_Journey__c,stage__c='Admission Advice', 
                                                                         admission_advice__c=true));
                }
                else if(pro.Stage__c=='Patient Admitted' && pro.International_OP_Patient_Journey__r.stage__c!='Closed Lost' && pro.International_OP_Patient_Journey__r.stage__c!='Closed Won' && pro.International_OP_Patient_Journey__r.stage__c!='Discharged'){
                    ipojList.add(new International_OP_Patient_Journey__c(id=pro.International_OP_Patient_Journey__c,stage__c='Admitted')); 
                }
                else if(pro.Stage__c=='Patient Discharged' && pro.International_OP_Patient_Journey__r.stage__c!='Closed Lost' && pro.International_OP_Patient_Journey__r.stage__c!='Closed Won'){
                    ipojList.add(new International_OP_Patient_Journey__c(id=pro.International_OP_Patient_Journey__c,stage__c='Discharged'));
                }
            }
        }
        update ipojList;
    }
    //Map prospect Assigned doctor Coordinator and Secondary doctor coordinator on Prospect record.
    public void prospectIsBeforeEvent(list<Prospect__c> triggerNew){
        
        Set<Id> DocIds = new Set<Id>();
        Set<Id> bUnitIds = new Set<Id>();
        
        for(Prospect__c p : triggerNew){
            if(p.Doctor__c!=NULL && p.HIS_Hospital_Location__c!=NULL){
                DocIds.add(p.Doctor__c);
                bUnitIds.add(p.HIS_Hospital_Location__c);
            }
        }
        
        Map<String,String> MapDocMasterToCordinates = new Map<String,String>();
        Map<Id,Business_Unit__c> MapBusinessunits = new Map<Id,Business_Unit__c>();
        
        if(DocIds.size()>0 && bUnitIds.size()>0){
            List<Doctor_Coordinator_Master__c> DoCMasterList = doctorCoordinatorList(DocIds,bUnitIds);       
            
            for(Business_Unit__c BU : [Select Id,Name From Business_Unit__c Where Id IN: bUnitIds]){
                MapBusinessunits.put(BU.Id,BU);
            }
            
            
            if(DoCMasterList.size()>0){
                for(Doctor_Coordinator_Master__c dcm : DoCMasterList){
                    if(dcm.Business_Unit__c!=NULL && dcm.Doctor__c!=NULL && dcm.Channel__c!=NULL && dcm.Co_ordinator__c!=NULL){
                        MapDocMasterToCordinates.put(dcm.Doctor__c+'-'+dcm.Business_Unit__c+'-'+dcm.Channel__c, dcm.Co_ordinator__c);
                    }
                }
            }
        }   
        
        system.debug('MapDocMasterToCordinates-->'+MapDocMasterToCordinates);
        
        Map<String,String> MapQueueNameToId = new Map<String,String>();
        for(QueueSobject q :[SELECT Id,queue.Name, QueueId,SobjectType FROM QueueSobject where SobjectType='Prospect__c']){
            MapQueueNameToId.put(q.queue.Name.toUpperCase(), q.QueueId);
        }
        
        system.debug('MapQueueNameToId-->'+MapQueueNameToId);
        
        for(Prospect__c p : triggerNew){
            if(p.Doctor__c!=NULL && p.HIS_Hospital_Location__c!=NULL && p.Channel__c!=Null){
                system.debug('MapDocMasterToCordinates.containsKey-->'+MapDocMasterToCordinates.containsKey(p.Doctor__c+'-'+p.HIS_Hospital_Location__c+'-'+p.Channel__c));
                system.debug(p.Doctor__c+'-'+p.HIS_Hospital_Location__c+'-'+p.Channel__c);
                if(MapDocMasterToCordinates.containsKey(p.Doctor__c+'-'+p.HIS_Hospital_Location__c+'-'+p.Channel__c)){
                    p.OwnerId=MapDocMasterToCordinates.get(p.Doctor__c+'-'+p.HIS_Hospital_Location__c+'-'+p.Channel__c);
                }else{
                    if(MapQueueNameToId.containsKey(MapBusinessunits.get(p.HIS_Hospital_Location__c).Name.toUpperCase())){
                        p.OwnerId=MapQueueNameToId.get(MapBusinessunits.get(p.HIS_Hospital_Location__c).Name.toUpperCase());
                    }
                }
            }
        }
        
        
        //Update Second Doctor Coordinator (If applicable)
        set<Id> secondDoctorIds = new set<Id>();
        set<Id> secondDoctorBus = new set<Id>();
        map<String,Id> secondDocMap = new map<String,Id>();
        for(Prospect__c p : triggerNew){
            if(p.Doctor_Est_Ep__c!=null && p.Secondary_Doctor_Business_Unit__c!=null){
                secondDoctorIds.add(p.Doctor_Est_Ep__c);
                secondDoctorBus.add(p.Secondary_Doctor_Business_Unit__c);
            }
        }
        
        if(secondDoctorIds!=null && secondDoctorIds.size()>0){
            for(Doctor_Coordinator_Master__c docMap : doctorCoordinatorList(secondDoctorIds, secondDoctorBus)){
                if(docMap.Business_Unit__c!=NULL && docMap.Doctor__c!=NULL && docMap.Channel__c!=Null && docMap.Co_ordinator__c!=NULL)
                    secondDocMap.put(docMap.Doctor__c+'-'+docMap.Business_Unit__c+'-'+docMap.Channel__c,docMap.Co_ordinator__c);
            }
        }
        
        for(Prospect__c p : triggerNew){
            if(p.Doctor_Est_Ep__c!=null && p.Secondary_Doctor_Business_Unit__c!=null && p.Channel__c!=Null){
                String key = p.Doctor_Est_Ep__c+'-'+p.Secondary_Doctor_Business_Unit__c+'-'+p.Channel__c;
                if(secondDocMap.containsKey(key))
                    p.Second_Doctor_s_Co_ordinator__c= secondDocMap.get(key);
            }
        }
    }
    
    
    
    
    
    //Share Prospect record with read only access to Secondary user
    public void prospectUpdateEvent(list<Prospect__c> triggerNew, map<Id,Prospect__c> oldMap){
        set<Id> updatedDoctorIds = new set<Id>();
        set<Id> updatedDoctorBus = new set<Id>();
        
        
        for(Prospect__c pros : triggerNew){
            if(pros.Doctor_Est_Ep__c!=null && oldMap.get(pros.Id).Doctor_Est_Ep__c!= pros.Doctor_Est_Ep__c && pros.Secondary_Doctor_Business_Unit__c!=null){
                updatedDoctorIds.add(pros.Doctor_Est_Ep__c);
                updatedDoctorBus.add(pros.Secondary_Doctor_Business_Unit__c);
            }
        }
        
        map<String,Doctor_Coordinator_Master__c> docCordinatorMap = new map<String,Doctor_Coordinator_Master__c>();
        if(updatedDoctorIds!=null && updatedDoctorIds.size()>0){
            for(Doctor_Coordinator_Master__c docMap : doctorCoordinatorList(updatedDoctorIds,updatedDoctorBus)){
                if(docMap.Business_Unit__c!=NULL && docMap.Doctor__c!=NULL && docMap.Channel__c!=Null && docMap.Co_ordinator__c!=null){
                    docCordinatorMap.put(docMap.Doctor__c+'-'+docMap.Business_Unit__c+'-'+docMap.Channel__c,docMap);
                }
            }
        }
        
        system.debug('docCordinatorMap-->'+docCordinatorMap);
        
        
        if(docCordinatorMap!=null && docCordinatorMap.size()>0){
            list<Prospect__Share> prospectShareList = new list<Prospect__Share>();
            for(Prospect__c pros : triggerNew){
                if(pros.Doctor__c!=pros.Doctor_Est_Ep__c && oldMap.get(pros.Id).Doctor_Est_Ep__c!= pros.Doctor_Est_Ep__c){
                    if(pros.Secondary_Doctor_Business_Unit__c!=null && pros.Doctor_Est_Ep__c!=null && pros.Channel__c!=null){
                        
                        String key = pros.Doctor_Est_Ep__c+'-'+pros.Secondary_Doctor_Business_Unit__c+'-'+pros.Channel__c;
                        
                        if(docCordinatorMap.containsKey(key) && docCordinatorMap.get(key).Co_ordinator__c != NULL){
                            if(pros.OwnerId != docCordinatorMap.get(key).Co_ordinator__c) {
                                Prospect__Share prospectShare  = new Prospect__Share();
                                prospectShare.ParentId = pros.Id;
                                prospectShare.UserOrGroupId = docCordinatorMap.get(key).Co_ordinator__c;
                                prospectShare.AccessLevel = 'Read';
                                prospectShareList.add(prospectShare);    
                            }
                        }
                    }
                }
            } 
            
            
            
            if(prospectShareList!=null && prospectShareList.size()>0)
                insert prospectShareList;
            
        }
    }
    
    //Method for querying Doctor Master List
    public list<Doctor_Coordinator_Master__c> doctorCoordinatorList(set<Id> doctorIds, set<Id> businessUnits){
        String query = 'SELECT Doctor__c,Business_Unit__c,Co_ordinator__c,Channel__c FROM Doctor_Coordinator_Master__c';
        
        if(doctorIds!=null && doctorIds.size()>0 && businessUnits!=null && businessUnits.size()>0)
            query+=' WHERE Doctor__c IN :doctorIds AND Business_Unit__c IN :businessUnits';
        else if(doctorIds!=null && doctorIds.size()>0)
            query+=' WHERE Doctor__c IN :doctorIds';
        else if(businessUnits!=null && businessUnits.size()>0)
            query+=' WHERE Business_Unit__c IN :businessUnits';
        
        return Database.query(query); 
    }
    
}