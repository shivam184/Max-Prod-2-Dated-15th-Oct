({
    getLocation: function (component, event) {

        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(function (e) {
                component.set("v.longitude", e.coords.longitude);
                component.set("v.latitude", e.coords.latitude);
            }, function (error) {
                var msg = '';
                switch (error.code) {
                    case error.PERMISSION_DENIED:
                        msg = "User denied the request for Geolocation.";
                        break;
                    case error.POSITION_UNAVAILABLE:
                        msg = "Location information is unavailable.";
                        break;
                    case error.TIMEOUT:
                        msg = "The request to get user location timed out.";
                        break;
                    case error.UNKNOWN_ERROR:
                        msg = "An unknown error occurred.";
                        break;
                }
                msg=msg +' Please Check your Location Settings.';
                alert(msg);
            });
        }
    },
    /*
    saveData : function(component,event) {
        var mySpinner = component.find("mySpinner");
        $A.util.removeClass(mySpinner,"slds-hide");   
        var action = component.get("c.getLocationApex");
        action.setParams({
            "recordId" : event.getSource().get("v.accesskey"),
            "latitude" : component.get("v.latitude"),
            "longitude" : component.get("v.longitude")
        });
        action.setCallback(this,function(response){
            if(response.getState() === "SUCCESS") {
                this.doInitHelper(component,event);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Location has been updated successfully.",
                    "type" : "success"
                });
                toastEvent.fire();
            }
            $A.util.addClass(mySpinner,"slds-hide");
        });
        $A.enqueueAction(action);
    },
    */
    doInitHelper: function (component, event) {
        if ($A.get("$Browser.formFactor") == 'PHONE' || $A.get("$Browser.formFactor") == 'TABLET')
            component.set("v.isDesktop", false);

        var mySpinner = component.find("mySpinnner");
        $A.util.removeClass(mySpinner, "slds-hide");
        var action = component.get("c.doInitApex");
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                component.set("v.showTodayPlan", response.getReturnValue().showTodayPlan);
                component.set("v.showStartDay", response.getReturnValue().showStartDay);
                component.set("v.showEndDay", response.getReturnValue().showEndDay);
                component.set("v.endDay", response.getReturnValue().endDay);
                component.set("v.officeVisit", response.getReturnValue().officeVisit);
                component.set("v.disabledCheckIn", response.getReturnValue().disabledCheckIn);
                component.set("v.distanceTravelled", response.getReturnValue().distanceTravelled);
                component.set("v.listBeatPlanDetails", response.getReturnValue().listBeatPlanDetails);
                component.set("v.listCompletedBeatPlanDetails", response.getReturnValue().listCompletedBeatPlanDetails);
                component.set("v.beatPlanId", response.getReturnValue().beatPlanId);
                component.set("v.beatDayId", response.getReturnValue().beatDayId);
                component.set("v.ownerName", response.getReturnValue().ownerName);
                component.set("v.todayDate", response.getReturnValue().todayDate);
                component.set("v.listTaskSubject", response.getReturnValue().listTaskSubject);
                component.set("v.listEventSubject", response.getReturnValue().listEventSubject);
                $A.util.addClass(mySpinner, "slds-hide");
            }
            else {
                // alert('Error');	    
            }
        });
        $A.enqueueAction(action);
    },

    showToast: function (component, event) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "ERROR!",
            "message": "You can't checkin without an address",
            "type": "error"
        });
        toastEvent.fire();
    }
})