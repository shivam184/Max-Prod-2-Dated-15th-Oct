({
	showHideModal : function(component) {
        
        var modal = component.find("editDialog");
        $A.util.toggleClass(modal, 'slds-fade-in-open');
        var overlay = component.find("overlay");
        $A.util.toggleClass(overlay, 'slds-backdrop_open');
        component.set("v.showEndDayComponent", "false");
    }
})