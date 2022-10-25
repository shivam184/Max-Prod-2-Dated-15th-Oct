({
    setTodayDates : function(component){
        var currentDate = $A.localizationService.formatDate(new Date(),"YYYY-MM-DD");
        component.set('v.startDate',currentDate);
        //component.set('v.endDate',currentDate);
        this.getDate(component);
        
    },
    fireToast : function(type,title,message,duration,mode){
        var toast = $A.get('e.force:showToast');
        toast.setParams({
            type:type,
            title:title,
            message:message,
            duration:duration,
            mode:mode
        });
        toast.fire();
    },
    
    getDate : function(component) {
        
        var tt = component.get("v.startDate");
        
        var date = new Date(tt);
        var newdate = new Date(date);
        
        newdate.setDate(newdate.getDate() + 89);
        
        var dd = newdate.getDate();
        var mm = newdate.getMonth() + 1;
        var y = newdate.getFullYear();
        
        var someFormattedDate = y + '-' + mm + '-' + dd;
        //component.set("v.maxDate",someFormattedDate);
        component.set("v.endDate",component.get("v.startDate"));
    }
    
})