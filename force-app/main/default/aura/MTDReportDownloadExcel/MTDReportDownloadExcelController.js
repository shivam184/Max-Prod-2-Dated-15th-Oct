({
    	doInIt : function(component,event,helper) {

        var action = component.get("c.MonthYearPicklist");
        action.setCallback(this,function(response){
            if(response.getState() === "SUCCESS") {
                
                component.set("v.selectedMonthList",response.getReturnValue().MonthList);
                component.set("v.selectedYearList",response.getReturnValue().yearList);
               
               
            }
        });
        $A.enqueueAction(action);
	},  
	generateReport : function(component, event, helper) {
             var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
              "url": "/apex/MTDReportVfpage?startdt="+component.get("v.startDate")+"&enddate="+component.get("v.endDate")+"&selectedMonth="+component.get("v.selectedMonth")+"&selectedYear="+component.get("v.selectedYear"),
              "isredirect": "true"
                
            });
            urlEvent.fire();
    
       
	},
    navigateToMyComponent : function(component, event, helper) {
   
}
     
})