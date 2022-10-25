({
    doInit : function(component,event,helper)  {
        var pageRef = component.get("v.pageReference");
        if(!$A.util.isEmpty(pageRef.state.c__recordId)){
            if(!pageRef.state.c__recordId.includes('notFound')){
                var editRecordEvent = $A.get("e.force:editRecord");
                editRecordEvent.setParams({
                    "recordId": pageRef.state.c__recordId
                });
                editRecordEvent.fire();
            }            
        }
    }
})