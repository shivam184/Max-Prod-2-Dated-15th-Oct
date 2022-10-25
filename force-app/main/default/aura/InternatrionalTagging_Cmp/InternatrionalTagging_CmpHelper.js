({
    getInternationalLead : function(component,event){
        
        component.set('v.showSpinner', true); 
        //component.set('v.lowerdata',{});
        //component.set("v.upperdata",{});   
        component.set('v.selectedRowId','');
        //component.set('v.selectedackId','');
        component.set('v.v.isTagged',false);
        
        component.set('v.selPatName','');
        component.set('v.selIPID','');
        component.set('v.selMaxID','');
        
        var action = component.get("c.fetchLead");
        action.setParams({
            "maxId" : component.get("v.maxId"),
            "fromDateLead" : component.get("v.fromDateLead"),
            "toDateLead" : component.get("v.toDateLead")
        });
        //action.setStorable();
        action.setCallback(this, function(response){
            var state = response.getState();
            //alert('state-->'+state);
            if(state==="SUCCESS" && response.getReturnValue().status==="SUCCESS"){
                var leaddata = [];
                var ackData = [];                
                if(response.getReturnValue().leadLst.length>0){
                    for(var i=0; i<response.getReturnValue().leadLst.length; i++){
                        var dt = new Date(response.getReturnValue().leadLst[i].CreatedDate);
                        
                        leaddata.push({
                            'name':response.getReturnValue().leadLst[i].Name,
                            'date':response.getReturnValue().leadLst[i].Intlr_Intimation_Date__c,
                            'time':response.getReturnValue().leadLst[i].Intlr_Time_formula__c,
                            'message':response.getReturnValue().leadLst[i].Description__c,
                            'createdon':response.getReturnValue().leadLst[i].CreatedDate,
                            'id' : response.getReturnValue().leadLst[i].Id
                            
                        });
                    }
                } 
                component.set('v.lowerdata',leaddata);
                
                if(response.getReturnValue().acknowledgeList.length>0){
                    for(var i=0; i<response.getReturnValue().acknowledgeList.length; i++){
                        console.log('Pat-->'+JSON.stringify(response.getReturnValue().acknowledgeList[i]));
                        var Dor;
                        
                        if(response.getReturnValue().acknowledgeList[i].Patient__c!=null && response.getReturnValue().acknowledgeList[i].Patient__c!=undefined){
                            if(response.getReturnValue().acknowledgeList[i].Patient__r.alletec_patientregisterationdate__c!=null && response.getReturnValue().acknowledgeList[i].Patient__r.alletec_patientregisterationdate__c!=undefined)
                            	Dor=response.getReturnValue().acknowledgeList[i].Patient__r.alletec_patientregisterationdate__c;
                        }
                        
                        var speciality = '';
                        if(response.getReturnValue().acknowledgeList[i].alletec_speciality__c!=null && response.getReturnValue().acknowledgeList[i].alletec_speciality__c!=undefined)
                            speciality = response.getReturnValue().acknowledgeList[i].alletec_speciality__r.Name;
                        
                        var hcf='';
                        if(response.getReturnValue().acknowledgeList[i].HCF_Source__c!=null && response.getReturnValue().acknowledgeList[i].HCF_Source__c!=undefined)
                            hcf = response.getReturnValue().acknowledgeList[i].HCF_Source__r.Name;
                        
                        
                        ackData.push({
                            'maxid':response.getReturnValue().acknowledgeList[i].Max_ID__c,
                            'opid':response.getReturnValue().acknowledgeList[i].OPID__c,
                            'ipid':response.getReturnValue().acknowledgeList[i].IPID__c,
                            'Patient':response.getReturnValue().acknowledgeList[i].Patient_Name__c,
                            'DOR':Dor,
                            'OTT':response.getReturnValue().acknowledgeList[i].OP_Transaction_Type__c,
                            'TreatingDoctor':response.getReturnValue().acknowledgeList[i].Doctor_Name__c,
                            'Speciality':speciality,
                            'DateOfAdmission':response.getReturnValue().acknowledgeList[i].Date_Time_of_Admission__c,
                            'HCFSource':hcf,
                            'TransactionType':response.getReturnValue().acknowledgeList[i].Transaction_Type__c,
                            'id':response.getReturnValue().acknowledgeList[i].Id
                        });                        
                    }
                }
                
                if(response.getReturnValue().opTransacList.length>0){
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
                            'HCFSource':response.getReturnValue().opTransacList[i].HCF_Source__c,
                            'TransactionType':response.getReturnValue().opTransacList[i].alletec_transactiontype__c,
                            'id':response.getReturnValue().opTransacList[i].Id
                        })
                    }
                }    
               	
                if(component.get("v.checkEnter"))
                	component.set("v.upperdata",ackData);               
                component.set('v.showSpinner', false);
                component.set("v.checkEnter",false);
            }else{
                this.showToastMsg(component,event,response.getReturnValue().status,'error','Error!');
                component.set('v.showSpinner', false);
            }
        });
        $A.enqueueAction(action);
    },
    
    
    
    
    fillDataColumn : function(component,event,helper) {
        component.set('v.uppercolumns', [
            {label: 'MAX ID', fieldName: 'maxid', type: 'text'},
            {label: 'OP ID', fieldName: 'opid', type: 'text'},
            {label: 'IP ID', fieldName: 'ipid', type: 'text'},
            {label: 'Patient', fieldName: 'Patient', type: 'text'},
            {label: 'Regis Date', fieldName: 'DOR', type: 'date', typeAttributes: {  
                year: 'numeric',
                month: '2-digit',  
                day: '2-digit',  
               	hour: '2-digit',  
                minute: '2-digit',  
                hour12: true}},
            {label: 'OP Trans Type', fieldName: 'OTT', type: 'text'},
            {label: 'Treating Doctor', fieldName: 'TreatingDoctor', type: 'text'},
            {label: 'Speciality', fieldName: 'Speciality', type: 'text'},
            {label: 'Admission Date', fieldName: 'DateOfAdmission', type: 'date', typeAttributes: {  
                year: "numeric",
                day: '2-digit',  
                month: '2-digit',  
                hour: '2-digit',  
                minute: '2-digit',  
                hour12: true}},
            {label: 'HCF Source', fieldName: 'HCFSource', type: 'text'},
            {label: 'Trans Type', fieldName: 'TransactionType', type: 'text'}
        ]);       
        component.set('v.lowercolumns',[
            {label: 'Name', fieldName: 'name', type: 'text'},
            {label: 'Date', fieldName: 'date', type: 'date',cellAttributes: { iconName: 'utility:event', iconAlternativeText: 'Date'  }},
            {label: 'Time', fieldName: 'time', type: 'text',cellAttributes: { iconName: 'utility:date_time', iconAlternativeText: 'created On'}},
            {label: 'Message', fieldName: 'message', type: 'text'},
            {label: 'Created On', fieldName: 'createdon', type: 'date'}
        ]);
    },
    
    showToastMsg: function(component,event,msg,msgType,title){
        var toatsEvt = $A.get("e.force:showToast");
        toatsEvt.setParams({
            "message":msg,
            "type": msgType,
            "title":title,
            "duration": "1000"
        });
        toatsEvt.fire();
    }
    
})