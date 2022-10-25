({
    doInit : function (component, event, helper) {
        var userID = $A.get("$SObjectType.CurrentUser.Id");
        component.set('v.loggedInUserId',userID);
    },
    
    
    handleRecordUpdated: function(component, event, helper) {
        var eventParams = event.getParams();
        var stg = component.get('v.simpleRecord.Stage__c');
        var owner = component.get('v.simpleRecord.Second_Doctor_s_Co_ordinator__c');
        if(eventParams.changeType === "LOADED") {
            component.set('v.currentStage',stg);
            if((stg==='Patient Admitted' || stg==='Patient Discharged') && owner===$A.get("$SObjectType.CurrentUser.Id"))
                component.set('v.currentStage','Closed Lost');
        } else if(eventParams.changeType === "CHANGED") {
            component.set('v.currentStage',stg);
        } else if(eventParams.changeType === "REMOVED") {
            // record is deleted
        } else if(eventParams.changeType === "ERROR") {
            // there’s an error while loading, saving, or deleting the record
        }
    }
})