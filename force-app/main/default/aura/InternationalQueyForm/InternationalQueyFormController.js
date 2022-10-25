({
    	
    doInit : function(component, event, helper) {
       var listofFiles=[{
            fname:'',
            base64:''
        }];
        component.set("v.wrapFiles",listofFiles);
         var pickvar = component.get("c.getPickListValuesIntoList");
        pickvar.setCallback(this, function(response) {
            var state = response.getState();
            
            
            if(state === 'SUCCESS'){
                
                var list = response.getReturnValue();
                component.set("v.picvalue", list);
            }
            else if(state === 'ERROR'){
                //var list = response.getReturnValue();
                //component.set("v.picvalue", list);
                alert('ERROR OCCURED.');
            }
        })
        $A.enqueueAction(pickvar);
    },
    
	closeModel : function(component, event, helper) {
        var homeEvent = $A.get("e.force:navigateToObjectHome");
        homeEvent.setParams({
            "scope": "Lead__c"
        });
        homeEvent.fire();	    
	},
    doSave : function(component, event, helper ) {
     
        var count = 0;    
       
        if($A.util.isEmpty(component.get("v.lead.Last_Name__c"))) {
            component.find('lastname').showHelpMessageIfInvalid(); 
            count = 1;
        }
      /*  if($A.util.isEmpty(component.get("v.lead.Passport_No__c"))) {
            component.find('passportno').showHelpMessageIfInvalid(); 
            count = 1;
        } */
        if($A.util.isEmpty(component.get("v.country"))) {
            document.getElementById("counrequrd").style.display = "block";  
            count = 1;
        }
        if($A.util.isEmpty(component.get("v.hcfprt"))) {
            document.getElementById("hcfrequrd").style.display = "block";  
            count = 1;
        }
          /*if (component.find("fileId").get("v.files").length > 0) {
            helper.uploadHelper(component, event);
        } else {
            alert('Please Select a Valid File');
        }*/

        //var getchunk = fileContents.substring(startPosition, endPosition);
        if(count==0){
            // alert(component.get("v.wrapFiles"));
            var action = component.get("c.doSaveLead"); 
            console.log('Wrap Save data ',component.get("v.wrapFiles"));
            action.setParams({
                "ld": component.get("v.lead"),
                "country":component.get("v.country"),
                "hcfpartner":component.get("v.hcfprt"),
               "wrapLst" :JSON.stringify(component.get("v.wrapFiles"))

            });
            
			 component.set("v.Spinner",true);
            action.setCallback(this,function(response){
                if(response.getState() === "SUCCESS") {
               component.set("v.Spinner",false);
                    if(!response.getReturnValue().includes('Error')){
                        helper.showToast(component,event,'SUCCESS!',response.getReturnValue(),'success');
                        var navEvt = $A.get("e.force:navigateToSObject");
                        navEvt.setParams({
                            "recordId": response.getReturnValue(),
                            "slideDevName": "Detail"
                        });
                        navEvt.fire();
                    }else{
                          component.set("v.Spinner",false);
                        helper.showToast(component,event,'WARNING!',response.getReturnValue(),'WARNING');
                    }
                }else{
                     component.set("v.Spinner",false);
                    helper.showToast(component,event,'SUCCESS!',response.getReturnValue(),'error');
                }
            });
            $A.enqueueAction(action);
        }   
    },
    handleChangeFiles :function(component, event, helper) {
        var MAX_FILE_SIZE=4500000;
        // alert(event.getSource().get("v.name"));
        var files = component.get("v.fileToBeUploaded");
        //alert(files);
        var file = files[0][0];
        let indx = event.getSource().get("v.name");
        console.log('FILES SIZE' + file.size + '==' + MAX_FILE_SIZE);
        if (file.size > MAX_FILE_SIZE) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Warning!",
                "message": "File size is more."
            });
            toastEvent.fire();
            return;
        }
        var reader = new FileReader();
        reader.onload = () => {
            var base64 = reader.result.split(',')[1];
            var listofFiles=[];
            listofFiles=component.get("v.wrapFiles");
            listofFiles[indx].fname = file.name;
            listofFiles[indx].base64 = base64;
            component.set("v.wrapFiles",listofFiles)
             console.log('listofFiles' ,listofFiles);
            console.log('File-->' +listofFiles[indx].base64);
            console.log('File Name-->' +listofFiles[indx].fname);
        }
        reader.readAsDataURL(file);
        
    },
    addRow :function(component, event, helper) {
        var listofFiles=[];
        listofFiles=component.get("v.wrapFiles");
        listofFiles.push({
            fname:'',
            base64:''
        });
        
        component.set("v.wrapFiles",listofFiles);
    },
    delRow :function(component, event, helper) {
        //alert(component.get("v.wrapFiles"))
        var listofFiles=[];
        listofFiles=component.get("v.wrapFiles");
        if (listofFiles.length > 1) {
            listofFiles.splice(event.getSource().get("v.name"), 1);
            component.set("v.wrapFiles",listofFiles);
        }
    }
  
})