({
	doInIt : function(component,event,helper) {
        
        var urlString = window.location.href;
        var baseURL = urlString.substring(0, urlString.indexOf("/lightning"));
        component.set("v.baseurl",baseURL);
        var action = component.get("c.doInitApex");
        action.setParams({
            "recordId":component.get("v.recordId")
        });
        action.setCallback(this,function(response){
            if(response.getState() === "SUCCESS") {
                
                //set return values 
                component.set("v.vilrequestedList",response.getReturnValue().vilrequested);
                component.set("v.passNo",response.getReturnValue().passNo);
                component.set("v.hcf",response.getReturnValue().hcf);
                component.set("v.country",response.getReturnValue().country);
                component.set("v.location",response.getReturnValue().location);
                
                if(!($A.util.isEmpty(response.getReturnValue().vilId))) {
                    component.set("v.VilID",response.getReturnValue().vilId);
                    component.set("v.Name",response.getReturnValue().Name);
                    component.set("v.baseurl",component.get("v.baseurl")+'/lightning/r/Visa_Invite__c/'+response.getReturnValue().vilId+'/view');
                }
            }
        });
        $A.enqueueAction(action);
	},
    handleVILChange : function(component,event,helper) {
        if(component.get("v.selectedVIL")=='No'){
            component.set("v.button",false);
            helper.showToast(component,event,'WARNING!','For Visa Invite You need to Select Yes','WARNING');
            $A.get('e.force:refreshView').fire();
        }else if(component.get("v.selectedVIL")=='Yes' && component.get("v.VilID")=='')
            component.set("v.button",true);
    },
    rediectToVIL : function(component,event,helper) {
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Visa_Invite__c",
            "defaultFieldValues": {
                'Passport_number__c' : component.get("v.passNo"),
                'HCF_Partner_name__c' : component.get("v.hcf"),
                'Country__c' : component.get("v.country"),
                'Hospital_Location__c' : component.get("v.location")
            }
        });
        createRecordEvent.fire();
    }
})