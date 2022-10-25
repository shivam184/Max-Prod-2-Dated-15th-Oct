({
    handleCancel : function(component,event,helper) {
        component.find("overlayLib").notifyClose();
    },
    
    handleProceed : function(component,event,helper) {        
        if($A.util.isEmpty(component.get("v.selectedMecpSource"))){
            document.getElementById("error1").style.display = "block";
        }
        else{
            component.set('v.showSpinner', true);
            var compEvent = $A.get("e.c:UpdateInternationalTagging");
            compEvent.setParams({
                'selectedAck'  :  component.get("v.selectedAdmissionId"),
                'selectedLead' : component.get("v.selectedLeadId"),
                'selectedDoctor' : component.get("v.selectedMecpSource")
            });
            compEvent.fire();
            component.find("overlayLib").notifyClose();                  
        }        
    },
    
    doGetMECPDoctorJS : function(component,event,helper) {
        if(event.keyCode == 13) {
            if(!$A.util.isEmpty(component.get("v.mecpName"))){
                component.set('v.showSpinner', true);
                //var spinner = component.find("mySpinner");
                //$A.util.removeClass(spinner,"slds-hide");
                var action = component.get("c.doGetMecpDoctor");
                action.setParams({
                    "mecpName" : component.get("v.mecpName")
                }); 
                action.setStorable();
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
                        var errors = action.getError();
                        alert(errors[0].message);
                    }
                    component.set('v.showSpinner', false);
                });
                $A.enqueueAction(action);
            }
            else {
                helper.showToast(component,event,'ERROR','Please Fill Mecp Source','error');
            }
        }
        
    }
})