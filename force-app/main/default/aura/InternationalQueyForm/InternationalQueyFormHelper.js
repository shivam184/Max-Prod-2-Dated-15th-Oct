({ 
	
    doInitHelper : function(component,event) {
         var BusinessUnit = $A.get("$Label.c.Occupation");
        component.set("v.listBusinessUnit",BusinessUnit.split(';'));
    },
    
    showToast : function(component, event, title, message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type" : type
        });
        toastEvent.fire();
    }


})