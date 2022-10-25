({
	doInit : function(component, event, helper) {
        var action = component.get("c.onComLoad");
        action.setCallback(this,function(res){
            if(res.getState()==="SUCCESS")
                component.set("v.wrapET",res.getReturnValue());
            	component.set("v.edate",res.getReturnValue().todayDate);
        });
        $A.enqueueAction(action);
	},
    
    doSearch : function(component, event, helper) {  
        var spinner = component.find("mySpinner");
            $A.util.removeClass(spinner,"slds-hide");
        var action = component.get("c.save");
        action.setParams({
            "edate" : component.get("v.edate")
        });
        
        action.setCallback(this,function(res){
            if(res.getState()==="SUCCESS")
                component.set("v.wrapET",res.getReturnValue());
            $A.util.addClass(spinner,"slds-hide");                     
        });
        $A.enqueueAction(action);
        
    }
})