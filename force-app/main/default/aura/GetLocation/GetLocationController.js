({
    handleCancel : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire(); 
    },
    
    handleLightningCards : function(component, event, helper) {
        
        var address='';
        if(component.get("v.accSimpleRecord.BillingStreet") != null) {
            address += component.get("v.accSimpleRecord.BillingStreet") + ',';
        }
        if(component.get("v.accSimpleRecord.BillingCity") != null) {
            address += component.get("v.accSimpleRecord.BillingCity") + ',';
        }
        if(component.get("v.accSimpleRecord.BillingState") != null) {
            address += component.get("v.accSimpleRecord.BillingState") + ',';
        }
        if(component.get("v.accSimpleRecord.BillingPostalCode") != null) {
            address += component.get("v.accSimpleRecord.BillingPostalCode") + ',';
        }
        if(component.get("v.accSimpleRecord.BillingCountry") != null) {
            address += component.get("v.accSimpleRecord.BillingCountry");
        }
        //alert('address-->'+address.length);
        if(address.length > 0)  
            component.set("v.billingAddress",address);
        
        if(address.length == 0 && component.get("v.currentLocation") == false) {
            document.getElementById("error1").style.display = "block";
        }
        else if(component.get("v.currentLocation") == true) {
            //alert("checkbox");
            if (navigator.geolocation) { 
                navigator.geolocation.getCurrentPosition(function(e) {
                    
                    component.set("v.longitude",e.coords.longitude);
                    component.set("v.latitude",e.coords.latitude);
                    //alert('longitude-->'+component.get("v.longitude"));
                    //alert('latitude-->'+component.get("v.latitude"));
                    helper.getCurrentLocationAddress(component,event);
                }, function(error) {
                    var msg = '';
                    switch(error.code) {
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
                            msg= "An unknown error occurred.";
                            break;
                    }
                    
                    //helper.showError(msg);
                    //$A.util.addClass(spinner, "slds-hide");
                });
            }
        }
            else {
                //alert("billing Addrerss");  
                //alert('Billing Address-->'+component.get("v.billingAddress"));
                var spinner = component.find("mySpinner");
                $A.util.removeClass(spinner,"slds-hide");
                var action = component.get("c.getLocationFromBillingAddress");
                action.setParams({
                    "billingAddress" : component.get("v.billingAddress")
                });
                action.setCallback(this,function(response){
                    if(response.getState() === 'SUCCESS') {
                        //alert('Value-->'+response.getReturnValue());
                        var res = response.getReturnValue().split("*");
                        //alert('0-->'+res[0]);
                        //alert('1-->'+res[1]);
                        //alert('2-->'+res[2]);
                        component.set("v.latitude",res[0]);
                        component.set("v.longitude",res[1]);
                        component.set("v.address",res[2]);
                        component.set("v.showLightningCard",false);
                        $A.util.addClass(spinner,"slds-hide");
                    } 
                    else {
                        $A.get("e.force:closeQuickAction").fire();
                        var showToast = $A.get("e.force:showToast"); 
                        showToast.setParams({ 
                            'title' : 'Error!', 
                            'message' : 'Something Went Wrong...Try Again With Correct Billing Address',
                            'type' : 'error'
                        });  
                        showToast.fire();
                    }
                });
                $A.enqueueAction(action);
                component.set("v.showLightningCard",false);
            }
    },
    
    handleBack : function(component,event,helper) {
        component.set("v.showLightningCard",true);
        component.set("v.longitude",null);
        component.set("v.latitude",null);
        component.set("v.address",null);
    },
    
    handleSave : function(component,event,helper) {
        if(component.get("v.currentLocation") == true) {
            var spinner = component.find("mySpinner");
            $A.util.removeClass(spinner,"slds-hide");
            var action = component.get("c.saveLocationApex");
            action.setParams({
                "accId" : component.get("v.recordId"),
                "lat" : component.get("v.latitude"),
                "lon" : component.get("v.longitude"),
                "address" : component.get("v.address")
            });
            action.setCallback(this,function(response){
                if(response.getState() === 'SUCCESS') {
                    $A.get("e.force:closeQuickAction").fire();
                    $A.get('e.force:refreshView').fire();
                    $A.util.addClass(spinner,"slds-hide");
                    var showToast = $A.get("e.force:showToast"); 
                    showToast.setParams({ 
                        'title' : 'Success!', 
                        'message' : 'Your Current Location Captured Successfully.',
                        'type' : 'success'
                    });  
                    showToast.fire();  
                }
                else {
                    $A.get("e.force:closeQuickAction").fire();
                    var showToast = $A.get("e.force:showToast"); 
                    showToast.setParams({ 
                        'title' : 'Error!', 
                        'message' : 'Something Went Wrong...Try Again.',
                        'type' : 'error'
                    });  
                    showToast.fire();      
                }
            });
            $A.enqueueAction(action);    
        }
        else {
            var spinner = component.find("mySpinner");
            $A.util.removeClass(spinner,"slds-hide");
            var action = component.get("c.saveBillingLocationApex");
            action.setParams({
                "accId" : component.get("v.recordId"),
                "lat" : component.get("v.latitude"),
                "lon" : component.get("v.longitude"),
                "address" : component.get("v.address"),
                "billingStreet" : component.get("v.accSimpleRecord.BillingStreet"),
                "billingCity" : component.get("v.accSimpleRecord.BillingCity"),
                "billingState" : component.get("v.accSimpleRecord.BillingState"),
                "billingCountry" : component.get("v.accSimpleRecord.BillingCountry"),
                "billingPostalCode" : component.get("v.accSimpleRecord.BillingPostalCode")
            });
            action.setCallback(this,function(response){
                if(response.getState() === 'SUCCESS') {
                    $A.get("e.force:closeQuickAction").fire();
                    $A.get('e.force:refreshView').fire();
                    $A.util.addClass(spinner,"slds-hide");
                    var showToast = $A.get("e.force:showToast"); 
                    showToast.setParams({ 
                        'title' : 'Success!', 
                        'message' : 'Your Billing Address Location Captured Successfully.',
                        'type' : 'success'
                    });  
                    showToast.fire();  
                }
                else {
                    $A.get("e.force:closeQuickAction").fire();
                    var showToast = $A.get("e.force:showToast"); 
                    showToast.setParams({ 
                        'title' : 'Error!', 
                        'message' : 'Something Went Wrong...Try Again.',
                        'type' : 'error'
                    });  
                    showToast.fire();      
                }
            });
            $A.enqueueAction(action);
        }
    }
})