({
    handleCancel : function(component,event,helper) {
        component.find("overlayLib").notifyClose();
    },
    
    handleProceed : function(component,event,helper) {
        if($A.util.isEmpty(component.get("v.selectedLead"))){
            document.getElementById("error1").style.display = "block";
        }else if($A.util.isEmpty(component.get("v.reason"))){
            document.getElementById("error2").style.display = "block";
        }
        else {
            var spinner = component.find("mySpinner");
            $A.util.removeClass(spinner,"slds-hide");
            var action = component.get("c.untag");
            action.setParams({
                "selectedLead" : component.get("v.selectedLead"),
                "selectedAdmissionId" : component.get("v.selectedAdmissionId"),
                "reason" : component.get("v.reason")
            });
            action.setCallback(this,function(response){
                if(response.getState() === "SUCCESS") {
                    if(response.getReturnValue().includes("SUCCESS")) {
                        var compEvent = $A.get("e.c:UpdateLeadMecpType");
                        compEvent.fire();
                        helper.showToast(component,event,'SUCCESS','Untagging has been done successfully','success');
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
})