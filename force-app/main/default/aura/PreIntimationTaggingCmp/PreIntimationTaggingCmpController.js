({
    doInit : function(component, event, helper) {
        component.set('v.firstBlockColumns', [
            {label: 'Max ID', fieldName: 'maxid'},
            {label: 'OP ID', fieldName: 'opid'}, 
            {label: 'IP ID', fieldName: 'ipid'},
            {label: 'Patient', fieldName: 'patient'},
            {label: 'Treating Doctor', fieldName: 'treatingDoctor'},
            {label: 'Speciality', fieldName: 'speciality'},
            {label: 'Coupon Code', fieldName: 'couponcode'},
            {label: 'Date of Admission', fieldName: 'dateofAdmission',type:"date",
             typeAttributes:{
                 month: "2-digit",
                 day: "2-digit",
                 year: "numeric",
                 hour: "2-digit",
                 minute: "2-digit"
             }
             
            },
            {label: 'MECP Source', fieldName: 'mecpsource'}
        ]); 
        
        component.set('v.secondBlockColumns', [
            {label: 'Patient Name', fieldName: 'patientname'},
            {label: 'Sales Person Name', fieldName: 'salespersonname'}, 
            {label: 'Date and Time', fieldName: 'datentime', type: "date",
             typeAttributes:{
                 month: "2-digit",
                 day: "2-digit",
                 year: "numeric",
                 hour: "2-digit",
                 minute: "2-digit"
             }
            },
            {label: 'MECP Name', fieldName: 'mecpname'},
            {label: 'Message', fieldName: 'message'},
            {label: 'Created On', fieldName: 'createdon', type:"date",
             typeAttributes:{ 
                 month: "2-digit",
                 day: "2-digit",
                 year: "numeric",
                 hour: "2-digit",
                 minute: "2-digit"
             }
            },
            {label: 'Document Uploaded', fieldName: 'uploaded'}
        ]);  
        helper.fetchData(component, event);
    },
    
    doRefresh : function(component,event,helper){
        helper.fetchData(component, event);	
    },
    
    doSearch : function(component,event,helper){
        if(event.keyCode == 13) 
            helper.doSearchHelper(component,event);
    },
    
    doTagged : function(component,event,helper) {
        helper.doSearchHelper(component,event);    
    },
    
    tagWithPreIntimation : function(component,event,helper) {
        if(!$A.util.isEmpty(component.get("v.selectedAdmissionId")) && !$A.util.isEmpty(component.get("v.selectedLeadId")) && !component.get("v.tagged")) {
            var modalBody;
            $A.createComponent("c:TagWithPreIntimationComponent", {"selectedAdmissionId" : component.get("v.selectedAdmissionId"),
                                                                   "selectedLeadId" : component.get("v.selectedLeadId")},
                               function(content, status) {
                                   if (status === "SUCCESS") {
                                       modalBody = content;
                                       var modalPromise = component.find('overlayLib').showCustomModal({
                                           body: modalBody, 
                                           showCloseButton: true,
                                           //referenceSelector: ".mymodal3",
                                           //closeCallback: function() {
                                           //alert('You closed the alert!');
                                           //}
                                       });
                                       component.set('v.modalPromise',modalPromise);
                                   }                               
                               }); 
        }   
        else {
            helper.showToast(component,event,'ERROR','Select Admission Acknowledgement and Pre Intimation and mark Tagged checkbox unchecked','error');
        }
    },
    
    tagWithoutPreIntimation : function(component,event,helper) {
        if(!$A.util.isEmpty(component.get("v.selectedAdmissionId"))) {
            let actType = '';
            var action = component.get('c.checkAccountType');
            action.setParams({
                'selAdmId' : component.get('v.selectedAdmissionId')
            });
            action.setCallback(this, function(response){
                if(response.getState()==='SUCCESS'){
                    actType = response.getReturnValue();
                    //alert(actType);
                    helper.checkAccountsType(component,event,actType);
                }
            });
            $A.enqueueAction(action);    
        }
        else {
            helper.showToast(component,event,'ERROR','Select Admission Acknowledgement','error');
        }
    },
    
    untag : function(component,event,helper) {
        if(!$A.util.isEmpty(component.get("v.selectedAdmissionId")) && component.get("v.tagged")) {
            var modalBody;
            $A.createComponent("c:UntagComponent", {"selectedAdmissionId" : component.get("v.selectedAdmissionId")},
                               function(content, status) {
                                   if (status === "SUCCESS") {
                                       modalBody = content;
                                       var modalPromise = component.find('overlayLib').showCustomModal({
                                           body: modalBody, 
                                           showCloseButton: true,
                                           //referenceSelector: ".mymodal3",
                                           //closeCallback: function() {
                                           //alert('You closed the alert!');
                                           //}
                                       });
                                       component.set('v.modalPromise',modalPromise);
                                   }                               
                               });	    
        } 
        else {
            helper.showToast(component,event,'ERROR','Select Admission Acknowledgement and mark Tagged checkbox checked','error');    
        }
    },
    
    doGetMecp : function(component,event,helper) {
        if(event.keyCode == 13) {
            if(component.get("v.tagged") && component.get("v.mecpName").length > 0)
                helper.doGetMecpHelper(component,event);
            else
                helper.showToast(component,event,'ERROR','Check Tagged Checkbox and Fill Mecp Name','error');
        }
    },
    
    handleMECPId : function(component,event,helper) {
        component.set("v.selectedMECPId",event.getParam("message"));
        component.set("v.mecpName",event.getParam("message1"));
        helper.doSearchHelper(component,event); 
    },
    
    doUpdateMECPId : function(component,event,helper) {
        component.set("v.selectedMECPId","");
    },
    
    doGetPatientName : function(component,event,helper) {
        if(event.keyCode == 13)
            //if(!$A.util.isEmpty(component.get("v.patientNameLead")))
            helper.fetchData(component, event);
    },
    
    retagging : function(component,event,helper) {
        if(!$A.util.isEmpty(component.get("v.selectedAdmissionId")) && component.get("v.tagged")) {
            var modalBody;
            $A.createComponent("c:TagWithPreIntimationComponent", {"selectedAdmissionId" : component.get("v.selectedAdmissionId"),
                                                                   "retag" : true},
                               function(content, status) {
                                   if (status === "SUCCESS") {
                                       modalBody = content;
                                       var modalPromise = component.find('overlayLib').showCustomModal({
                                           body: modalBody, 
                                           showCloseButton: true,
                                           //referenceSelector: ".mymodal3",
                                           //closeCallback: function() {
                                           //alert('You closed the alert!');
                                           //}
                                       });
                                       component.set('v.modalPromise',modalPromise);
                                   }                               
                               });		    
        }
        else {
            helper.showToast(component,event,'ERROR','Check Tagged Checkbox and Select Admission Acknowledgement','error');		    
        }
    },
    
    handleEvent : function(component,event,helper) {
    	component.set("v.fromEvent",event.getParam("fromEvent"));
        helper.fetchData(component, event);
    }
})