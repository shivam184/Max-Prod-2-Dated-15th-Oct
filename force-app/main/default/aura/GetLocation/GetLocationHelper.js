({
    getCurrentLocationAddress : function(component,event) {
        var spinner = component.find("mySpinner");
        $A.util.removeClass(spinner,"slds-hide");
        var action = component.get("c.fetchLocationAddress");
        action.setParams({
            "lat" : component.get("v.latitude"),
            "lon" : component.get("v.longitude")
        });
        action.setCallback(this,function(response){
            if(response.getState() === 'SUCCESS') {
                if(response.getReturnValue() === 'Latitude and Longitude Not Captured Successfully') {
                    var showToast = $A.get("e.force:showToast"); 
                    showToast.setParams({ 
                        'title' : 'Error!', 
                        'message' : response.getReturnValue(),
                        'type' : 'error'
                    });  
                    showToast.fire();     
                } 
                else {
                    //alert(response.getReturnValue());
                    component.set("v.address",response.getReturnValue());
                    component.set("v.showLightningCard",false);
                    $A.util.addClass(spinner,"slds-hide");
                }
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
})