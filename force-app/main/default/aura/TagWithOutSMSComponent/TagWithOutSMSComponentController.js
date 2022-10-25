({
    handleSave : function(component, event, helper) {        
        if($A.util.isEmpty(component.get("v.selecteAccount")))
            document.getElementById("error1").style.display = "block";
        else if($A.util.isEmpty(component.get("v.remarks")))
            document.getElementById("error2").style.display = "block";
            else{                              
                component.set('v.showSpinner', true);
                
                var action = component.get("c.TagWithOutSMSApex");
                action.setParams({
                    "admaAckOpTransId" : component.get("v.selectedAdmissionId"),
                    "HCFId" : component.get("v.selecteAccount"),
                    "Rmrk" : component.get("v.remarks")
                });
                action.setCallback(this, function(response){
                    var state = response.getState();
                    if(state==="SUCCESS"){
                        var compEvent = $A.get("e.c:UpdateWithoutSMSEvent");
                        compEvent.fire();
                        if(response.getReturnValue().includes("SUCCESS")) {                          
                            helper.showToast(component,event,'SUCCESS','Tag without Pre Intimation done successfully','success');
                        }	
                        else {
                            helper.showToast(component,event,'ERROR',response.getReturnValue(),'error');	    
                        }
                    }
                    component.find("overlayLib").notifyClose(); 
                });
                component.set('v.showSpinner', true);
                $A.enqueueAction(action);
            }
    },
    
    handleCancel : function(component,event,helper){
        component.find("overlayLib").notifyClose();    
    },
    
    calculateLength : function(component,event,helper) {
        if(component.get("v.remarks").length >= 255) {
        	event.preventDefault();   
        }
    }
})