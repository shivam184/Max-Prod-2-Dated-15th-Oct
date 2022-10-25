({
    init: function (component, event, helper) {
        component.set("v.newAttendee.Relation__c", 'Other');
    },
    closeModel: function (component, event, helper) {
        // Set isModalOpen attribute to false  
        if (component.get("v.firstAttandee") == true || component.get("v.initAddDonor") == true) {
            var parent = component.get("v.parent");
            parent.parentMethod();
        }

        component.set("v.isAttendentModel", false);
    },
    saveAttendee: function (component, event, helper) {

        var newAttendee = component.get("v.newAttendee");
        console.log('@@' + newAttendee);

        var visaInviteId = component.get("v.visaInviteId");
        console.log('@@' + visaInviteId);

        if (!$A.util.isEmpty(visaInviteId)) {
            newAttendee.Visa_Invite__c = visaInviteId;
            component.set("v.newAttendee", newAttendee);
            console.log('@@' + component.get("v.newAttendee"));


            if ($A.util.isEmpty(newAttendee.Name) || $A.util.isEmpty(newAttendee.Passport_number__c)) {
                helper.ShowToast('error', 'Please enter all the required field');
            } else {
                var action = component.get("c.insertAttedeeRelatedToVisaInvite");
                action.setParams({ 'newAttendee': newAttendee, 'attendantRecordType': component.get("v.attendantRecordType") });
                action.setCallback(this, function (response) {
                    var state = response.getState();
                    console.log('state@@' + state);
                    if (state === 'SUCCESS') {
                        var data = response.getReturnValue();
                        if (!$A.util.isEmpty(data.Id)) {
                            //component.set("v.firstAttandee", false);

                            if (component.get("v.attendantRecordType") == 'Donor') {
                                component.set("v.isDonorPresent", true);
                            }
                            component.set("v.isAttendentModel", false);
                            var parent = component.get("v.parent");
                            parent.parentMethod();
                            helper.ShowToast('SUCCESS', 'Successfully Saved.');


                        }
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
        }
    },


})