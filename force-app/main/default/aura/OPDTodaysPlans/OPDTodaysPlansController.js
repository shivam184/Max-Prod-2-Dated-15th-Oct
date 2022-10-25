({
    doInit : function(component, event, helper) {
    	helper.doInitHelper(component,event);
    },
    
    doCancel : function(component,event,helper) {
        component.set("v.beatPlanDetailId",event.getSource().get("v.accesskey"));
        component.set("v.showCancelComponent",true);
    },
    
    doReschedule : function(component,event,helper) {
        component.set("v.beatPlanDetailId",event.getSource().get("v.accesskey"));
        component.set("v.showRescheduleComponent",true);
    },
    
    doStartDay : function(component,event,helper) {
        helper.getLocation(component,event);
        component.set("v.showStartDayComponent",true);
    },
    
    doEndDay : function(component,event,helper) {
        helper.getLocation(component,event);
        component.set("v.showEndDayComponent",true);
    },
    
    doBackToOffice : function(component,event,helper) {
        component.set("v.showVisitToOfficeComponent",true);
    },
    
    doCheckIn : function(component,event,helper) {
        if(event.getSource().get("v.ariaLabel") == true){
        	helper.showToast(component,event);
            return;
        }
        helper.getLocation(component,event);
        component.set("v.showConfirmCheckInComponent",true);
        component.set("v.beatPlanDetailId",event.getSource().get("v.accesskey"));
    },
    
    doCheckOut : function(component,event,helper) {
        helper.getLocation(component,event);
        component.set("v.showCheckOutComponent",true);
        component.set("v.beatPlanDetailId",event.getSource().get("v.accesskey"));
        component.set("v.relatedTo",event.getSource().get("v.name"));
    },
    
    doGetLocation : function(component,event,helper) {
    	helper.getLocation(component,event);
        component.set("v.showConfirmUpdateLocationComponent",true);
        component.set("v.recordId",event.getSource().get("v.accesskey"));
    }
    ,
    doConvertToAccount : function(component,event,helper) {
    	component.set("v.showConvertComponent",true);
        component.set("v.recordId",event.getSource().get("v.accesskey"));
    }
    
})