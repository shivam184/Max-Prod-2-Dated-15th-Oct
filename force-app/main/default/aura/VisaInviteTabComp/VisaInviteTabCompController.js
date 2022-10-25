({
    doinit: function (component, event, helper) {

        component.set('v.columns', [
            { label: '', type: 'button', typeAttributes: { label: 'Edit', name: 'edit_details', title: 'Click to Edit Details', iconName: 'utility:edit', disabled: { fieldName: 'actionDisabled' } } },
            { label: 'Visa Invite Name', fieldName: 'Name', type: 'text' },
            { label: 'Patient name', fieldName: 'patientName', type: 'text' },
            { label: 'Doctor name', fieldName: 'doctorName', type: 'text' },
            { label: 'Passport number', fieldName: 'Passport_number__c', type: 'text' },
            { label: 'Mobile Number', fieldName: 'Mobile_Number__c', type: 'phone' },
            { label: 'Issue Date', fieldName: 'Issue_Date__c', type: 'date' },
            { label: 'Expiration Date', fieldName: 'Expiration_Date__c', type: 'date' },
            { label: 'HCF Partner name', fieldName: 'partnerName', type: 'text' },
            { label: 'Hospital Location', fieldName: 'hospitalLocation', type: 'text' }
        ]);


    },
    newInvite: function (component, event, helper) {
        component.set("v.newVisaAttribute.reloadform", true);
        component.set("v.newVisaAttribute.recordMode", 'edit');
        //component.set("v.isNewVisaForm", true);
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef: "c:NewVisaInviteComp",
            componentAttributes: {
                //isNewVisaForm: component.getReference("v.isNewVisaForm"),
                newVisaAttribute: component.get("v.newVisaAttribute")
            }
        });
        evt.fire();
    },
    searchVisaInvite: function (component, event, helper) {
        component.set("v.newVisaAttribute.isNewBtn", false);
        component.set("v.visaInviteData", []);
        component.set('v.newVisaAttribute.searchloader', true);
        helper.getVisaInviteData(component);
    },
    keyCheck: function(component,event,helper){
        if (event.which == 13){
            var a = component.get("c.searchVisaInvite");
            $A.enqueueAction(a);
        } 
    },
    handleRowAction: function (component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');

        switch (action.name) {
            case 'edit_details':
                component.set("v.newVisaAttribute.visaInviteNum",row.Visa_Invite_Number__c);
                component.set("v.newVisaAttribute.visaInviteCountry",row.Country__r.Name);
                //alert(row.Email_Notification_Id__c);
                component.set("v.newVisaAttribute.emailNotificationId",row.Email_Notification_Id__c);
                component.set("v.newVisaAttribute.hospitalCode", row.Hospital_Code__c);
                component.set("v.newVisaAttribute.recordId", row.Id);
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
                break;

        }
    }
})