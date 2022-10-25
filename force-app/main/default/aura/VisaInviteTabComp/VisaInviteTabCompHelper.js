({
    getVisaInviteData: function (component) {
        var passNum = component.get("v.newVisaAttribute.searchPassNum");
        if (!$A.util.isEmpty(passNum) && passNum.length > 3) {
            var action = component.get("c.getVisaInvite");
            action.setParams({ 'passNum': passNum });
            action.setCallback(this, function (response) {
                var state = response.getState();
                console.log('state@@' + state);
                if (state === 'SUCCESS') {
                    var data = response.getReturnValue();
                    console.log('data@@' + data.VisaInviteList);
                    if ($A.util.isEmpty(data.VisaInviteList)) {
                        component.set("v.newVisaAttribute.isNewBtn", true);
                        this.ShowToast('info', 'No Visa Invite Exist.');
                    } else {
                        var inviteList = data.VisaInviteList;
                        var latestInviteRec = inviteList[0];
                        if (new Date(latestInviteRec.Expiration_Date__c) < new Date()) {
                            component.set("v.newVisaAttribute.isNewBtn", true);
                        }
                        for (var i = 0; i < inviteList.length; i++) {
                            var row = inviteList[i];
                            if (row.Doctor_Name__c) {
                                row.doctorName = row.Doctor_Name__r.Name;
                            }
                            if (row.HCF_Partner_name__c) {
                                row.partnerName = row.HCF_Partner_name__r.Name;
                            }
                            if (row.Hospital_Location__c) {
                                row.hospitalLocation = row.Hospital_Location__r.Name;
                            }
                            /* if(row.Patient_Name__c){
                                row.patientName = row.Patient_Name__r.Name;
                            } */
                            if (row.Customer_Patient_Name__c) {
                                row.patientName = row.Customer_Patient_Name__c;
                            }
                            if (new Date(row.Expiration_Date__c) >= new Date()) {
                                row.actionDisabled = false;
                            } else {
                                row.actionDisabled = true;
                            }

                        }
                        component.set("v.visaInviteData", data.VisaInviteList);
                    }
                    component.set('v.newVisaAttribute.searchloader', false);

                } else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            this.ShowToast('error', errors[0].message);
                        }
                    }
                } else if (status === "INCOMPLETE") {
                    this.ShowToast('error', 'No response from server or client is offline.');
                } else {
                    this.ShowToast('error', 'Unknown Error');
                }

            });
            $A.enqueueAction(action);

        } else {
            component.set('v.newVisaAttribute.searchloader', false);
            this.ShowToast('error', 'Please Search Valid Passport Number');
        }
    },

    ShowToast: function (type, msg) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": type,
            "message": msg
        });
        toastEvent.fire();
    }

})