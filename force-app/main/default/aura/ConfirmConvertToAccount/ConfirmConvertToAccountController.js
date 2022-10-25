({
    toggleDialog : function(component, event, helper) {
        helper.showHideModal(component);	
    },
    
    confirmConvert : function(component , event , helper ) {
        var spinner = component.find("spinner");
        $A.util.removeClass(spinner,"slds-hide");
        var action = component.get("c.confirmConvertApex");
        action.setParams({
            "beatPlanDetailId" : component.get("v.beatPlanDetailId")
		});
        action.setCallback(this,function(response){
            if(response.getState() === 'SUCCESS') {
                var cmpEvent = component.getEvent("startDayEvent");
                cmpEvent.fire();
                helper.showHideModal(component); 
                $A.util.addClass(spinner,"slds-hide");
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Sucess',
                    message: 'Contact has been converted successfully...',
                    type : 'success'
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
        
    }
})