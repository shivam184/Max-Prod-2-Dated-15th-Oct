({
    doInit: function(component, event, helper) {
        helper.doInitHelper(component, event);
        helper.fillPickList(component, event);
        helper.genderPickList(component,event);
        helper.familySymptompsPickList(component,event);
        helper.fillWorseningSympPickList(component,event);
    },
    fncOpenRecord: function(component, event, helper) {
        var selectedItem = event.currentTarget;
        var sRecordId = selectedItem.getAttribute("Data-userinput");
        helper.UserDetails(component, event,sRecordId);
        helper.UserPrescriptionDetails(component, event,sRecordId); 
    },
    closeModel: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        component.set("v.isOpen", false);
    },
    
    save: function(component, event, helper) {
        //alert('Save in controller');
        helper.saveVitalList(component, event, helper); 
    },
    /* javaScript function for pagination */
    navigation: function(component, event, helper) {
        var sObjectList = component.get("v.listOfAllAccounts");
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSize");
        var whichBtn = event.getSource().get("v.name");
        // check if whichBtn value is 'next' then call 'next' helper method
        if (whichBtn == 'next') {
            component.set("v.currentPage", component.get("v.currentPage") + 1);
            helper.next(component, event, sObjectList, end, start, pageSize);
        }
        // check if whichBtn value is 'previous' then call 'previous' helper method
        else if (whichBtn == 'previous') {
            component.set("v.currentPage", component.get("v.currentPage") - 1);
            helper.previous(component, event, sObjectList, end, start, pageSize);
        }
    },
    
    selectDeveloping: function(component, event, helper) {
        
        //alert('Hiiii....'+component.find("None8AM").get("v.checked"))
        if(component.find("None8AM").get("v.checked")==true)
            component.set("v.DevelopingCheckBox8AM",false);
        if(component.find("None8AM").get("v.checked")==false)
            component.set("v.DevelopingCheckBox8AM",true);  
    },
    selectDeveloping2PM: function(component, event, helper) {
        if(component.find("None2PM").get("v.checked")==true)
            component.set("v.DevelopingCheckBox2PM",false);
        if(component.find("None2PM").get("v.checked")==false)
            component.set("v.DevelopingCheckBox2PM",true);
    },
     selectDeveloping8PM: function(component, event, helper) {
        if(component.find("None8PM").get("v.checked")==true)
            component.set("v.DevelopingCheckBox8PM",false);
        if(component.find("None8PM").get("v.checked")==false)
            component.set("v.DevelopingCheckBox8PM",true);
    },
    
    selectAllCheckbox: function(component, event, helper) {
        var selectedHeaderCheck = event.getSource().get("v.value");
        var updatedAllRecords = [];
        var updatedPaginationList = [];
        var listOfAllAccounts = component.get("v.listOfAllAccounts");
        var PaginationList = component.get("v.PaginationList");
        // play a for loop on all records list 
        for (var i = 0; i < listOfAllAccounts.length; i++) {

            if (selectedHeaderCheck == true) {
                listOfAllAccounts[i].isChecked = true;
                component.set("v.selectedCount", listOfAllAccounts.length);
            } else {
                listOfAllAccounts[i].isChecked = false;
                component.set("v.selectedCount", 0);
            }
            updatedAllRecords.push(listOfAllAccounts[i]);
        }
        // update the checkbox for 'PaginationList' based on header checbox 
        for (var i = 0; i < PaginationList.length; i++) {
            if (selectedHeaderCheck == true) {
                PaginationList[i].isChecked = true;
            } else {
                PaginationList[i].isChecked = false;
            }
            updatedPaginationList.push(PaginationList[i]);
        }
        component.set("v.listOfAllAccounts", updatedAllRecords);
        component.set("v.PaginationList", updatedPaginationList);
    },
    
    checkboxSelect: function(component, event, helper) {
        // on each checkbox selection update the selected record count 
        var selectedRec = event.getSource().get("v.value");
        var getSelectedNumber = component.get("v.selectedCount");
        if (selectedRec == true) {
            getSelectedNumber++;
        } else {
            getSelectedNumber--;
            component.find("selectAllId").set("v.value", false);
        }
        component.set("v.selectedCount", getSelectedNumber);
        // if all checkboxes are checked then set header checkbox with true   
        if (getSelectedNumber == component.get("v.totalRecordsCount")) {
            component.find("selectAllId").set("v.value", true);
        }
    },
    
    getSelectedRecords: function(component, event, helper) {
        var allRecords = component.get("v.listOfAllAccounts");
        var selectedRecords = [];
        for (var i = 0; i < allRecords.length; i++) {
            if (allRecords[i].isChecked) {
                selectedRecords.push(allRecords[i].objAccount);
            }
        }
        alert(JSON.stringify(selectedRecords));
    },
    toggleSection : function(component, event, helper) {
        var sectionAuraId = event.target.getAttribute("data-auraId");
        var sectionDiv = component.find(sectionAuraId).getElement();
        var sectionState = sectionDiv.getAttribute('class').search('slds-is-close'); 
        
        // -1 if 'slds-is-open' class is missing...then set 'slds-is-open' class else set slds-is-close class to element
        if(sectionState == -1){
            sectionDiv.setAttribute('class' , 'slds-section slds-is-close');
        }else{
            sectionDiv.setAttribute('class' , 'slds-section slds-is-open');
        }
    }
})