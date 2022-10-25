({
    
	doInit : function(component, event, helper) {
      
        component.set("v.showSpinner",true);
        var gettcomp = component.get("c.updatePicklist");
        gettcomp.setCallback(this,function(res){
            var state = res.getReturnValue();
          
            if(state==="SUCCESS"){
                component.set("v.showSpinner",false);
                var toast = $A.get("e.force:showToast");
                toast.setParams({
                    "type" : "success",
                    "title" : "Records Updated",
                    "message" : "Records Update Successfully"
                });
                toast.fire();
            }
            else{
                 component.set("v.showSpinner",false);
                var toast =$A.get("e.force:showToast");
                toast.setParams({
                    type:"Error",
                    title: "Record Updated",
                    message: "Record Update Failed..."
                });
                toast.fire();
        }
      });
        $A.enqueueAction(gettcomp);
}
})