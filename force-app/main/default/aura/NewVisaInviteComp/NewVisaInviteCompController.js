({
    doinit: function (component, event, helper) {
        var recordId = component.get("v.newVisaAttribute.recordId");
        component.set("v.newVisaAttribute.isDonorPresent", false);
		//alert(recordId);
        if (!$A.util.isEmpty(recordId)) {
            //component.set("v.newVisaAttribute.reloadform", true);
            component.set("v.newVisaAttribute.showAttendees", true);

            helper.setAttachmentinitData(component);
            helper.setinitData(component, recordId, true, true, true);
        } else {
            component.set("v.newVisaAttribute.showAttendees", false);
            component.set("v.newVisaAttribute.isloading", false);
            var action = component.get("c.getPicklistValue");
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var data = response.getReturnValue();
                    var optionValues = [];
                    var relationOptions = data.relationOptions;
                    for (var i = 0; i < relationOptions.length; i++) {
                        var rowItem = relationOptions[i];
                        optionValues.push({ label: rowItem, value: rowItem });
                    }
                    component.set("v.relationOptions", optionValues);
                }
            });
            $A.enqueueAction(action);
        }


    },
    refreshAttandantList: function (component, event, helper) {
        var recordId = component.get("v.newVisaAttribute.recordId");
        //helper.setinitData(component, recordId, true, false, false);
        console.log('init##' + component.get("v.newVisaAttribute.initAddDonor"));
        if (component.get("v.newVisaAttribute.firstAttandee") == true) {
            helper.generatePdfVersion(component, false, true, true);
            component.set("v.newVisaAttribute.firstAttandee", false);
        } else if (component.get("v.attendantRecordType") == 'Donor' && component.get("v.newVisaAttribute.initAddDonor") == true) {
            component.set("v.newVisaAttribute.isloading", true);
            component.set("v.newVisaAttribute.initAddDonor", false);
            component.set("v.newVisaAttribute.firstAttandee", true);
            var addAttendee = component.get("c.addAttendees");
            $A.enqueueAction(addAttendee);
            component.set("v.newVisaAttribute.isloading", false);

        }
        else if (component.get("v.attendantRecordType") == 'Donor' && component.get("v.newVisaAttribute.isDonorPresent") == true) {

            helper.generatePdfVersion(component, true, true, true);
            //window.location.reload()

        } else {

            helper.generatePdfVersion(component, true, true, true);
        }

    },
    handleSubmit: function (component, event, helper) {
        /* console.log("##" + JSON.stringify(event.getParam('fields')));
        console.log("##" + JSON.stringify(event.getParam('fields').Passport_number__c)); */
        
        var recordId = component.get("v.newVisaAttribute.recordId");
        
        var eventFields = event.getParam('fields');
        
        var field = 'Passport_number__c';
        event.preventDefault();
        
        //generate auto unique number for visa invite
        if (eventFields.hasOwnProperty('Visa_Invite_Number__c') && $A.util.isEmpty(recordId)) {

            var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
            var today = new Date();
            var randomnum = new Date().getUTCMilliseconds() + Math.floor(100000 + Math.random() * 900000);
            eventFields.Visa_Invite_Number__c = /* 'Max/PPG/'+ eventFields.Country__c+'/'+  */ today.getFullYear() + '/' + months[today.getMonth()] + '/' + randomnum + '/v1.0';
            //component.set("v.newVisaAttribute.firstVersion", true);
            component.set("v.newVisaAttribute.visaInviteNum", eventFields.Visa_Invite_Number__c);

        } else if (eventFields.hasOwnProperty('Visa_Invite_Number__c') && !$A.util.isEmpty(recordId) && !(eventFields.Transplant__c == true && component.get("v.newVisaAttribute.isDonorPresent") == false)) {
            
            var viNum = eventFields.Visa_Invite_Number__c;
            
            var versionIndex = viNum.lastIndexOf('/v');
            
            //console.log('versionIndex@@' + versionIndex);
            var versionNumber = Number(viNum.substring((versionIndex + 2), (viNum.length)));
            //console.log('versionNumber@@' + versionNumber);
            var newVersionNumber = (versionNumber + Number('0.1')).toFixed(1);
            //console.log('newVersionNumber@@' + newVersionNumber);
            //console.log('parseFloatnewVersionNumber@@' + parseFloat(newVersionNumber));
            //console.log('substring111@@' + viNum.substring(versionIndex + 1, (viNum.length - 1)));
            //console.log('substring@@' + viNum.substring(versionIndex + 1, (viNum.length)));
            eventFields.Visa_Invite_Number__c = viNum.replace(viNum.substring(versionIndex + 1, (viNum.length)), 'v' + newVersionNumber);
            component.set("v.newVisaAttribute.visaInviteNum", eventFields.Visa_Invite_Number__c);

        }
        var regExpSSN = /^[a-z0-9]+$/i;
        if (eventFields.hasOwnProperty(field) && !(eventFields.Passport_number__c.match(regExpSSN))) {

            helper.ShowToast(component, 'error', 'Special character are not allowed in Passport Number.');

        } else {
            
            var deleteDonor = component.get("v.newVisaAttribute.deleteDonor");
            
            if (eventFields.hasOwnProperty(field)) {
                console.log('eventFields.Transplant__c@@' + eventFields.Transplant__c);
                console.log('newVisaAttribute.isDonorPresent@@' + component.get("v.newVisaAttribute.isDonorPresent"));
                
                if (eventFields.Transplant__c == false && component.get("v.newVisaAttribute.isDonorPresent") == true) {
                    
                    deleteDonor = true;
                    component.set("v.newVisaAttribute.deleteDonor", true);
                }
                var action = component.get("c.getVisaInvite");
                action.setParams({ "passNum": eventFields.Passport_number__c, 'deleteDonor': deleteDonor });
                action.setCallback(this, function (response) {

                    var state = response.getState();
                    //alert(state);
                    console.log('State@@' + state);
                    if (state === "SUCCESS") {
                        var data = response.getReturnValue();
                        console.log('data@@' + data);
						if (deleteDonor == true) {
                            component.set("v.newVisaAttribute.isDonorPresent", false);
                        }
                        var VisaInviteList = data.VisaInviteList;
                        
                        if (VisaInviteList.length > 0) {
                            var latestRecord = VisaInviteList[0];
                            if (new Date(latestRecord.Expiration_Date__c) >= new Date() && recordId != latestRecord.Id) {
                                helper.ShowToast(component, 'error', 'This Passport Number already exists. Please search that.');
                            } else {
                                
                                console.log('recordId@@' + recordId);
                                
                                if ($A.util.isEmpty(recordId) && eventFields.hasOwnProperty('Transplant__c') && eventFields.Transplant__c == true) {
                                    
                                    component.set("v.newVisaAttribute.initAddDonor", true);
                                    eventFields.Transplant__c = false;

                                } else if (!$A.util.isEmpty(recordId) && eventFields.hasOwnProperty('Transplant__c') && eventFields.Transplant__c == true && component.get("v.newVisaAttribute.isDonorPresent") == false) {
                                    
                                    eventFields.Transplant__c = false;
                                    component.set("v.newVisaAttribute.addTPDonor", true);
                                }
                                component.find('visaInviteForm').submit(eventFields);
                            }
                        } else {
                            if ($A.util.isEmpty(recordId) && eventFields.hasOwnProperty('Transplant__c') && eventFields.Transplant__c == true) {
                                component.set("v.newVisaAttribute.initAddDonor", true);
                                eventFields.Transplant__c = false;
                            } else if (!$A.util.isEmpty(recordId) && eventFields.hasOwnProperty('Transplant__c') && eventFields.Transplant__c == true && component.get("v.newVisaAttribute.isDonorPresent") == false) {
                                eventFields.Transplant__c = false;
                                component.set("v.newVisaAttribute.addTPDonor", true);
                            }
                            component.find('visaInviteForm').submit(eventFields);
                        }


                    } else if (state === "ERROR") {
                        var errors = response.getError();
                        if (errors) {
                            if (errors[0] && errors[0].message) {
                                helper.ShowToast(component, 'error', errors[0].message);
                            }
                        }
                    } else if (status === "INCOMPLETE") {
                        helper.ShowToast(component, 'error', 'No response from server or client is offline.');
                    } else {
                        helper.ShowToast(component, 'error', "Unknown Error");
                    }

                });
                $A.enqueueAction(action);
            }
        }

    },
    handleError : function(component, event, helper) {
    var error = event.getParam("error");
    console.log(error);
},
    handleSuccess: function (component, event, helper) {
		
        var params = event.getParams();
        console.log(JSON.stringify(params));
        var recId = params.response.id;
        
        //component.set("v.newVisaAttribute.visaInviteCountry", event.getParam('fields').Country__r.displayValue);
        component.set("v.newVisaAttribute.visaInviteCountry", params.response.fields.Country__r.displayValue);
        //component.set("v.newVisaAttribute.visaInviteNum", event.getParam('fields').Visa_Invite_Number__c.value);
        //component.set("v.newVisaAttribute.emailNotificationId", event.getParam('fields').Email_Notification_Id__c.value);
        component.set("v.newVisaAttribute.emailNotificationId", params.response.fields.Email_Notification_Id__c.value);
       
        //component.set("v.newVisaAttribute.hospitalCode", event.getParam('fields').Hospital_Code__c.value);

        var transplant = params.response.fields.Transplant__c.value;
        //console.log('visaInviteNumber@@' + visaInviteNumber);
        
        if ($A.util.isEmpty(component.get("v.newVisaAttribute.recordId"))) {
            component.set("v.newVisaAttribute.recordId", recId);
            //component.set("v.newVisaAttribute.firstAttandee",true);

            console.log('initAddDonor@@' + component.get("v.newVisaAttribute.initAddDonor"));
            if (component.get("v.newVisaAttribute.initAddDonor") == true) {
                component.set("v.newAttendee", { 'sobjectType': 'Attendant_Detail__c' });
                component.set("v.attendantRecordType", 'Donor');
                component.set("v.isAttendentModel", true);
            } else {
                component.set("v.newVisaAttribute.firstAttandee", true);
                var addAttendee = component.get("c.addAttendees");
                $A.enqueueAction(addAttendee);
            }
            //component.set("v.newVisaAttribute.firstAttandee",true);
            //var addAttendee = component.get("c.addAttendees");
            //$A.enqueueAction(addAttendee);
            //helper.generatePdfVersion(component, false,false);

        } else {
            console.log('deleteDonoor@@' + component.get("v.newVisaAttribute.deleteDonor"));
            if (component.get("v.newVisaAttribute.deleteDonor") == true) {
                helper.generatePdfVersion(component, true, true, false);
                component.set("v.newVisaAttribute.deleteDonor", false);
            } else if (component.get("v.newVisaAttribute.addTPDonor") == true) {
                component.set("v.newAttendee", { 'sobjectType': 'Attendant_Detail__c' });
                component.set("v.attendantRecordType", 'Donor');
                component.set("v.isAttendentModel", true);
                component.set("v.newVisaAttribute.addTPDonor", false);
            } else {
                helper.generatePdfVersion(component, true, false, false);
            }
        }

    },
    handleCancel: function (component, event, helper) {
        var recordId = component.get("v.newVisaAttribute.recordId");
        if ($A.util.isEmpty(recordId)) {
            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
                "url": "lightning/n/Visa_Invite"
            });
            urlEvent.fire();
        }
    },
    addAttendees: function (component, event, helper) {
        component.set("v.newAttendee", { 'sobjectType': 'Attendant_Detail__c' });
        component.set("v.attendantRecordType", 'Attendee');
        component.set("v.isAttendentModel", true);
    },
    addDonor: function(component, event, helper){
        component.set("v.newAttendee", { 'sobjectType': 'Attendant_Detail__c' });
        component.set("v.attendantRecordType", 'Donor');
        component.set("v.isAttendentModel", true);
    },

    handleSaveEdition: function (component, event, helper) {
        var recordId = component.get("v.newVisaAttribute.recordId");
        var draftValues = component.find("attendeeTable").get("v.draftValues");
        var action = component.get("c.updateAttendantDetails");
        action.setParams({ "attendeesList": draftValues });
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log(state);
            if (state === "SUCCESS") {
                //helper.getAttendeeData(component, recordId, true, false, true);

                helper.generatePdfVersion(component, true, true, true);

            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        helper.ShowToast(component, 'error', errors[0].message);
                    }
                }
            } else if (status === "INCOMPLETE") {
                helper.ShowToast(component, 'error', 'No response from server or client is offline.');
            } else {
                helper.ShowToast(component, 'error', "Unknown Error");
            }

        });
        $A.enqueueAction(action);
    },

    handleRowAction: function (component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        var recordId = component.get("v.newVisaAttribute.recordId");
        switch (action.name) {
            case 'delete_details':
                var visaInviteForm = component.get("v.newVisaAttribute.selectedVisaInvite");
                console.log(JSON.stringify(visaInviteForm));
                var action = component.get("c.deleteAttendantDetail");
                action.setParams({ "attendeeRecord": row });
                action.setCallback(this, function (response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        //helper.getAttendeeData(component, recordId, true, false, true);
                        helper.generatePdfVersion(component, true, true, true);

                        helper.ShowToast(component, 'SUCCESS', 'Successfully Deleted.');
                    } else if (state === "ERROR") {
                        var errors = response.getError();
                        if (errors) {
                            if (errors[0] && errors[0].message) {
                                helper.ShowToast(component, 'error', errors[0].message);
                            }
                        }
                    } else if (status === "INCOMPLETE") {
                        helper.ShowToast(component, 'error', 'No response from server or client is offline.');
                    } else {
                        helper.ShowToast(component, 'error', "Unknown Error");
                    }

                });
                $A.enqueueAction(action);
                break;

            case 'previewFile':
                $A.get('event.lightning:openFiles').fire({
                    recordIds: [row.ContentDocumentId]
                });
                break;

            case 'downloadFile':
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": "/sfc/servlet.shepherd/document/download/" + row.ContentDocumentId + '?operationContext=S1'
                });
                urlEvent.fire();
                break;

            case 'deleteAttachment':
                var action = component.get("c.deleteAttachmentFile");
                action.setParams({ "attachmentRecordId": row.ContentDocumentId });
                action.setCallback(this, function (response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        helper.getAttendeeData(component, recordId, false, true, false);
                        helper.ShowToast(component, 'SUCCESS', 'Successfully Deleted.');
                    } else if (state === "ERROR") {
                        var errors = response.getError();
                        if (errors) {
                            if (errors[0] && errors[0].message) {
                                helper.ShowToast(component, 'error', errors[0].message);
                            }
                        }
                    } else if (status === "INCOMPLETE") {
                        helper.ShowToast(component, 'error', 'No response from server or client is offline.');
                    } else {
                        helper.ShowToast(component, 'error', "Unknown Error");
                    }

                });
                $A.enqueueAction(action);
                break;

            case 'previewVersion':
                window.open('/servlet/servlet.FileDownload?file=' + row.Id + '&operationContext=S1');
                break;


        }
    },
    handleUploadFinished: function (component, event, helper) {
        // Get the list of uploaded files
        //var uploadedFiles = event.getParam("files");
        helper.setAttachmentinitData(component);
        var recordId = component.get("v.newVisaAttribute.recordId");
        helper.getAttendeeData(component, recordId, false, true, false);

    },
    handleSectionToggle: function (component, event, helper) {
        var names = ['visaInviteSection', 'attendantDetails', 'fileUpload', 'versionHistory', 'patientDetailSection'];
        component.set("v.activeSections", names);
    },

    sendEmail: function (component, event, helper) {
        component.set("v.isSendEmailModel", true);

    },
    /* generateTemplate: function (component, event, helper) {

        var action = component.get("c.getVisaInviteAllInfo");
        action.setParams({ "visaInviteId": component.get("v.newVisaAttribute.recordId") });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                component.set("v.visaInviteAllInfoWrapper", data);
                if (data.VisaInviteList.length > 0) {

                    var recordData = data.VisaInviteList[0];
                    //alert(JSON.stringify(recordData));
                    component.set("v.isGenerateTamplate", true);

                }
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        helper.ShowToast(component,'error', errors[0].message);
                    }
                }
            } else if (status === "INCOMPLETE") {
                helper.ShowToast(component,'error', 'No response from server or client is offline.');
            } else {
                helper.ShowToast(component,'error', "Unknown Error");
            }

        });
        $A.enqueueAction(action);

    }, */
})