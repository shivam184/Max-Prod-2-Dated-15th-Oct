({
    doInit : function(component, event) {
        var action = component.get("c.sendSMS");
        action.setParams({

             recId : component.get("v.recordId")
        });
        
        action.setCallback(this, function(a) {
            if (a.getState() == 'SUCCESS' && a.getReturnValue()=='SMS send successfully'){
                var toast = $A.get("e.force:showToast");
                toast.setParams({
                    "type":"Success",
                    "title":"Success",
                    "message":a.getReturnValue(),
                });
                toast.fire();
            }
            else if(a.getReturnValue()=='Prescription not found'){
                
                 var toast = $A.get("e.force:showToast");
                toast.setParams({
                    "type":"Error",
                    "title":"Error",
                    "message":a.getReturnValue(), 
                });
                toast.fire();
                  
            }
            /*else if(a.getReturnValue()=='Please create vital records first'){
                
                 var toast = $A.get("e.force:showToast");
                toast.setParams({
                    "type":"Error",
                    "title":"Error",
                    "message":a.getReturnValue(), 
                });
                toast.fire();
                  
            }*/
            else if(a.getReturnValue()=='Record not found'){
                
                 var toast = $A.get("e.force:showToast");
                toast.setParams({
                    "type":"Error",
                    "title":"Error",
                    "message":a.getReturnValue(), 
                });
                toast.fire();
                  
            }
            else
            {
                toast.setParams({
                    "type":"Error",
                    "title":"Error",
                    "message":a.getError()[0].message,
                });
                
                toast.fire();
                
            }
            $A.get("e.force:closeQuickAction").fire() ;
        });
        
        $A.enqueueAction(action);
        
    },
    showToast : function(type,title,message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type":type
        });
        toastEvent.fire();
        
        
    }
    
})