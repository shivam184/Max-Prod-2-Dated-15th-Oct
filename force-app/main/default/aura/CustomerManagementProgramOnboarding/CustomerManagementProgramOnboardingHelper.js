({
    showToast : function(component,event,title,message,type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type" : type
        });
        toastEvent.fire();
    },
    doInitHelper : function(component,event) {
        //Set Gender Picklist
        var genderTypes = $A.get("$Label.c.Genders");
        component.set("v.listGender",genderTypes.split(';'));
        
        //Set Occupation
        var OccupationTypes = $A.get("$Label.c.Occupation");
        component.set("v.listOccupation",OccupationTypes.split(';'));
        
        var VisitedToMaxHospital = $A.get("$Label.c.Visited_To_Max_Hospital");
        component.set("v.listVisitedToMaxHospital",VisitedToMaxHospital.split(';'));
    },
    
    doAPIcallout : function(component, event){
        
        if(!$A.util.isEmpty(component.get("v.lead.Passport_No__c")) && component.get("v.lead.Passport_No__c").length <= 20) {
            component.set('v.showSpinner',true);
            // component.set('v.lead',{});
            
            
            
            var action = component.get('c.searchinSalesforce');
            action.setParams({
                mobileNo : component.get("v.lead.Passport_No__c")
            });
            action.setCallback(this, function(response){
                if(response.getState()==='SUCCESS'){
                    
                    if(response.getReturnValue()!=null && !$A.util.isEmpty(response.getReturnValue())){
                        var response = response.getReturnValue();
                        component.set('v.patietnWrapper',response);
                        if(response.isExisiting==true ){
                            component.set('v.lead',response.leadObj);
                        }
                        
                        var test=true;
                        if(response.isNewPat==true && test==true){
                            this.setValuesFromCustAct(component,event);
                            component.set("v.isStop",false);
                            test=false;
                        }
                        
                        component.set('v.showSpinner',false);
                    }
                }
                else if(response.getState()==='ERROR'){
                    alert('An error has occurred. Please refresh the page');
                }
                    else if(response.getState()==='INCOMPLETE'){
                        alert('An error has occurred. Please refresh the page');
                    }
            });
            $A.enqueueAction(action);
            
        }
        else {   
        }
    },
    setValuesFromCustAct : function(component, event){ 
        
        var action = component.get('c.setMasterValues');
        action.setParams({
            'recordId' : component.get('v.recordId'),
            'ld' : component.get('v.lead')
        });
        action.setCallback(this, function(response){
            if(response.getState()==='SUCCESS'){
                
                if(response.getReturnValue()!=null)
                    component.set('v.lead',response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
        
    },
    validateDetails: function(component, event){
        
        var action = component.get("c.saveMemberDetails");
        // alert(component.get("v.referToMax"));
        action.setParams({ 
            "leadObj": JSON.stringify(component.get("v.lead")),
            "refermax": component.get("v.referToMax"),
            "recordId": component.get("v.recordId")
            
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var responseObj = response.getReturnValue().Id;
            
            //  alert(state);
            if (state === "SUCCESS" && response.getReturnValue()) {
                //   alert("success");
                $A.get("e.force:closeQuickAction").fire() 
                var toast = $A.get("e.force:showToast");
                toast.setParams({
                    "recordId": response.getReturnValue(),
                    "type":"Success",
                    "title":"Success",
                    "message":"Member added successfully!",
                    "duration":2000
                });
                
                toast.fire();
            }
        });
        $A.enqueueAction(action);
        
        
    }
})