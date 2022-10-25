({
    toggleDialog : function(component, event, helper) {
        helper.showHideModal(component);	
    },
    ViewAddress : function(component, event, helper) {
        alert(component.get("v.Address"));
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
    
    
    confirmCheckIn : function(component , event , helper ) {
      //  alert('confirmCheckIn');
        // alert(component.get("v.longitude"));
         //alert(component.get("v.latitude"));
         //alert(component.get("v.Address"));      
        if(component.get("v.longitude") != undefined || component.get("v.latitude") != undefined)
        {
           //  alert('confirmCheckIn undefined');
        var spinner = component.find("spinner");
        $A.util.removeClass(spinner,"slds-hide");
        var action = component.get("c.createCheckIn");
        action.setParams({
            "beatDayId" : component.get("v.beatDayId"),
            "beatPlanDetailId" : component.get("v.beatPlanDetailId"),
            "longitude" : component.get("v.longitude"),
            "latitude" : component.get("v.latitude")
        });
        action.setCallback(this,function(response){
            if(response.getState() === 'SUCCESS') {
                var cmpEvent = component.getEvent("startDayEvent");
                cmpEvent.fire();
                helper.showHideModal(component); 
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
        $A.enqueueAction(action);
        }
        else{
                            var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Error',
                    message: 'Please check your location permission',
                    type : 'error'
                });
                toastEvent.fire();
        }
    }
})