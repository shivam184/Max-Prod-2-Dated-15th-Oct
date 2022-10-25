({
    doInit : function(component) {
        component.set("v.sendtoemails",component.get("v.emailNotificationId"));
        component.set("v.CCEmailsId",component.get("v.emailCCId"));
        component.set("v.BCCEmailsId",component.get("v.emailBCCId"));
        component.set('v.vfHost', window.location.hostname);
      
        //alert(component.get("v.visaInviteNumber"));
        // alert(encodeURIComponent(component.get("v.visaInviteNumber")));
        component.set("v.encodedvisaInviteNumber",encodeURIComponent(component.get("v.visaInviteNumber")));
        /* if(component.get("v.isGenerateTamplate")){
            var message = component.get("v.visaInviteAllInfoWrapper.VisaInviteList");
            alert(JSON.stringify(message));
            //var vfOrigin = "https://" + component.get("v.vfHost");
            //var vfWindow = component.find("vfFrame").getElement().contentWindow;
            //vfWindow.postMessage(message, vfOrigin);
        } */
    },
    closeModel: function (component, event, helper) {
        // Set isModalOpen attribute to false  
        component.set("v.isSendEmailModel", false);
    },
    
    SendInviteEmail : function(component, event, helper){
        let visainviteId = component.get("v.visaInviteId");
        let SendtoEmailIds = component.get("v.sendtoemails"); 
        let SendCCIds=component.get("v.CCEmailsId");
        let SendBCCIds=component.get("v.BCCEmailsId");
        let action = component.get("c.sendvisainvitemail");
        action.setParams({ "visainviteId": visainviteId ,
                         "SendtoEmailIds" : SendtoEmailIds,
                          "SendCCIds":SendCCIds ,
                          "SendBCCIds":SendBCCIds
                         });
        action.setCallback(this, function (response) {
            var state = response.getState();
              component.set("v.isSendEmailModel", false);
            if (state === "SUCCESS") {               
               helper.ShowToast('success', 'Email has been Sent Successfully.');
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        helper.ShowToast('error', errors[0].message);                      
                    }
                }
            } else if (status === "INCOMPLETE") {
                helper.ShowToast('error', 'No response from server or client is offline.');
            } else {
                helper.ShowToast('error', "Unknown Error");
            }

        });
        $A.enqueueAction(action);
    }
})