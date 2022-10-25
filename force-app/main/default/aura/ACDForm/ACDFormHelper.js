({
   /*showToast : function(component, event, helper,title,message,type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type" : type
        });
        toastEvent.fire();
    },*/
    checkValidation : function(component,event) {
        var isBlank=true;
        var maxid = component.get("v.prospect.Max_Id__c");
        if(maxid===undefined || maxid===null || maxid===''){
           document.getElementById("NameId").style.display = "block";
            isBlank=false;
        }
        return isBlank;
    }
})