({
    doInit : function(component, event, helper) {
        
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Info',
            message: 'Processing..',
            duration:' 5000',
            key: 'info_alt',
            type: 'info',
            mode: 'dismissible'
        });
        toastEvent.fire();
        var action = component.get('c.callDoctorPatient');
        action.setParams({
            "LeadId" : component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            var state = response.getState(); // get the response state
            $A.get("e.force:closeQuickAction").fire();
            if(state == 'SUCCESS') {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Success",
                    message: "Call has been made successfully " + response.getReturnValue(),
                    type: 'success',
                    duration:' 5000',
                    mode: 'pester'
                });
                toastEvent.fire();
                
            }
            if(state != 'SUCCESS') {
                //$A.get("e.force:closeQuickAction").fire();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Error",
                    message: "This is an error message " + response.getReturnValue(),
                    type: 'error',
                    duration:' 5000',
                    mode: 'pester'
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
    myAction : function(component, event, helper) {
        
    }
})