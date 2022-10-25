({
    doInit : function(component, event, helper) {
        //var loadTime = window.performance.timing.domContentLoadedEventEnd- window.performance.timing.navigationStart;
        //alert(loadTime);
        component.set("v.showSpinner",true);
        console.log(component.get("v.mobileNo"));
        if($A.util.isEmpty(component.get("v.mobileNo"))) {
            component.set("v.noMobile",true);
        }
        else {
            var action = component.get("c.getPatientNameForMobileNumber");
            if(component.get("v.isPhoneSearch"))
                action.setParams({
                    "searchId" : component.get("v.mobileNo"),
                    "isPhoneSearch" : true
                });
            else 
                action.setParams({
                    "searchId" : component.get("v.mobileNo"),
                    "isPhoneSearch" : false
                });    
            action.setCallback(this,function(res){
                var state = res.getState();
                var error = res.getError();
                var retVal = res.getReturnValue().listPatient;
                console.log(res.getReturnValue());
                console.log('&&&&&&&&&&&&&&&&&&&&&&&'+res.getReturnValue().listPatient.length);
                if(res.getReturnValue().listPatient.length > 0){
                    if(res.getReturnValue().listPatient.length == 1){
                    	component.set("v.listPatient",res.getReturnValue().listPatient);
                        console.log('################'+res.getReturnValue().listPatient);
                        //alert(component.get("v.selectedValue"));
                	}
                    else if(res.getReturnValue().listPatient.length > 1){
                        console.log("Inside");
                        //alert(JSON.stringify(res.getReturnValue().listPatient));
                        //alert(JSON.stringify(res.getReturnValue().listCallDetails));
                        component.set("v.listPatient",res.getReturnValue().listPatient);
                        console.log('################else'+res.getReturnValue().listPatient);
                        component.set("v.listPatientAlternate",res.getReturnValue().listPatient);
                        component.set("v.listCallDetails",res.getReturnValue().listCallDetails);
                    }
                }
                else
                    component.set("v.listPatient",res.getReturnValue().listLeads);
                console.log('################elseelse22'+JSON.stringify(res.getReturnValue().listLeads));
                
            });
            $A.enqueueAction(action);
            
        }
        component.set("v.showSpinner",false);
    },
    
    handleChange : function(component, event, helper) {
        //alert(event.getSource().get("v.value"));
        var selectedOptionId = component.find("patientList").get("v.value");
        //alert(selectedOptionId);
        //var selectedOptionName = component.find("patientList").get("v.text");
        component.set("v.selectedValue",selectedOptionId);
        //component.set("v.selectedValue.Name",selectedOptionName);
        //alert(component.get("v.selectedValue.Id"));
        //alert(component.get("v.selectedValue.Name"));
    },
    
    doProceed : function(component, event, helper) {
        component.set("v.showSpinner",true);
        	//alert("dff");
        component.set("v.isProceed", true);
        component.set("v.showSpinner",false);
    }
})