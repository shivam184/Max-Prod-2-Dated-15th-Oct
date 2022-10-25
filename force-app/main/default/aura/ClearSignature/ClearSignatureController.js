({
	clearSign : function(component, event, helper) {
		var cmpEvt = component.getEvent("clearEvent");
        cmpEvt.fire();
        var modal = component.find("editDialog");
        $A.util.toggleClass(modal, 'slds-fade-in-open');
        var overlay = component.find("overlay");
        $A.util.toggleClass(overlay, 'slds-backdrop_open');
        component.set("v.showDialog", "false");
	},
    
    cancelClick : function(component, event, helper){
        var modal = component.find("editDialog");
        $A.util.toggleClass(modal, 'slds-fade-in-open');
        var overlay = component.find("overlay");
        $A.util.toggleClass(overlay, 'slds-backdrop_open');
        component.set("v.showDialog", "false");
    }
})