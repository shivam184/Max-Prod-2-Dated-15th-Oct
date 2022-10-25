({
    doInit : function(component, event, helper) {
        var spinner = component.find("mySpinner");
        $A.util.removeClass(spinner,"slds-hide");
        var action = component.get("c.doInitApex");
        action.setParams({
            recordId : component.get('v.recordId')
        });
        action.setCallback(this,function(response){
            if(response.getState() === "SUCCESS") {
                if(response.getReturnValue().status === "SUCCESS") {
                    if(response.getReturnValue().showComponent)
                    	component.set("v.listFileType",response.getReturnValue().listFileType);
                    else {
                    	var dismissActionPanel = $A.get("e.force:closeQuickAction");
                        dismissActionPanel.fire();
                        helper.showToast(component,event,'ERROR','Document has been uploaded','error');    
                    }
                }
                else {
                    var dismissActionPanel = $A.get("e.force:closeQuickAction");
                    dismissActionPanel.fire();
                    helper.showToast(component,event,'ERROR',response.getReturnValue().status,'error');	
                }
            } 
            $A.util.addClass(spinner,"slds-hide");
        });
        $A.enqueueAction(action);
    },
    
    onReadImage: function(component, event, helper) {
        var files = component.get("v.files");
        if (files && files.length > 0) {
            var filelength = files.length;
            var file = files[0][0];
            var fileend = files[filelength-1][filelength-1];
            if(file.size > 2097152) {
                return alert('Maximum file size allowed is 2 MB');    
            }
            
            if (!file.type.match(/(image.*)/) && !fileend.type.match(/(pdf)/)){
                return alert('File not supported');
            }
            var reader = new FileReader();
            reader.onloadend = $A.getCallback(function() {
                var dataURL = reader.result;
                component.set("v.base64Data", dataURL);
                component.set("v.fileName", file.name);
            });
            reader.readAsDataURL(file);
        }   
    },
    
    handleCancel : function(component,event,helper){
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();    
    },
    
    handleSave : function(component,event,helper) {
        if($A.util.isEmpty(component.get("v.base64Data"))) {
            //helper.showToast(component,event,'ERROR','Please Attach File','error');  
            component.set("v.showAttachFile",true);  
        }
        else {
            component.set("v.showAttachFile",false);
            if($A.util.isEmpty(component.get("v.selectedFileType"))) {
                //helper.showToast(component,event,'ERROR','Please Select File Type','error');	
                component.set("v.showFileType",true);  
            }
            else {
                var spinner = component.find("mySpinner");
                $A.util.removeClass(spinner,"slds-hide");
                var action = component.get("c.handleSaveApex");
                action.setParams({
                    "recordId" : component.get("v.recordId"),
                    "base64Data" : component.get("v.base64Data"),
                    "selectedFileType" : component.get("v.selectedFileType"),
                    "notes" : component.get("v.notes"),
                    "fileName" : component.get("v.fileName")
                });
                action.setCallback(this,function(response){
                    if(response.getState() === 'SUCCESS') {
                        $A.util.addClass(spinner,"slds-hide");
                        if(response.getReturnValue().includes("SUCCESS")) {
                            $A.get('e.force:refreshView').fire();
                            helper.showToast(component,event,'SUCCESS','File Uploaded Successfully','success');
                        }
                        else {
                            helper.showToast(component,event,'ERROR',response.getReturnValue(),'error');    
                        }
                        var dismissActionPanel = $A.get("e.force:closeQuickAction");
                        dismissActionPanel.fire();
                    }    
                });
                $A.enqueueAction(action);
            }
        }
    }
})