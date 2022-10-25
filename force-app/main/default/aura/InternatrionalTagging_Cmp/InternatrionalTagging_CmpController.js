({
    init : function(component, event, helper) {        
        component.set("v.checkEnter",true);
        helper.fillDataColumn(component, event);
        helper.getInternationalLead(component,event);         
    },
    
    selectedRecords: function(component,event,helper){        
        var selectedRow = event.getParam('selectedRows'); 
        if (!$A.util.isUndefinedOrNull(selectedRow) && !$A.util.isUndefinedOrNull(selectedRow[0])){
            component.set('v.selectedRowId',selectedRow[0].id);
        }
    },
    
    selectedRecordsId: function(component,event,helper){        
        var selectedRow = event.getParam('selectedRows');  
        if (!$A.util.isUndefinedOrNull(selectedRow) && !$A.util.isUndefinedOrNull(selectedRow[0])){
            component.set('v.selectedackId',selectedRow[0].id);
        }
    },
    
    refreshLead: function(component,event,helper){
        $A.get('e.force:refreshView').fire();
        //helper.getInternationalLead(component,event);
    },
    
    //==========tag Admission Ack OR OP-Transaction with International Lead=======================    
    
    doTagWithSMS: function(component,event,helper){
        
        if(!$A.util.isEmpty(component.get('v.selectedRowId')) && !$A.util.isEmpty(component.get('v.selectedackId'))){
            var modalBody;
            $A.createComponent("c:InternationalDoctors", {"selectedAdmissionId" : component.get("v.selectedackId"),
                                                          "selectedLeadId" : component.get("v.selectedRowId	")},
                               function(content, status) {
                                   if (status === "SUCCESS") {
                                       modalBody = content;
                                       var modalPromise = component.find('overlayLib').showCustomModal({
                                           body: modalBody, 
                                           showCloseButton: true,                                          
                                       });
                                       component.set('v.modalPromise',modalPromise);
                                   }                               
                               });                    
        }else{
            helper.showToastMsg(component,event,'Please select an Admission Acknowledgement and a Pre-Intimation','error','Error!');
        }        
    },
    
    
    
    doTagWOSMS : function(component,event,helper){       
        if(!$A.util.isEmpty(component.get("v.selectedackId"))){
            var modalBody;
            $A.createComponent("c:TagWithOutSMSComponent", {"selectedAdmissionId" : component.get("v.selectedackId")},
                               function(content, status) {
                                   if (status === "SUCCESS") {
                                       modalBody = content;
                                       var modalPromise = component.find('overlayLib').showCustomModal({
                                           body: modalBody, 
                                           showCloseButton: true,
                                       })
                                       component.set('v.modalPromise',modalPromise);
                                       
                                   }                               
                               });
        }else{
            helper.showToastMsg(component,event,'Please select an Admission Acknowledgement/OP-Transaction','error','Error!');
        }
    },
    
    doDirectTagging : function(component, event, helper){
        var selId = component.get('v.selectedackId');
        if(selId!=undefined && selId!=null){
            var action = component.get("c.directTagging");            
            action.setParams({
                "AckId" : component.get("v.selectedackId"),
                "selectedLeadId" : component.get("v.selectedRowId")
            });
            action.setCallback(this,function(response){
                if(response.getState() === "SUCCESS") {
                    if(response.getReturnValue().includes("SUCCESS")) { 
                        component.set("v.checkEnter",true);
                        helper.getInternationalLead(component,event);
                        helper.showToastMsg(component,event,'Direct Tagging has been done successfully','success','SUCCESS');   
                    }	
                    else {
                        helper.showToastMsg(component,event,response.getReturnValue(),'error','ERROR');                            
                    }
                } 
                $A.get('e.force:refreshView').fire();
                
            });  
            $A.enqueueAction(action);  
        }else{
            helper.showToastMsg(component,event,'Select Ack/OP-Transaction.','error','Error!');
        }
    },
    
    //============ method to search Admission Ack and OP-Transaction based on filters=======================
    
    searchbyFilters : function(component,event,helper){
        if(event.keyCode == 13) {
            var isRecords = false;
            component.set('v.showSpinner', true); 
            var action = component.get("c.doSearchAckOpApex");
            action.setParams({
                "patName": component.get("v.selPatName"),
                "ipid": component.get("v.selIPID"),
                'maxid': component.get("v.selMaxID"),
                'isTagged' : component.get("v.isTagged")
            });
            
            console.log('action-->'+action);
            
            action.setCallback(this,function(response){
                if(response.getState()==="SUCCESS" && response.getReturnValue().status==="SUCCESS"){
                    console.log('action-->'+response.getState());
                    console.log('Recponse-->'+JSON.stringify(response.getReturnValue().acknowledgeList));
                    console.log('Resp 2-->'+response.getReturnValue().acknowledgeList.length);
                    var ackData = [];
                    if(response.getReturnValue().acknowledgeList.length>0){
                        isRecords = true;
                        console.log('Resp 3-->'+response.getReturnValue().acknowledgeList.length);
                        for(var i=0; i< response.getReturnValue().acknowledgeList.length ; i++){
                            
                            console.log('Resp 4-->'+response.getReturnValue().acknowledgeList.length);
                            //console.log('--->'+JOSN.stringify(response.getReturnValue().acknowledgeList[i]));
                            //console.log('--->'+response.getReturnValue().acknowledgeList[i].alletec_speciality__c);
                            
                            var speciality = '';
                            var Dor = '';
                            console.log('--speciality->'+speciality);
                            if(response.getReturnValue().acknowledgeList[i].alletec_speciality__c !=null && response.getReturnValue().acknowledgeList[i].alletec_speciality__c !=undefined)
                                speciality = response.getReturnValue().acknowledgeList[i].alletec_speciality__r.Name;
                            
                            //if(response.getReturnValue().acknowledgeList[i].Patient__c!=null && response.getReturnValue().acknowledgeList[i].Patient__c!=undefined){
                            if(response.getReturnValue().acknowledgeList[i].Patient__r.alletec_patientregisterationdate__c!=null && response.getReturnValue().acknowledgeList[i].Patient__r.alletec_patientregisterationdate__c!=undefined)
                            	Dor=response.getReturnValue().acknowledgeList[i].Patient__r.alletec_patientregisterationdate__c;
                        	//}
                            
                            console.log('--speciality->'+speciality);
                            
                            ackData.push({
                                'maxid':response.getReturnValue().acknowledgeList[i].Max_ID__c,
                                'opid':response.getReturnValue().acknowledgeList[i].OPID__c,
                                'ipid':response.getReturnValue().acknowledgeList[i].IPID__c,
                                'Patient':response.getReturnValue().acknowledgeList[i].Patient_Name__c,
                                'DOR':Dor,
                                'OTT':response.getReturnValue().acknowledgeList[i].OP_Transaction_Type__c,
                                'TreatingDoctor':response.getReturnValue().acknowledgeList[i].Doctor_Name__c,
                                'Speciality': speciality,
                                'DateOfAdmission':response.getReturnValue().acknowledgeList[i].Date_Time_of_Admission__c,
                                'HCFSource':response.getReturnValue().acknowledgeList[i].HCF_Source__c,
                                'TransactionType':response.getReturnValue().acknowledgeList[i].Transaction_Type__c,
                                'id':response.getReturnValue().acknowledgeList[i].Id
                            });
                        }
                    }
                    console.log('---ackData>'+ackData);
                    if(response.getReturnValue().opTransacList.length>0){
                        isRecords = true;
                        for(var i=0; i<response.getReturnValue().opTransacList.length; i++){
                            var speciality = '';
                            var patient='';
                            var treatingDoc='';
                            var Dor;
                        	if(!$A.util.isEmpty(response.getReturnValue().opTransacList[i].Patient__c)){
                            	Dor=response.getReturnValue().opTransacList[i].Patient__r.alletec_patientregisterationdate__c;
                        	}
                            if(!$A.util.isEmpty(response.getReturnValue().opTransacList[i].Patient__c)){
                                patient=response.getReturnValue().opTransacList[i].Patient__r.Name;
                            }
                            if(!$A.util.isEmpty(response.getReturnValue().opTransacList[i].Treating_Doctor__c)){
                                treatingDoc=response.getReturnValue().opTransacList[i].Treating_Doctor__r.Name;
                            }
                            if(!$A.util.isEmpty(response.getReturnValue().opTransacList[i].alletec_department__c))
                                speciality = response.getReturnValue().opTransacList[i].alletec_department__r.Name;
                            ackData.push({
                                'maxid':response.getReturnValue().opTransacList[i].name__c,
                                'opid':response.getReturnValue().opTransacList[i].alletec_op__c,
                                'ipid':response.getReturnValue().opTransacList[i].alletec_ipid__c,                            
                                'Patient':patient,
                                'DOR':Dor,
                                'OTT':response.getReturnValue().opTransacList[i].OP_Transaction_Type__c,
                                'TreatingDoctor':treatingDoc,
                                'Speciality':speciality,
                                'DateOfAdmission':response.getReturnValue().opTransacList[i].alletec_billdate__c,
                                'HCFSource':response.getReturnValue().opTransacList[i].HCF_Source__c,
                                'TransactionType':response.getReturnValue().opTransacList[i].alletec_transactiontype__c,
                                'id':response.getReturnValue().opTransacList[i].Id
                            })
                        }
                    }               
                    component.set('v.upperdata',ackData);
                    if(!isRecords)
                        helper.showToastMsg(component,event,'No records found.','warning','Error!')
                        }else{
                            helper.showToastMsg(component,event,response.getReturnValue().status,'error','Error!');
                        }
                component.set('v.showSpinner', false); 
            })
            
            $A.enqueueAction(action);
        }
    },
    
    //============method to get the Tagged List=====================================
    
    getTagged : function(component,event,helper){
        if(component.get("v.isTagged")){
            component.set('v.showSpinner', true);
            var action = component.get("c.getTaggedApex");
            //action.setStorable();
            action.setCallback(this,function(response){
                if(response.getState()==="SUCCESS" && response.getReturnValue().status === "SUCCESS"){
                    var ackData = [];
                    var leaddata = [];
                    if(!$A.util.isEmpty(response.getReturnValue().leadLst.length)){
                        for(var i=0; i<response.getReturnValue().leadLst.length; i++){
                            var dt = new Date(response.getReturnValue().leadLst[i].CreatedDate);
                            leaddata.push({
                                'name':response.getReturnValue().leadLst[i].Name,
                                'date':response.getReturnValue().leadLst[i].CreatedDate,
                                'time':dt.getHours()+':'+dt.getMinutes()+':'+dt.getSeconds(),
                                'message':response.getReturnValue().leadLst[i].Description,
                                'createdon':response.getReturnValue().leadLst[i].CreatedDate,
                                'id' : response.getReturnValue().leadLst[i].Id
                                
                            });
                        }
                        component.set('v.lowerdata',leaddata);
                    }
                    
                    if(!$A.util.isEmpty(response.getReturnValue().acknowledgeList.length)){
                        for(var i=0; i<response.getReturnValue().acknowledgeList.length; i++){
                            var Dor;
                            if(!$A.util.isEmpty(response.getReturnValue().acknowledgeList[i].Patient__c)){
                                Dor=response.getReturnValue().acknowledgeList[i].Patient__r.alletec_patientregisterationdate__c;
                            }
                            var speciality = '';
                            if(response.getReturnValue().acknowledgeList[i].Sub_Speciality__c!=null && response.getReturnValue().acknowledgeList[i].Sub_Speciality__c!=undefined)
                                speciality = response.getReturnValue().acknowledgeList[i].Sub_Speciality__r.Name;
                            ackData.push({
                                'maxid':response.getReturnValue().acknowledgeList[i].Max_ID__c,
                                'opid':response.getReturnValue().acknowledgeList[i].OPID__c,
                                'ipid':response.getReturnValue().acknowledgeList[i].IPID__c,
                                'Patient':response.getReturnValue().acknowledgeList[i].Patient_Name__c,
                                'DOR':Dor,
                                'OTT':response.getReturnValue().acknowledgeList[i].OP_Transaction_Type__c,
                                'TreatingDoctor':response.getReturnValue().acknowledgeList[i].Doctor_Name__c,
                                'Speciality': speciality,
                                'DateOfAdmission':response.getReturnValue().acknowledgeList[i].Date_Time_of_Admission__c,
                                'HCFSource':response.getReturnValue().acknowledgeList[i].HCF_Source__r.Name,
                                'TransactionType':response.getReturnValue().acknowledgeList[i].Transaction_Type__c,
                                'id':response.getReturnValue().acknowledgeList[i].Id
                            });                        
                        }
                    }
                    if(!$A.util.isEmpty(response.getReturnValue().opTransacList.length)){
                        for(var i=0; i<response.getReturnValue().opTransacList.length; i++){
                            var speciality = '';
                            var patient='';
                            var treatingDoc='';
                            if(!$A.util.isEmpty(response.getReturnValue().opTransacList[i].Patient__c)){
                                patient=response.getReturnValue().opTransacList[i].Patient__r.Name;
                            }
                            if(!$A.util.isEmpty(response.getReturnValue().opTransacList[i].Treating_Doctor__c)){
                                treatingDoc=response.getReturnValue().opTransacList[i].Treating_Doctor__r.Name;
                            }
                            var Dor;
                            if(!$A.util.isEmpty(response.getReturnValue().opTransacList[i].Patient__c)){
                                Dor=response.getReturnValue().opTransacList[i].Patient__r.alletec_patientregisterationdate__c;
                            }
                            if(!$A.util.isEmpty(response.getReturnValue().opTransacList[i].alletec_department__c))
                                speciality = response.getReturnValue().opTransacList[i].alletec_department__r.Name;
                            ackData.push({
                                'maxid':response.getReturnValue().opTransacList[i].name__c,
                                'opid':response.getReturnValue().opTransacList[i].alletec_op__c,
                                'ipid':response.getReturnValue().opTransacList[i].alletec_ipid__c,                            
                                'Patient':patient,
                                'DOR':Dor,
                                'OTT':response.getReturnValue().opTransacList[i].OP_Transaction_Type__c,
                                'TreatingDoctor':treatingDoc,
                                'Speciality':speciality,
                                'DateOfAdmission':response.getReturnValue().opTransacList[i].alletec_billdate__c,
                                'HCFSource':response.getReturnValue().opTransacList[i].HCF_Source__r.Name,
                                'TransactionType':response.getReturnValue().opTransacList[i].alletec_transactiontype__c,
                                'id':response.getReturnValue().opTransacList[i].Id
                            })
                        }
                    } 
                    component.set('v.upperdata',ackData);
                }else{
                    helper.showToastMsg(component,event,response.getReturnValue().status,'error','Error!');
                }
                component.set('v.showSpinner', false);
            })
            $A.enqueueAction(action);
        }else{
            component.set("v.checkEnter",true);
            helper.getInternationalLead(component,event,helper);
            
        }
    }  ,
    
    searchLead : function(component,event,helper) {
        if(event.keyCode == 13) {
            //component.set("v.checkEnter",true);
            helper.getInternationalLead(component,event);
        }
        	 
    },
    
    refreshView : function(component, event, helper){
        var obj = event.getParams();
        component.set('v.showSpinner', true);
        var action = component.get("c.doTagWithSMSApex");            
        action.setParams({
            "selectedLeadId" : obj.selectedLead,
            "selectedAdmissionId" : obj.selectedAck,
            "selectedMecpSource" : obj.selectedDoctor
        });
        action.setCallback(this,function(response){
            if(response.getState() === "SUCCESS") {
                if(response.getReturnValue().includes("SUCCESS")) {                          
                    helper.showToastMsg(component,event,'Tag with Pre Intimation has been done successfully','success','SUCCESS');
                    //component.set("v.checkEnter",true);
                    $A.get('e.force:refreshView').fire();
                    /*component.set('v.maxId','');
                    component.set('v.fromDateLead',null);
                    component.set('v.toDateLead',null);
                    helper.getInternationalLead(component, event);*/
                }	
                else {
                    helper.showToastMsg(component,event,'ERROR',response.getReturnValue(),'error');	    
                }
                component.set('v.showSpinner', false);
            }
        });  
        $A.enqueueAction(action);
    }    
})