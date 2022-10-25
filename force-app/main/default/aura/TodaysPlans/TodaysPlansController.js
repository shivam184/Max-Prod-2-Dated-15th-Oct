({
    doInit : function(component, event, helper) {
    	helper.doInitHelper(component,event);
          if (navigator.geolocation ){	
            navigator.geolocation.getCurrentPosition(function(position){	
                var lat = position.coords.latitude;	
                var lon = position.coords.longitude;	
                console.log('======'+lat);	
                console.log('====='+lon);	
                component.set('v.latitude',lat);	
                component.set('v.longitude',lon);	
            });	
        } 
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
        helper.getLocation(component,event,'doStartDay');
         //if(component.get("v.latitude")!=null && component.get("v.longitude")!=null){
        	//component.set("v.showStartDayComponent",true);
		//}
    },
    
    doEndDay : function(component,event,helper) {
        helper.getLocation(component,event, 'doEndDay');
        /*if(component.get("v.latitude")!=null && component.get("v.longitude")!=null){
        component.set("v.showEndDayComponent",true);}*/
    },
    
    doBackToOffice : function(component,event,helper) {
        component.set("v.showVisitToOfficeComponent",true);
    },
    
    doCheckIn : function(component,event,helper) {
        if(event.getSource().get("v.ariaLabel") == true){
        	helper.showToast(component,event);
            return;
        }
        helper.getLocation(component,event,'doCheckIn');
        if(component.get("v.latitude")!=null && component.get("v.longitude")!=null){
        helper.saveData(component,event);
               //component.set("v.showConfirmCheckInComponent",true);
        component.set("v.beatPlanDetailId",event.getSource().get("v.accesskey"));}
    },
    
    doCheckOut : function(component,event,helper) {
        helper.getLocation(component,event,'doCheckOut');
        if(component.get("v.latitude")!=null && component.get("v.longitude")!=null){
        helper.saveDataCheckOut(component,event);
        //component.set("v.showCheckOutComponent",true);
        component.set("v.beatPlanDetailId",event.getSource().get("v.accesskey"));
        component.set("v.relatedTo",event.getSource().get("v.name"));
        }
    },
    
    doGetLocation : function(component,event,helper) {
    	helper.getLocation(component,event,'doGetLocation');
        console.log('lat '+component.get("v.latitude"));
        console.log('long '+component.get("v.longitude"));
        if(component.get("v.latitude")!=null && component.get("v.longitude")!=null){
        component.set("v.showConfirmUpdateLocationComponent",true);
        component.set("v.recordId",event.getSource().get("v.accesskey"));
        }
    }
    ,
    doConvertToAccount : function(component,event,helper) {
    	component.set("v.showConvertComponent",true);
        component.set("v.recordId",event.getSource().get("v.accesskey"));
    }
    
})