({
    showToast : function(component,event,title,message,type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : title,
            message: message,
            type: type
            
        });
        toastEvent.fire();
    },
    
    doProceed : function(component,event) {
        var spinner = component.find("mySpinner");
        $A.util.removeClass(spinner,"slds-hide");
        var action = component.get("c.tagWithoutPreIntimationApex");
        action.setParams({
            "selectedLead" : component.get("v.selectedLead"),
            "selectedAdmissionId" : component.get("v.selectedAdmissionId"),
            "remark" : component.get("v.remarks"),
            "couponCode" : component.get("v.couponCode")
        });
        action.setCallback(this,function(response){
            if(response.getState() === "SUCCESS") {
                if(response.getReturnValue().includes("SUCCESS")) {
                    var compEvent = $A.get("e.c:UpdateLeadMecpType");
                    compEvent.fire();
                    this.showToast(component,event,'SUCCESS','Tag W/O Pre Intimation has been done successfully','success');
                }	
                else {
                    this.showToast(component,event,'ERROR',response.getReturnValue(),'error');	    
                }
            }
            component.find("overlayLib").notifyClose();
            $A.util.addClass(spinner,"slds-hide");
        });  
        $A.enqueueAction(action);    
    }
    
})