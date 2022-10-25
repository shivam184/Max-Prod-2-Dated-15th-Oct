({
    doInit : function(component, event, helper) {
        var spinner = component.find("v.mySpinner");
        $A.util.removeClass(spinner,"slds-hide");
        var action = component.get("c.doGetMecpDoctor");
        action.setParams({
            "mecpName" : component.get("v.mecpName")
        });
        action.setCallback(this,function(response){
            if(response.getState() === "SUCCESS") {
                if(response.getReturnValue().status.includes("SUCCESS")) {
                    component.set("v.listMECP",response.getReturnValue().listAccount);
                    $A.util.addClass(spinner,"slds-hide");
                }   
                else {
                    helper.showToast(component,event,'ERROR',response.getReturnValue().status,'error');    
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    getAccountId : function(component,event,helper) {
        var itemId = event.target.getAttribute('id');
        var style = event.target.getAttribute('style');
        var appEvent = $A.get("e.c:PassMECPId");
        appEvent.setParams({
            "message" : itemId,
            "message1" : style});
        appEvent.fire();
        component.find("overlayLib").notifyClose();
    }
})