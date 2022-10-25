({
    selectedRecords : function(component, event, helper) {
        var selectedRows = event.getParam('selectedRows');
        component.set('v.selectedRowsCount', selectedRows.length);
        var tableType = component.get("v.tableType");
        for (var i = 0; i < selectedRows.length; i++){
            if(tableType == "Lead") 
                component.set("v.selectedLeadId",selectedRows[i].id);
            else if(tableType == 'Admission'){
                component.set("v.selectedAdmissionId",selectedRows[i].id);  
            }
                else {
                    component.set("v.selectedMecpSource",selectedRows[i].id);	    
                }
        } 
    }
})