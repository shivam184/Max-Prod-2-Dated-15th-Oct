({
    
    handleStartClick : function(component, event, helper) {
        helper.getCurrentTime(component,event,helper);
        if(!component.get("v.noMobile"))
            helper.setStartTimeOnUI(component);
    },
    
    handleStopClick : function(component, event, helper) {
        helper.setStopTimeOnUI(component);
    },
    handleResetClick : function(component, event, helper) {
        helper.setResetTimeOnUI(component);
    }   
})