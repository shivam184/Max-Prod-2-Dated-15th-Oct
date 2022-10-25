({
    doInit : function(component, event, helper) {
        helper.doInitHelper1(component, event); 
        helper.FatchVital(component, event);
        helper.fillPickList(component, event);
        helper.genderPickList(component,event);
        helper.familySymptompsPickList(component,event);
        helper.fillWorseningSympPickList(component,event);
    },
    addRow: function(component, event, helper) {
        
        helper.addAccountRecord(component, event);
    },
    closeModel: function(component, event, helper) {
       component.set("v.isModalOpen",false);
        
        window.location.href = "https://www.maxhealthcare.in";
        //https://www.google.com/
    },
    removeRow: function(component, event, helper) {
        var VitalList = component.get("v.VitalList");
        var selectedItem = event.currentTarget;
        var index = selectedItem.dataset.record;
        VitalList.splice(index, 1);
        component.set("v.VitalList", VitalList);
    },
    selectDeveloping: function(component, event, helper) {
        /*var oRes=component.get("v.VitalList");
        for (var i = 0; i < oRes.length; i++) {
            if(oRes[i].None_of_the_Symptom_at_8_AM__c==true){
                
                alert(i+ " None_of_the_Symptom  ---> "+oRes[i].None_of_the_Symptom_at_8_AM__c)
                 alert(i+ " isDeveloping__c  ---> "+oRes[i].isDeveloping__c)
                oRes[i].isDeveloping__c=true;
            }
        }*/
    },
    save: function(component, event, helper) {
        //if (helper.validateAccountList(component, event)) {
            helper.saveVitalList(component, event);
       // }
    },
    toggleSection : function(component, event, helper) {
        var sectionAuraId = event.target.getAttribute("data-auraId");
        var sectionDiv = document.getElementById(sectionAuraId); 
        var sectionState = sectionDiv.getAttribute('class').search('slds-is-close'); 
        if(sectionState == -1)
            sectionDiv.setAttribute('class' , 'slds-section slds-is-close');
        else
            sectionDiv.setAttribute('class' , 'slds-section slds-is-open');
        
    },
    handleSymptompsOnChange:function(component, event, helper) {
        var a = event.getSource();
        var id = a.getLocalId();
      // alert(id);
        //alert(component.get("v.Genger"));
    },
    handleWorseningSymptompsOnChange:function(component, event, helper) {
        //var a = event.getSource();
       // var id = a.getLocalId();
      /// alert(id);
     // var selectedOptionValue = event.getParam("value");
      //  alert("Option selected with value: '" + selectedOptionValue.toString() + "'");
    },
    handleFamilySymptompOnChange:function(component, event, helper) {
        var a = event.getSource();
        var id = a.getLocalId();
     //  alert(id);
    }
    
})