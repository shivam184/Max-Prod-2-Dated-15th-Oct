({
    handleCancel : function(component,event,helper) {
        component.find("overlayLib").notifyClose();
    },
    
    handleProceed : function(component,event,helper) {
        if($A.util.isEmpty(component.get("v.selectedMecpSource"))){
            document.getElementById("error1").style.display = "block";
        }
        else {
            if(component.get("v.retag")){
            	var spinner = component.find("mySpinner")
                $A.util.removeClass(spinner,"slds-hide");
                var action = component.get("c.retaggingApex");
                action.setParams({
                    "selectedAdmissionId" : component.get("v.selectedAdmissionId"),
                    "selectedMecpSource" : component.get("v.selectedMecpSource")
                });
                action.setCallback(this,function(response){
                    if(response.getState() === "SUCCESS"){
                        if(response.getReturnValue().includes("SUCCESS")) {
                        	var compEvent = $A.get("e.c:UpdateLeadMecpType");
                            compEvent.fire();
                            helper.showToast(component,event,'SUCCESS','Re-Tagging has been done successfully','success');    
                        }  
                        else {
                        	helper.showToast(component,event,'ERROR',response.getReturnValue(),'error');	        
                        }
                    }
                    component.find("overlayLib").notifyClose();
                    $A.util.addClass(spinner,"slds-hide");
                });
                $A.enqueueAction(action); 
            }
            else{
                var spinner = component.find("mySpinner");
                $A.util.removeClass(spinner,"slds-hide");
                var action = component.get("c.tagWithPreIntimationApex");
                action.setParams({
                    "selectedLeadId" : component.get("v.selectedLeadId"),
                    "selectedAdmissionId" : component.get("v.selectedAdmissionId"),
                    "selectedMecpSource" : component.get("v.selectedMecpSource")
                });
                action.setCallback(this,function(response){
                    if(response.getState() === "SUCCESS") {
                        if(response.getReturnValue().includes("SUCCESS")) {
                            var compEvent = $A.get("e.c:UpdateLeadMecpType");
                            compEvent.setParams({"fromEvent" : true});
                            compEvent.fire();
                            helper.showToast(component,event,'SUCCESS','Tag with Pre Intimation has been done successfully','success');
                        }	
                        else {
                            helper.showToast(component,event,'ERROR',response.getReturnValue(),'error');	    
                        }
                    }
                    component.find("overlayLib").notifyClose();
                    $A.util.addClass(spinner,"slds-hide");
                });  
                $A.enqueueAction(action);    
            }
        }
    },
    
    doGetMECPDoctorJS : function(component,event,helper) {
        if(event.keyCode == 13) {
            if(!$A.util.isEmpty(component.get("v.mecpName"))){
                var spinner = component.find("mySpinner");
                //$A.util.removeClass(spinner,"slds-hide");
                var action = component.get("c.doGetMecpDoctor");
                action.setParams({
                    "mecpName" : component.get("v.mecpName")
                }); 
                action.setCallback(this,function(response){
                    if(response.getState() === "SUCCESS") {
                        if(response.getReturnValue().status.includes("SUCCESS")) {
                            if(response.getReturnValue().listAccount.length == 0) {
                                component.set("v.showMessage",true); 
                                component.set("v.showTable",false);
                            }   
                            else {
                                component.set("v.showMessage",false);
                                component.set("v.showTable",true);
                                component.set('v.firstBlockColumns', [
                                    {label: 'Account Name', fieldName: 'accountName'},
                                    {label: 'Owner', fieldName: 'owner'}, 
                                    {label: 'Territory', fieldName: 'territory'},
                                    {label: 'Account ID', fieldName: 'accountId'},
                                    {label: 'Account Type', fieldName: 'accountType'},
                                    {label: 'Main Phone', fieldName: 'mainPhone'}
                                ]);  
                                component.set("v.data",null);
                                var data = [];
                                for(var i=0; i<response.getReturnValue().listAccount.length;i++) {
                                    var accountTerritory = '';
                                    if(!$A.util.isEmpty(response.getReturnValue().listAccount[i].Account_Territory__c))
                                        accountTerritory = response.getReturnValue().listAccount[i].Account_Territory__r.Name;
                                    var x = {
                                        'accountName' : response.getReturnValue().listAccount[i].Name,
                                        'owner' : response.getReturnValue().listAccount[i].Owner.Name,
                                        'territory' : accountTerritory,
                                        'accountId' : response.getReturnValue().listAccount[i].AccountNumber,
                                        'accountType' : response.getReturnValue().listAccount[i].Type,
                                        'mainPhone' : response.getReturnValue().listAccount[i].Phone,
                                        'id' : response.getReturnValue().listAccount[i].Id
                                    }	
                                    data.push(x);
                                    
                                }
                                
                                component.set("v.data",data);
                            }
                        }   
                        else {
                            helper.showToast(component,event,'ERROR',response.getTReturnValue().status,'error');   
                        }
                    }
                    else {
                        alert('ERROR');
                    }
                    $A.util.addClass(spinner,"slds-hide");
                });
                $A.enqueueAction(action);
            }
            else {
                helper.showToast(component,event,'ERROR','Please Fill Mecp Source','error');
            }
        }
        
    }
})