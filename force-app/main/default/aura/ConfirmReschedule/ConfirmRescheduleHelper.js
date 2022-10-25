({
	showHideModal : function(component) {
        
        var modal = component.find("editDialog");
        $A.util.toggleClass(modal, 'slds-fade-in-open');
        var overlay = component.find("overlay");
        $A.util.toggleClass(overlay, 'slds-backdrop_open');
        component.set("v.showRescheduleComponent","false");
        component.set("v.rescheduleReason","");
        component.set("v.rescheduleDate","");
        document.getElementById("error1").style.display = "none";
        document.getElementById("error2").style.display = "none";
        /*        
        var last = new Date();
        var dd = 0;
        var mm = today.getMonth() + 1;
        var yyyy = today.getFullYear();
        if (dd < 10) {
            dd = '0' + dd;
        }
        if (mm < 10) {
            mm = '0' + mm;
        }
        last = yyyy + '-' + mm + '-' + dd;
        component.set("v.maxDate",last);
        
        
        var today = new Date();
        var dd1 = today.getDate();
        var mm1 = today.getMonth();
        var yyyy1 = today.getFullYear();
        alert('dd1-->'+dd1);
        alert('mm1-->'+mm1);
        alert('yyyy1-->'+yyyy1);
        if (dd1 < 10) {
            dd1 = '0' + dd1;
        }
        if (mm1 < 10) {
            mm1 = '0' + mm1;
        }
        today = yyyy1 + '-' + mm1 + '-' + dd1;
        component.set("v.minDate",today);
        */
    }
})