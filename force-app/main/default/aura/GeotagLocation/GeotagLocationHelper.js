({
    saveData : function(component,event) {
        var spinner = component.find("mySpinner");
        $A.util.removeClass(spinner,"slds-hide");
        var action = component.get("c.saveDataApex");
        action.setParams({
            "latitude" : component.get("v.latitude"),
            "longitude" : component.get("v.longitude"),
            "recordId" : component.get("v.recordId")
        });
        action.setCallback(this,function(response){
            if(response.getState() === "SUCCESS") {
                if(response.getReturnValue().includes("SUCCESS")) {
                	this.showToast(component,event,'SUCCESS','Location has been captured successfully','success');
                }   
                else {
                    var res = response.getReturnValue().split(':');
                	this.showToast(component,event,'ERROR',res[1],'error');	    
                }
            }
            var dismissActionPanel = $A.get("e.force:closeQuickAction");
            dismissActionPanel.fire();
            $A.get('e.force:refreshView').fire();
            $A.util.addClass(spinner,"slds-hide");    
        });
        $A.enqueueAction(action);
    },
    
    showToast : function(component,event,title,message,type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type" : type
        });
        toastEvent.fire();
    }

})