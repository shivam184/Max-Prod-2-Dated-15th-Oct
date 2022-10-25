({
    setinitData: function (component, recordId, getAttendant, getAttachment, getVersionHistory) {
        /* console.log('getAttendant@'+getAttendant);
        console.log('getAttachment@'+getAttachment);
        console.log('getVersionHistory@'+getVersionHistory); */
        var toggleAttendeesSection = component.find("toggleAttendeesSection");
        $A.util.addClass(toggleAttendeesSection, 'slds-show');
        $A.util.removeClass(toggleAttendeesSection, 'slds-hide');
        component.set("v.newVisaAttribute.showAttendees", true);
        component.set("v.newAttendee", { 'sobjectType': 'Attendant_Detail__c', 'Name': '' });
        var actions = [
            { label: 'Delete', name: 'delete_details' }
        ];
        /* var versionHistoryActions = [
            { label: 'Download', name: 'download_Version' }
        ]; */
        component.set('v.columns', [
            { label: 'Type', fieldName: 'RecordTypeName', type: 'text' },
            { label: 'Attendant Name', fieldName: 'Name', type: 'text', editable: true },
            { label: 'Passport number', fieldName: 'Passport_number__c', type: 'text', editable: true },
            { label: 'Relation', fieldName: 'Relation__c', type: 'text', editable: true },
            { label: 'Date of birth', fieldName: 'Date_of_Birth__c', type: 'text', editable: true },
            { label: 'Active/Inactive', fieldName: 'Active__c', type: 'boolean', editable: true },
            { type: 'action', typeAttributes: { rowActions: actions } }
        ]);

        component.set('v.versionHistoryColumns', [
            { label: 'Name', type: 'button', typeAttributes: { label: { fieldName: 'FileTitle' }, name: 'previewVersion', title: 'Click to Preview', variant: 'base' } },
            { label: 'Last Modified Date', fieldName: 'fileLastModifiedDate', type: 'date' },
            // { type: 'action', typeAttributes: { rowActions: versionHistoryActions } }
        ]);

        this.getAttendeeData(component, recordId, getAttendant, getAttachment, getVersionHistory);
    },
    setAttachmentinitData: function (component) {
        var actions = [
            { label: 'Download', name: 'downloadFile' },
            { label: 'Delete', name: 'deleteAttachment' }
        ];
        component.set('v.attachmentColumns', [
            { label: 'Title', type: 'button', typeAttributes: { label: { fieldName: 'FileTitle' }, name: 'previewFile', title: 'Click to Preview', variant: 'base' } },
            { label: 'File Type', fieldName: 'fileType', type: 'text' },
            { label: 'Last Modified Date', fieldName: 'fileLastModifiedDate', type: 'date' },
            { type: 'action', typeAttributes: { rowActions: actions } }
        ]);
    },
    getAttendeeData: function (component, recordId, getAttendant, getAttachment, getVersionHistory) {
        component.set("v.newVisaAttribute.isloading", true);
        if (getAttendant == true) {
            component.set("v.attedeesListData", []);
        }
        if (getAttachment == true) {
            component.set("v.attachmentListData", []);
        }
        if (getVersionHistory == true) {
            component.set("v.versionHistoryListData", []);
        }
        /* console.log('getAttendant'+getAttendant);
        console.log('getAttachment'+getAttachment);
        console.log('getVersionHistory'+getVersionHistory); */
        var action = component.get("c.getAttedeeRelatedToVisaInvite");
        //alert(recordId);
        action.setParams({ 'visaInviteId': recordId, 'getAttendant': getAttendant, 'getAttachment': getAttachment, 'getVersionHistory': getVersionHistory });
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log('getAttendeeDatastate@@' + state);
            if (state === 'SUCCESS') {
                var data = response.getReturnValue();
                //console.log('datta@@' + JSON.stringify(data));
                //console.log('VisaInviteList@@' + JSON.stringify(data.VisaInviteList));

                component.set("v.newVisaAttribute.visaInviteNum", data.VisaInviteList[0].Visa_Invite_Number__c);
                component.set("v.newVisaAttribute.visaInviteCountry", data.VisaInviteList[0].Country__r.Name);
                component.set("v.newVisaAttribute.emailNotificationId", data.VisaInviteList[0].Email_Notification_Id__c);
                component.set("v.newVisaAttribute.hospitalCode", data.VisaInviteList[0].Hospital_Code__c);
                component.set("v.wrapperVisaInviteClass", data);
                if (getAttendant == true && getAttachment == true && getVersionHistory == true) {
                    console.log("realation@@" + JSON.stringify(data.relationOptions));
                    var optionValues = [];
                    var relationOptions = data.relationOptions;
                    for (var i = 0; i < relationOptions.length; i++) {
                        var rowItem = relationOptions[i];
                        optionValues.push({ label: rowItem, value: rowItem });
                    }
                    component.set("v.relationOptions", optionValues);
                }
                //set attendant details
                if (getAttendant == true) {
                    //console.log('attedeesListData@@' + data.attendeesList);
                    var attendeesList = [];
                    var attendantList = data.attendeesList;
                    for (var i = 0; i < attendantList.length; i++) {
                        var row = attendantList[i];
                        if (row.RecordTypeId) {
                            row.RecordTypeName = row.RecordType.Name;
                        }
                        attendeesList.push(row);
                    }
                    component.set("v.attedeestypeDataList", attendeesList);
                    var donorList = data.donorList;
                    for (var i = 0; i < donorList.length; i++) {
                        var row = donorList[i];
                        if (row.RecordTypeId) {
                            row.RecordTypeName = row.RecordType.Name;
                        }
                        attendeesList.push(row);
                        component.set("v.newVisaAttribute.isDonorPresent", true);
                    }

                    component.set("v.attedeesListData", attendeesList);
                }
                //set attachmentfile details
                if (getAttachment == true) {
                    //console.log('conDocLinkList@@' + data.conDocLinkList);

                    var inviteList = data.conDocLinkList;
                    for (var i = 0; i < inviteList.length; i++) {
                        var row = inviteList[i];
                        if (row.ContentDocumentId) {
                            row.FileTitle = row.ContentDocument.Title;
                            row.fileType = row.ContentDocument.FileType;
                            row.fileLastModifiedDate = row.ContentDocument.LastModifiedDate;
                        }
                    }
                    component.set("v.attachmentListData", inviteList);
                }
                //set versionHistory details
                if (getVersionHistory == true) {
                    //console.log('versionHistoryList@@' + JSON.stringify(data.versionHistoryList));

                    var versionHistoryList = data.versionHistoryList;
                    for (var i = 0; i < versionHistoryList.length; i++) {
                        var row = versionHistoryList[i];
                        row.FileTitle = row.Name;
                        row.fileLastModifiedDate = row.LastModifiedDate;

                    }
                    component.set("v.versionHistoryListData", versionHistoryList);
                }

                component.set("v.newVisaAttribute.reloadform", true);
                component.set("v.newVisaAttribute.isloading", false);
                //console.log('isloadingData@@' + component.get("v.newVisaAttribute.isloading"));

            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        this.ShowToast(component, 'error', errors[0].message);
                    }
                }
            } else if (status === "INCOMPLETE") {
                this.ShowToast(component, 'error', 'No response from server or client is offline.');
            } else {
                this.ShowToast(component, 'error', "Unknown Error");

            }
            //component.set("v.newVisaAttribute.isloading", false);
        });
        $A.enqueueAction(action);
    },

    generatePdfVersion: function (component, refreshHistoryList, refreshAttandeeList, refreshVisaInvite) {
        component.set("v.newVisaAttribute.isloading", true);
        var countryName = component.get("v.newVisaAttribute.visaInviteCountry");
        var visaInviteNumber = component.get("v.newVisaAttribute.visaInviteNum");
        var emailNotificationId = component.get("v.newVisaAttribute.emailNotificationId");
        var hospitalCode = component.get("v.newVisaAttribute.hospitalCode");
        console.log('hospitalCode--'+hospitalCode);
        //var firstVersion = component.get("v.newVisaAttribute.firstVersion");
        console.log('visaInviteNumber@@@1' + visaInviteNumber);
        var pdfName = 'Max/'+ hospitalCode+ '/' + countryName + '/' + visaInviteNumber;

        var visaId = component.get("v.newVisaAttribute.recordId");
        var action = component.get("c.generatePdfAndSave");
        action.setParams({ "visaInviteId": visaId, "pdfName": pdfName, "refreshVisaInvite": refreshVisaInvite, "visaNumber": component.get("v.newVisaAttribute.visaInviteNum") });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //var data = response.getReturnValue();
                //$A.get('e.force:refreshView').fire();
                /*  if (firstVersion == true) {
                     component.set("v.newVisaAttribute.firstVersion", false);
                 } */
                if (refreshHistoryList == true) {
                    if (refreshVisaInvite == true) {
                        //component.set("v.newVisaAttribute.reloadform", false);
                        //component.set("v.newVisaAttribute.refreshPage", true);
                        window.location.reload();


                    } else {
                        this.getAttendeeData(component, visaId, refreshAttandeeList, false, true);
                    }

                } else if (refreshHistoryList == false) {
                    component.set("v.newVisaAttribute.recordMode", 'view');
                    component.set("v.newVisaAttribute.showAttendees", true);
                    component.set("v.newVisaAttribute.reloadform", true);
                    //component.set("v.isNewVisaForm", true);
                    var evt = $A.get("e.force:navigateToComponent");
                    evt.setParams({
                        componentDef: "c:NewVisaInviteComp",
                        componentAttributes: {
                            newVisaAttribute: component.get("v.newVisaAttribute")
                        }
                    });
                    evt.fire();
                    component.set("v.newVisaAttribute.isloading", false);

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
            component.set("v.newVisaAttribute.isloading", false);


        });
        $A.enqueueAction(action);
    },

    ShowToast: function (component, type, msg) {

        component.set("v.newVisaAttribute.isloading", false);
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": type,
            "message": msg
        });

        toastEvent.fire();

    }


})