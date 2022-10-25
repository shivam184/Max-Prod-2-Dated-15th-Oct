({
    /* doInitHelper funcation to fetch all records, and set attributes value on component load */
    doInitHelper : function(component,event){ 
        component.set("v.spinner", true); 
       // alert('@Record Id -->  '+component.get("v.recordId"))
        var action = component.get("c.fetchAccountWrapper");
         action.setParams({
            "sRecordId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            component.set("v.spinner", false);
            if (state === "SUCCESS"){
                var oRes = response.getReturnValue();
                if(oRes.length > 0){
                    
                    component.set('v.listOfAllAccounts', oRes);
                    var pageSize = component.get("v.pageSize");
                    var totalRecordsList = oRes;
                    var totalLength = totalRecordsList.length ;
                    component.set("v.totalRecordsCount", totalLength);
                    component.set("v.startPage",0);
                    component.set("v.endPage",pageSize-1);
                    
                    var PaginationLst = [];
                    for(var i=0; i < pageSize; i++){
                        if(component.get("v.listOfAllAccounts").length > i){
                            PaginationLst.push(oRes[i]);    
                        } 
                    }
                    
               
                    component.set('v.PaginationList', oRes);
                    component.set("v.selectedCount" , 0);
                    //use Math.ceil() to Round a number upward to its nearest integer
                    component.set("v.totalPagesCount", Math.ceil(totalLength / pageSize));    
                }else{
                    // if there is no records then display message
                    component.set("v.bNoRecordsFound" , true);
                } 
            }
            else{
               // alert('Error...');
            }
        });
        $A.enqueueAction(action);  
    },
    UserDetails : function(component, event,sRecordId){
        //alert('sRecordId---->>>> helper '+sRecordId);
        //alert('sRecordId---->>>> '+ component.get("v.VitalUser",sRecordId));
        var action = component.get("c.fncGetUserDetails");
        action.setParams({
            "sRecordId": sRecordId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var oRes = response.getReturnValue();
                // alert('state ---->>>> '+state  +'oRes.length--- >  '+oRes.length );
                if(oRes.length > 0){
                    var date = new Date();
                    var date1=$A.localizationService.formatDate(date, "yyyy-MM-dd");
                    var date2 = new Date(oRes[0].Date__c);
                    date2=$A.localizationService.formatDate(date2, "yyyy-MM-dd");
                    if (Date.parse(date2) === Date.parse(date1)){ 
                        oRes[0].EnableRecord__c=false;
                    }else{
                        oRes[0].EnableRecord__c=true;
                    }
                    
                    if(oRes[0].None_of_the_Symptom_at_8_AM__c)
                        component.set("v.DevelopingCheckBox8AM",true);
                    if(oRes[0].None_of_the_Symptom_at_2_PM__c)
                        component.set("v.DevelopingCheckBox2PM",true);
                    if(oRes[0].None_of_the_Symptom_at_8_PM__c)
                        component.set("v.DevelopingCheckBox8PM",true);
                    component.set('v.listVital', oRes);
                    component.set("v.isOpen",true);
                }
            }
        });
        $A.enqueueAction(action); 
    },
    UserPrescriptionDetails : function(component, event,sRecordId){
        //alert('sRecordId---->>>> helper '+sRecordId);
        //alert('sRecordId---->>>> '+ component.get("v.VitalUser",sRecordId));
        var action = component.get("c.fncGetPrescription");
        action.setParams({
            "sRecordId": sRecordId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var oRes = response.getReturnValue();
                if(oRes.length > 0){
                    var sComorbidities='';
                    if(oRes[0].Diabetes__c){
                        sComorbidities ='Diabetes';
                    }
                    if(oRes[0].Hypertension__c){
                        if(sComorbidities!=''){
                            sComorbidities+=', Hypertension';    
                        }else{
                            sComorbidities+='Hypertension';
                        } 
                    }
                    if(oRes[0].Immunosuppession__c){
                        if(sComorbidities!=''){
                            sComorbidities+=', Immunosuppession';    
                        }else{
                            sComorbidities+='Immunosuppession';
                        } 
                    }
                    if(oRes[0].Pregenancy__c){
                        if(sComorbidities!=''){
                            sComorbidities+=', Pregenancy';    
                        }else{
                            sComorbidities+='Pregenancy';
                        } 
                    }
                    if(oRes[0].Cancer__c){
                        if(sComorbidities!=''){
                            sComorbidities+=', Cancer';    
                        }else{
                            sComorbidities+='Cancer';
                        } 
                    }
                    if(oRes[0].CKD__c){
                        if(sComorbidities!=''){
                            sComorbidities+=', CKD';    
                        }else{
                            sComorbidities+='CKD';
                        } 
                    }
                    if(oRes[0].Obesity__c){
                        if(sComorbidities!=''){
                            sComorbidities+=', Obesity';    
                        }else{
                            sComorbidities+='Obesity';
                        } 
                    }
                    if(oRes[0].COPD_Asthama__c){
                        if(sComorbidities!=''){
                            sComorbidities+=', COPD Asthama';    
                        }else{
                            sComorbidities+='COPD Asthama';
                        } 
                    }
                   //alert('oRes[0].Any_Other_Comorbities__c--->> '+oRes[0].Any_Other_Comorbities__c)
                    if(oRes[0].Any_Other_Comorbities__c!=undefined){
                        //if(sComorbidities==''){
                         //   sComorbidities+=' None';    
                       // }else{
                            sComorbidities+=','+oRes[0].Any_Other_Comorbities__c;
                       // } 
                    }
                    
                  //  alert('sComorbidities--->>> '+sComorbidities)
                    
                    component.set('v.strComorbidities', sComorbidities);
                    
                    component.set('v.listPrescription', oRes);
                }
            }
        });
        $A.enqueueAction(action); 
    },
    saveVitalList: function(component, event, helper) {
        //alert('Save in Helper');
        //alert('Save List --->>> '+JSON.stringify(component.get("v.listVital")))
        var action = component.get('c.saveVital');
        action.setParams({
            "lstRecVitalWrapper": JSON.stringify(component.get("v.listVital"))
        });
        action.setCallback(this, function(response){
            //alert('response --->> '+response);
            //alert('getState --->> '+response.getState());
            if(response.getState()==='SUCCESS'){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": 'SUCCESS',
                    "message": 'Records update succesully..',
                    "type" : 'SUCCESS'
                });
                toastEvent.fire();
                
                var navEvent = $A.get("e.force:navigateToList");
                navEvent.setParams({
                    "listViewId": '00BN0000003ok9ZMAQ',
                    "listViewName": null,
                    "scope": "Max_at_Home_Enquiry_Page__c"
                });
                navEvent.fire();  
        
            }else{
                
            }
        });
        $A.enqueueAction(action); 
    },
    // navigate to next pagination record set   
    next : function(component,event,sObjectList,end,start,pageSize){
        var Paginationlist = [];
        var counter = 0;
        for(var i = end + 1; i < end + pageSize + 1; i++){
            if(sObjectList.length > i){ 
                if(component.find("selectAllId").get("v.value")){
                    Paginationlist.push(sObjectList[i]);
                }else{
                    Paginationlist.push(sObjectList[i]);  
                }
            }
            counter ++ ;
        }
        start = start + counter;
        end = end + counter;
        component.set("v.startPage",start);
        component.set("v.endPage",end);
        component.set('v.PaginationList', Paginationlist);
    },
    // navigate to previous pagination record set   
    previous : function(component,event,sObjectList,end,start,pageSize){
        var Paginationlist = [];
        var counter = 0;
        for(var i= start-pageSize; i < start ; i++){
            if(i > -1){
                if(component.find("selectAllId").get("v.value")){
                    Paginationlist.push(sObjectList[i]);
                }else{
                    Paginationlist.push(sObjectList[i]); 
                }
                counter ++;
            }else{
                start++;
            }
        }
        start = start - counter;
        end = end - counter;
        component.set("v.startPage",start);
        component.set("v.endPage",end);
        component.set('v.PaginationList', Paginationlist);
    },
    genderPickList: function(component, event, helper) {
        var action = component.get("c.getGender");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var gender = [];
                for(var key in result){
                    gender.push({key: key, value: result[key]});
                }
                component.set("v.gender", gender);
            }
        });
        $A.enqueueAction(action);
    },
    
    familySymptompsPickList: function(component, event, helper) {
        var action = component.get("c.getFamilySymptomps");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var familyMemberSymptomps = [];
                for(var key in result){
                    familyMemberSymptomps.push({key: key, value: result[key]});
                }
                component.set("v.familyMemberSymptomps", familyMemberSymptomps);
            }
        });
        $A.enqueueAction(action);
    },
    
    fillPickList: function(component, event, helper) {
        var action = component.get("c.getDevelopingsymptoms");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var symptomps = [];
                for(var key in result){
                    symptomps.push({key: key, value: result[key]});
                }
                component.set("v.symptomps", symptomps);
            }
        });
        $A.enqueueAction(action);
    },
    fillWorseningSympPickList: function(component, event, helper) {
        var action = component.get("c.getWorseningsymptoms");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var WorseningSymptomps = [];
                for(var key in result){
                    WorseningSymptomps.push({label: key, value: result[key]});
                }
                component.set("v.WorseningSymptomps", WorseningSymptomps);
            }
        });
        $A.enqueueAction(action);
    }
})