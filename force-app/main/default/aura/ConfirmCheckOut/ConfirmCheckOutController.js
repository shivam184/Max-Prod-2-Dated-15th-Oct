({
    toggleDialog : function(component, event, helper) {
        helper.showHideModal(component);	
    },
    saveData : function(component,event) {
        console.log('component.get'+component.get("v.latitude"));
               var spinner = component.find("spinner");
        $A.util.removeClass(spinner,"slds-hide");
        var action = component.get("c.getAddress");
        action.setParams({
            "lat" : component.get("v.latitude"),
            "lon" : component.get("v.longitude")
        });
        action.setCallback(this,function(response){
            console.log('resp == '+response.getReturnValue());
            component.set("v.Address",response.getReturnValue());
            if(response.getState() === 'SUCCESS') {
               
                //var cmpEvent = component.getEvent("startDayEvent");
                //cmpEvent.fire();
               // helper.showHideModal(component); 
                $A.util.addClass(spinner,"slds-hide");
                var toastEvent = $A.get("e.force:showToast");
              /*  toastEvent.setParams({
                    title : 'Sucess',
                    message: 'You Have Checked In Successfully...',
                    type : 'success'
                });
                toastEvent.fire();*/
            }
        });
        $A.enqueueAction(action);// var mySpinner = component.find("mySpinner");
       
    },
    confirmCheckOut : function(component , event , helper ) {
         alert('confirmCheckIn');
         alert(component.get("v.longitude"));
         alert(component.get("v.latitude"));
         alert(component.get("v.Address"));   
        if($A.util.isEmpty(component.get("v.checkoutRemarks"))) {
            document.getElementById("errorNew").style.display = "block";
            return;
        }
        
        if(component.get("v.checkTask")) {
            component.set("v.showCheckout",false);
            component.set("v.showTask",true);
            return;
        }
        
        if(component.get("v.checkEvent")) {
            component.set("v.showCheckout",false);
            component.set("v.showEvent",true);
            return;
        }
        /*
        if(component.get("v.checkTask")) {
            if($A.util.isEmpty(component.get("v.selectedTask"))) {
            	component.find("taskId").showHelpMessageIfInvalid();
                count = 1;
            } 
            if($A.util.isEmpty(component.get("v.taskDueDate"))) {
            	component.find("taskDateId").showHelpMessageIfInvalid();
                count = 1;
            }
        }
        if(component.get("v.checkEvent")) {
            if($A.util.isEmpty(component.get("v.selectedEvent"))) {
            	component.find("eventId").showHelpMessageIfInvalid();
                count = 1;
            } 
            if($A.util.isEmpty(component.get("v.eventDueDate"))) {
            	component.find("eventDateId").showHelpMessageIfInvalid();
                count = 1;
            }
        }
        if(count == 0) {
            var spinner = component.find("spinner");
            $A.util.removeClass(spinner,"slds-hide");
            var action = component.get("c.createCheckOut");
            action.setParams({
                "beatPlanDetailId" : component.get("v.beatPlanDetailId"),
                "beatDayId" : component.get("v.beatDayId"),
                "longitude" : component.get("v.longitude"),
                "latitude" : component.get("v.latitude"),
                "checkoutRemarks" : component.get("v.checkoutRemarks"),
                "checkTask" : component.get("v.checkTask"),
                "checkEvent" : component.get("v.checkEvent"),
                "selectedTask" : component.get("v.selectedTask"),
                "taskDueDate" : component.get("v.taskDueDate"),
                "selectedEvent" : component.get("v.selectedEvent"),
                "eventDueDate" : component.get("v.eventDueDate")
			});
            action.setCallback(this,function(response){
                if(response.getState() === 'SUCCESS') {
                    alert(response.getState());
                    var cmpEvent = component.getEvent("startDayEvent");
                    cmpEvent.fire();
                    helper.showHideModal(component); 
                    $A.util.addClass(spinner,"slds-hide");
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Success',
                        message: 'You have checked out Successfully...',
                        type : 'success'
                    });
                    toastEvent.fire();
                }
                else {
                    alert('Blank');
                	$A.util.addClass(spinner,"slds-hide");    
                }
            });
            //$A.enqueueAction(action);    
        }
        */
    },
    
    doBack : function(component,event,helper) {
        component.set("v.showCheckout",true);
        component.set("v.showTask",false);
        component.set("v.showEvent",false);
    },
    
    doNext : function(component,event,helper) {
        if(component.get("v.checkTask")) {
            var count = 0;
            if($A.util.isEmpty(component.get("v.selectedTask"))) {
                component.find("taskId").showHelpMessageIfInvalid();
                count = 1;
            }
            if($A.util.isEmpty(component.get("v.taskDueDate"))) {
                component.find("taskDateId").showHelpMessageIfInvalid();
                count = 1;
            }
            if(count == 1)
                return;
            else {
                component.set("v.showEvent",true);
                component.set("v.showTask",false); 
            }
        }
    },
    
    doBackEvent : function(component,event,helper) {
        if(component.get("v.checkTask")) 
            component.set("v.showTask",true);
        else
            component.set("v.showCheckout",true);
        
        component.set("v.showEvent",false);
        
    },
    
    doSave : function(component,event,helper) {
        var count = 0;
        if(component.get("v.showCheckout")) {
            if($A.util.isEmpty(component.get("v.checkoutRemarks"))) {
                document.getElementById("errorNew").style.display = "block";
                count = 1;
            }   
        }
        
        if(component.get("v.checkTask") && component.get("v.showTask")) {
            if($A.util.isEmpty(component.get("v.selectedTask"))) {
                component.find("taskId").showHelpMessageIfInvalid();
                count = 1;
            }
            if($A.util.isEmpty(component.get("v.taskDueDate"))) {
                component.find("taskDateId").showHelpMessageIfInvalid();
                count = 1;
            }
        }	
        
        if(component.get("v.checkEvent") && component.get("v.showEvent")) {
            if($A.util.isEmpty(component.get("v.selectedEvent"))) {
                component.find("eventId").showHelpMessageIfInvalid();
                count = 1;
            } 
            if($A.util.isEmpty(component.get("v.eventDueDate"))) {
                component.find("eventDateId").showHelpMessageIfInvalid();
                count = 1;
            }
        }	
        
        
        if(count == 0) {
            if($A.util.isEmpty(component.get("v.taskDueDate")))
                component.set("v.taskDueDate",component.get("v.todayDate"));
            if($A.util.isEmpty(component.get("v.eventDueDate")))
                component.set("v.eventDueDate",component.get("v.todayDate"));
            var spinner = component.find("spinner");
            $A.util.removeClass(spinner,"slds-hide");
            var action = component.get("c.createCheckOut");
            action.setParams({
                "beatPlanDetailId" : component.get("v.beatPlanDetailId"),
                "beatDayId" : component.get("v.beatDayId"),
                "longitude" : component.get("v.longitude"),
                "latitude" : component.get("v.latitude"),
                "checkoutRemarks" : component.get("v.checkoutRemarks"),
                "checkTask" : component.get("v.checkTask"),
                "checkEvent" : component.get("v.checkEvent"),
                "selectedTask" : component.get("v.selectedTask"),
                "selectedEvent" : component.get("v.selectedEvent"),
                "taskDueDate" : component.get("v.taskDueDate"),
                "eventDueDate" : component.get("v.eventDueDate")
                
            });
            action.setCallback(this,function(response){
                if(response.getState() === 'SUCCESS') {
                    $A.get('e.force:refreshView').fire();
                    var cmpEvent = component.getEvent("startDayEvent");
                    cmpEvent.fire();
                    helper.showHideModal(component); 
                    $A.util.addClass(spinner,"slds-hide");
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Success',
                        message: 'You have checked out Successfully...',
                        type : 'success'
                    });
                    toastEvent.fire();
                }
                else {
                    alert('Error');
                    $A.util.addClass(spinner,"slds-hide");    
                }
            });
            $A.enqueueAction(action);	  
        }
    }
})