({
    doInit : function(component, event, helper) {
        /*var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();*/
        var toastEventProc = $A.get("e.force:showToast");
                toastEventProc.setParams({
                    "title": "Info",
                    "type": "info",
                    "duration": "5000",
                    "message": "Processing.."
                });
        toastEventProc.fire();
        console.log(component.get("v.recordId"));
        var action = component.get('c.sendPaymentLink');
        action.setParams({
            "LeadId" : component.get("v.recordId")
        });
        action.setCallback(this, function(a){
			//alert('>>>Success!', a.getReturnValue());
			
            var state = a.getState(); // get the response state
            $A.get("e.force:closeQuickAction").fire();
            if(a.getReturnValue() == "Success") {
				//alert('Success!', a.getReturnValue());
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success",
                    "type": "success",
                    "message": "Payment message has been sent successfully."
                });                
            }
            else if(a.getReturnValue() == 'Open') {

                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Info!",
                    "type": "info",
                    "message": "Open Stage cannot Generate Payment Link."
                });                
            }
            else{

                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "error",
                    "type": "error",
                    "message": a.getReturnValue()
                });
            }
            toastEvent.fire();
        });
        $A.enqueueAction(action);
        
        
    }
})