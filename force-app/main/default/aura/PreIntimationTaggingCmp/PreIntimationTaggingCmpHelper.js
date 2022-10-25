({
    fetchData : function(component, event) {
        
        var spinner = component.find("mySpinner");
        $A.util.removeClass(spinner,"slds-hide");
        var action = component.get("c.fetchDataApex");
        
        if(component.get("v.fromEvent")) {
        	component.set("v.selectedUserId","");
            component.set("v.patientNameLead","");
            component.set("v.mecpAccountName","");
        }
        
        action.setParams({
            "selectedUserId" : component.get("v.selectedUserId"),
            "patientNameLead" : component.get("v.patientNameLead"),
            "mecpAccountName" : component.get("v.mecpAccountName")
        });
        action.setCallback(this,function(response){
            if(response.getState() === "SUCCESS") {
                if(response.getReturnValue().status.includes("SUCCESS")) {
                    component.set("v.data",null);
                    var data = [];
                    for(var i=0; i<response.getReturnValue().listLeadOfMecpType.length;i++) {
                        var mecpScope;
                        if(!$A.util.isEmpty(response.getReturnValue().listLeadOfMecpType[i].MECP_Name__c))
                            mecpScope = response.getReturnValue().listLeadOfMecpType[i].MECP_Name__r.Name;
                        else
                            mecpScope = response.getReturnValue().listLeadOfMecpType[i].MECP_Source__c;
                        var x = {
                            'patientname' : response.getReturnValue().listLeadOfMecpType[i].Name,
                            'salespersonname' : response.getReturnValue().listLeadOfMecpType[i].Owner.Name,
                            'datentime' : response.getReturnValue().listLeadOfMecpType[i].Intimation_Date_Time__c,
                            'mecpname' : mecpScope,
                            'message' : response.getReturnValue().listLeadOfMecpType[i].Ailment__c,
                            'createdon' : response.getReturnValue().listLeadOfMecpType[i].Intimation_Date_Time__c,
                            'uploaded' : response.getReturnValue().listLeadOfMecpType[i].Is_Document_Uploaded__c,
                            'id' : response.getReturnValue().listLeadOfMecpType[i].Id
                        }	
                        data.push(x);
                    }    
                    component.set("v.data",data);
                    component.set("v.data1",null);
                    component.set("v.maxId",null);
                    component.set("v.selectedLeadId",null);
                    component.set("v.selectedAdmissionId",null);
                    component.set("v.tagged",false);
                    component.set("v.patientName",null);
                    component.set("v.treatingDoctorName",null);
                    component.set("v.mecpName",null);
                    
                }
                else {
                    component.set("v.data",null);
                    this.showToast(component,event,'ERROR',response.getReturnValue().status,'error');
                }
                component.set("v.fromEvent",false);
                $A.util.addClass(spinner,"slds-hide");
            }    
        });
        $A.enqueueAction(action);
    },
    
    doSearchHelper : function(component,event) {
        var spinner = component.find("mySpinner");
        $A.util.removeClass(spinner,"slds-hide");
        var action = component.get("c.doSearchApex");
        action.setParams({
            'maxId' : component.get("v.maxId"),
            'patientName' : component.get("v.patientName"),
            'treatingDoctorName' : component.get("v.treatingDoctorName"),
            'selectedMECPId' : component.get("v.selectedMECPId"),
            'tagged' : component.get("v.tagged")
        });
        action.setCallback(this,function(response){
            if(response.getState() === "SUCCESS") {
                if(response.getReturnValue().status.includes("SUCCESS")) {
                    var data = [];
                    for(var i=0; i<response.getReturnValue().listAdmission.length;i++) {
                        var mecpSource='';
                        if(!$A.util.isEmpty(response.getReturnValue().listAdmission[i].MECP_Source__c))
                            mecpSource = response.getReturnValue().listAdmission[i].MECP_Source__r.Name;
                        var speciality ='';
                        if(!$A.util.isEmpty(response.getReturnValue().listAdmission[i].alletec_speciality__c))
                            speciality = response.getReturnValue().listAdmission[i].alletec_speciality__r.Name;
                        var x = {
                            'maxid' : response.getReturnValue().listAdmission[i].Max_ID__c,
                            'opid' : response.getReturnValue().listAdmission[i].OPID__c,
                            'ipid' : response.getReturnValue().listAdmission[i].IPID__c,
                            'patient' : response.getReturnValue().listAdmission[i].Patient_Name__c,
                            'treatingDoctor' : response.getReturnValue().listAdmission[i].Doctor_Name__c,
                            'speciality' : speciality,
                            'couponcode' : response.getReturnValue().listAdmission[i].Coupon_Code__c,
                            'dateofAdmission' : response.getReturnValue().listAdmission[i].Date_Time_of_Admission__c,
                            'mecpsource' : mecpSource,
                            'id' : response.getReturnValue().listAdmission[i].Id
                        }	
                        data.push(x);
                    }    
                    component.set("v.data1",data);    
                }
                else {
                    component.set("v.data1",null);
                    this.showToast(component,event,'ERROR',response.getReturnValue().status,'error')
                }
                $A.util.addClass(spinner,"slds-hide");
            }    
        });
        $A.enqueueAction(action);
    },
    
    showToast : function(component,event,title,message,type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : title,
            message: message,
            type: type
            
        });
        toastEvent.fire();
    },
    
    showPreIntimation : function(component,event) {
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
    },
    
    doGetMecpHelper : function(component,event) {
        var modalBody;
        $A.createComponent("c:ListMECPSourceComponent", {"mecpName" : component.get("v.mecpName")},
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
    },
    
    checkAccountsType : function(component, event, actType){
        if(actType=='YES') {
            var modalBody;
            $A.createComponent("c:TagWithoutPreIntimationComponent", {"selectedAdmissionId" : component.get("v.selectedAdmissionId"),
                                                                      "couponCode" : true},
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
            var modalBody;
            $A.createComponent("c:TagWithoutPreIntimationComponent", {"selectedAdmissionId" : component.get("v.selectedAdmissionId"),
                                                                      "couponCode" : false},
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
    }
})