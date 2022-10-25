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
        var action = component.get('c.sendSMS2');
        action.setParams({
            "leadid" : component.get("v.recordId")
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
                    "message": "SMS Has Been Sent"
                });
                
                 
            }
            else {

                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "error",
                    "type": "error",
                    "message": "Error"
                });
            }
            
           toastEvent.fire();             
        }
                           
                          )
          $A.enqueueAction(action);
    }
})