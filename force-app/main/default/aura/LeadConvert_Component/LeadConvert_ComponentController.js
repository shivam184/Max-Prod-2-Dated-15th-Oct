({
    doInit : function(component, event, helper){
        var action = component.get("c.doInitApex");
        action.setParams({
            "leadId": component.get("v.recordId")  
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state==="SUCCESS" && response.getReturnValue().status==="SUCCESS"){
                if(response.getReturnValue().lead.Stage__c == 'Qualified'){
                    component.set("v.wrapperObj",response.getReturnValue());
                    component.set("v.disableAccLookupBox",true);
                    component.set("v.disableContLookupBox",true);
                    component.set("v.disableOppLookupBox",true);
                    var opts = [];
                    var res = response.getReturnValue().salutation;
                    for(var i=0;i< res.length;i++){
                        opts.push({
                            "class": "optionClass", 
                            label: res[i], 
                            value: res[i]
                        });
                    }
                    component.set("v.options",opts);
                }else{
                    helper.showToast(component,event,'Error!','error','Only Qualified Lead can be converted.');
                }
            }else{
                helper.showToast(component,event,'Error!','error',response.getReturnValue().status);
            }
        });
        $A.enqueueAction(action);
    },
    
    populateAccount : function(component, event, helper){
        if(component.find("exisAcc").get("v.checked")){
            component.find("exisAcc").set("v.checked",false);
            component.find("newAcc").set("v.checked",true);
            component.set("v.disableAccLookupBox",true);
            component.set("v.disableAccBox",false);
            document.getElementById("error2").style.display = "none";
            
        }
        
    },
    onExisting: function(component, event, helper){
        if(component.find("newAcc").get("v.checked")){
            component.find("newAcc").set("v.checked",false);
            component.find("exisAcc").set("v.checked",true);
            component.set("v.disableAccLookupBox",false);
            component.set("v.disableAccBox",true);
        }
    },
    
    createNewContact : function(component,event,helper){
        if(component.find("exisCon").get("v.checked")){
            component.find("newCon").set("v.checked",true);
            component.find("exisCon").set("v.checked",false);
            component.set("v.disableContBox",false);
            component.set("v.disableContLookupBox",true);
            document.getElementById("error4").style.display = "none";
        }
        if(component.find("conchk").get("v.checked")){
            component.find("conchk").set("v.checked",false);
        }
    },
    
    existingContact: function(component, event, helper){
        if(component.find("newCon").get("v.checked")){
            component.find("newCon").set("v.checked",false);
            component.find("exisCon").set("v.checked",true);
            component.set("v.disableContBox",true);
            component.set("v.disableContLookupBox",false);
        }
        if(component.find("conchk").get("v.checked")){
            component.find("conchk").set("v.checked",false);
        }
    },
    
    createNewOpportunity : function(component,event,helper){
        if(component.find("exisOpp").get("v.checked")){
            component.find("newOpp").set("v.checked",true);
            component.find("exisOpp").set("v.checked",false);
            component.set("v.disableOppLookupBox",true);
            component.set("v.disableOppBox",false);
            document.getElementById("error6").style.display = "none";
        }
        if(component.find("oppchk").get("v.checked")){
            component.find("oppchk").set("v.checked",false);
        }
    },
    
    existingOpportunity: function(component, event, helper){
        if(component.find("newOpp").get("v.checked")){
            component.find("newOpp").set("v.checked",false);
            component.find("exisOpp").set("v.checked",true);
            component.set("v.disableOppLookupBox",false);
            component.set("v.disableOppBox",true);
            component.set("v.disableBox",false);
            
        }
        if(component.find("oppchk").get("v.checked")){
            component.find("oppchk").set("v.checked",false);
        }
    },
    
    disableRadio: function(component,event,helper){
        if(component.find("conchk").get("v.checked")){
            component.find("newCon").set("v.checked",false);
            component.find("exisCon").set("v.checked",false);
            component.set("v.disableConBox",true);
        }else{
            component.find("newCon").set("v.checked",true);
            component.set("v.disableConBox",false);
            component.set("v.disableContBox",false);
            component.set("v.disableContLookupBox",true);
        }
    },
    
    disableOppRadio: function(component ,event, helper){
        if(component.find("oppchk").get("v.checked")){
            component.find("newOpp").set("v.checked",false);
            component.find("exisOpp").set("v.checked",false);
            component.set("v.disableBox",true);
        }else{
            component.find("newOpp").set("v.checked",true);
            component.set("v.disableBox",false);
        }
    },
    
    convertLead: function(component, event, helper){
        var wrap = component.get("v.wrapperObj");
        if(!helper.chechValidation(component,event,wrap)){
            var spinner = component.find("mySpinner");
            $A.util.removeClass(spinner,"slds-hide");
            wrap.isOppCreate = component.find("oppchk").get("v.checked");
            wrap.isConCreate = component.find("conchk").get("v.checked");
            wrap.salu = component.find("select").get("v.value");
            var action = component.get("c.convertLeadApex");
            action.setParams({
                "jsonWrap" :JSON.stringify(wrap),
                "leadId" : component.get("v.recordId")
            });
            action.setCallback(this,function(response){
                var state = response.getState();
                if(state==="SUCCESS" && response.getReturnValue().status==="SUCCESS"){
                    helper.showToast(component,event,'Success!','success','The lead has been converted successfully.');
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": response.getReturnValue().accountId,
                        "slideDevName": "Detail"
                    });
                    navEvt.fire();
                }else{
                    helper.showToast(component,event,'Error!','error',response.getReturnValue().status);
                }
                $A.util.addClass(spinner,"slds-hide");
            });
            $A.enqueueAction(action);
            
        }
    },
    
    handleCancel : function(component, event, helper){
        $A.get("e.force:closeQuickAction").fire();
    }
})