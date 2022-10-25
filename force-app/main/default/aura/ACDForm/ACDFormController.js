({
    itemsChange :function(component,event,helper){
         var validate = helper.checkValidation(component,event);
        if(validate){
          document.getElementById("NameId").style.display = "none";
        }
    },
    saveDetails : function(component, event, helper) {
        /* var maxId = component.get('v.prospect.Max_Id__c');
        var regex = /^[A-Za-z]{4}.[0-9]{1,6}$/;
        
        if($A.util.isEmpty(component.get('v.prospect.Max_Id__c'))){
            component.find("maxId").showHelpMessageIfInvalid();
            return;
        }            
        if(!maxId.match(regex)) {
        	helper.showToast(component, event, helper,'ERROR','Enter Max Id in correct format','error');
            return;
        }*/       
        
        
        
        
       
        var validate = helper.checkValidation(component,event);
        if(!validate)
            return;
        else{
             component.set('v.showSpinner',true);
            var action = component.get('c.saveProspectDetails');
            action.setParams({
                'prospect' : component.get('v.prospect')
            });
            action.setCallback(this, function(response){
                if(response.getState()==='SUCCESS'){
                    var resp = response.getReturnValue();
                    if(resp.includes('Success')){
                        component.set('v.showSpinner',false);
                        component.set('v.successMessage','Record created successfully!');
                        component.set('v.prospect',{});
                    }
                }
                if(response.getState()==='ERROR'){
                    alert('ERROR '+action.getError()[0].message);
                }
            });
            $A.enqueueAction(action);
        }    
        
    }
})