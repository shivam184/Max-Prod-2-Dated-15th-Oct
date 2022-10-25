({
	showHideModal : function(component) {
        
        var modal = component.find("editDialog");
        $A.util.toggleClass(modal, 'slds-fade-in-open');
        var overlay = component.find("overlay");
        $A.util.toggleClass(overlay, 'slds-backdrop_open');
        component.set("v.showCheckOutComponent", "false");
        component.set("v.checkoutRemarks", "");
        //document.getElementById("errorNew").style.display = "none";
        component.set("v.checkTask",false);
        component.set("v.checkEvent",false);
        component.set("v.showTask",false);
        component.set("v.showEvent",false);
        component.set("v.relatedTo","");
        component.set("v.eventDueDate",null);
        component.set("v.taskDueDate",null);
        component.set("v.selectedEvent","");
        component.set("v.selectedTask","");
        component.set("v.showCheckout",true);
    }
})