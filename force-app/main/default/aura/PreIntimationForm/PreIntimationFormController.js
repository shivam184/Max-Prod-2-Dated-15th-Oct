({
    doInIt : function(component,event,helper) {
        if($A.get("$Browser.formFactor")=='PHONE' || $A.get("$Browser.formFactor")=='TABLET')
            component.set("v.isDesktop",false);
        var mySpinner = component.find("mySpinner");
        $A.util.removeClass(mySpinner,"slds-hide");
        var action = component.get("c.doInItApex");
        action.setCallback(this,function(response){
            if(response.getState() === "SUCCESS") {
                component.set("v.ownerName",response.getReturnValue().ownerName);
                component.set("v.listDepartment",response.getReturnValue().listDepartment);
                component.set("v.listPreIntimationStatus",response.getReturnValue().listPreIntimationStatus);
                component.set("v.listBusinessUnit",response.getReturnValue().listBusinessUnit);
                component.set("v.selectedBusinessUnit",response.getReturnValue().selectedBusinessUnit);
                component.set("v.listFileType",response.getReturnValue().listFileType);
                $A.util.addClass(mySpinner,"slds-hide");
            }
        });
        $A.enqueueAction(action);
    },
    departmentvalue : function(component,event,helper){
        var action = component.get("c.getdepartment");
        action.setParams({"docid": component.get("v.treatingDoctorNameId")});
        action.setCallback(this,function(response){
            if(response.getState() === "SUCCESS") {
                component.set("v.selectedDepartment",response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    
    doSave : function(component,event,helper) {
        if(component.get("v.patientName").length == 0) {
            document.getElementById("error1").style.display = "block";	    
        } 
        if(component.get("v.selectedMecpNameId").length == 0 && component.get("v.mecpSource").length == 0) {
            document.getElementById("error2").style.display = "block";	    
        }
        if(component.get("v.ailment").length == 0) {
            document.getElementById("error3").style.display = "block";
        }
        if(component.get("v.base64Data").length > 0 && component.get("v.selectedFileType").length == 0) {
            document.getElementById("error4").style.display = "block";    
        }
        if(component.get("v.patientName").length > 0 && component.get("v.ailment").length > 0 && (component.get("v.selectedMecpNameId").length > 0 || component.get("v.mecpSource").length > 0)) {
            if(component.get("v.base64Data").length > 0 && component.get("v.selectedFileType").length == 0) {
                document.getElementById("error4").style.display = "block";    
            }
            else {
                var mySpinner = component.find("mySpinner");
                $A.util.removeClass(mySpinner,"slds-hide");
                var action = component.get("c.doSaveApex");
                action.setParams({
                    "patientName" : component.get("v.patientName"),
                    "selectedMecpNameId" : component.get("v.selectedMecpNameId"),
                    "mecpSource" : component.get("v.mecpSource"),
                    "treatingDoctorNameId" : component.get("v.treatingDoctorNameId"),
                    "ailment" : component.get("v.ailment"),
                    "businessUnit" : component.get("v.selectedBusinessUnit"),
                    "selectedUploadDocument" : component.get("v.selectedUploadDocument"),
                    "fileName" : component.get("v.fileName"),
                    "base64Data" : component.get("v.base64Data"),
                    "notes" : component.get("v.notes"),
                    "selectedFileType" : component.get("v.selectedFileType"),
                    "drIntimationDateTime" : component.get("v.drIntimationDateTime"),
                    "age" : component.get("v.patientage"),
                    "selectedDepartment" : component.get("v.selectedDepartment")
                });
                action.setCallback(this,function(response){
                    if(response.getState() === "SUCCESS") {
                        if(response.getReturnValue().includes("SUCCESS")){
                            /*
                            var res =  response.getReturnValue().split('*');
                            var navEvt = $A.get("e.force:navigateToSObject");
                            navEvt.setParams({
                                "recordId": res[1],
                                "slideDevName": "detail"
                            });
                            navEvt.fire();
                            */
                            var evt = $A.get("e.force:navigateToComponent");
                            evt.setParams({
                                componentDef: "c:ListPreIntimation"
                                //componentAttributes :{ }
                            });
                            evt.fire();
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                title : 'SUCCESS',
                                message: 'Pre Intimation has been created successfully',
                                type: 'success'
                                
                            });
                            toastEvent.fire();
                        }
                        else{
                            component.set("v.showError",true);
                            component.set("v.errorMsg",response.getReturnValue());
                            document.getElementById("error1").style.display = "none";
                            document.getElementById("error2").style.display = "none";
                            document.getElementById("error3").style.display = "none";
                        }
                        $A.util.addClass(mySpinner,"slds-hide");    
                    }
                });
                $A.enqueueAction(action);     
            }
        }
    },
    
    hideMecpSource : function(component,event,helper){
        if(component.get("v.selectedMecpNameId").length > 0) 
            component.set("v.showMecpSource",false);
        else 
            component.set("v.showMecpSource",true);
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
                document.getElementById('imgSrc').src = dataURL;
                var content = dataURL.match(/,(.*)$/)[1]; 
                component.set("v.base64Data", content);
                component.set("v.fileName", file.name);
            });
            reader.readAsDataURL(file);
        }   
    },
    
    showAttachedData : function(component,event,helper) {
        if(component.get("v.base64Data").length > 0) {
            component.set("v.selectedUploadDocument",'YES');
            component.set("v.disabledNotes",false);
        }
        else {
            component.set("v.selectedUploadDocument",'NO');
            component.set("v.disabledNotes",true);    
        }
        
    },
    
    updateDocument : function(component,event,helper) {
        if(component.get("v.selectedFileType") == 'E-Prescription')
            component.set("v.selectedUploadDocument",'YES');
        else
            component.set("v.selectedUploadDocument",'NO');
            
    },
    
    doCancel : function(component,event,helper) {
        var homeEvent = $A.get("e.force:navigateToObjectHome");
        homeEvent.setParams({
            "scope": "Lead__c"
        });
        homeEvent.fire();	    
    },
    
    isNumber : function(component,event){
        var charCode = (event.which) ? event.which : event.keyCode;
        if (charCode!=46 && charCode > 31 && (charCode < 48 || charCode > 57)) {
            event.preventDefault();
        }
        return true; 
    }
    
    
})