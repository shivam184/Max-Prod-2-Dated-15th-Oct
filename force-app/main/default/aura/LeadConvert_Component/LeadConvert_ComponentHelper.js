({
    chechValidation : function(component,event,jsonWrap) {
        var isBalnk = false;
        if($A.util.isEmpty(jsonWrap.accName) && !component.find("exisAcc").get("v.checked")){
            //document.getElementById("error1").style.display = "block";
            isBalnk = true;
        }
        if(component.find("exisAcc").get("v.checked") && $A.util.isEmpty(jsonWrap.accountId)){
            document.getElementById("error2").style.display = "block";
            isBalnk = true;
        }
        if($A.util.isEmpty(jsonWrap.lead.Name) && !component.find("exisCon").get("v.checked") && !component.find("conchk").get("v.checked")){
            //document.getElementById("error3").style.display = "block";
            isBalnk = true;
        }
        if(component.find("exisCon").get("v.checked") && $A.util.isEmpty(jsonWrap.contId)){
            document.getElementById("error4").style.display = "block";
            isBalnk = true;
        }
        if($A.util.isEmpty(jsonWrap.oppName) && !component.find("exisOpp").get("v.checked") && !component.find("oppchk").get("v.checked")){
            //document.getElementById("error5").style.display = "block";
            isBalnk = true;
        }
        if(component.find("exisOpp").get("v.checked") && $A.util.isEmpty(jsonWrap.oppId)){
            document.getElementById("error6").style.display = "block";
            isBalnk = true;
        }
        return isBalnk;
    },
    
    showToast : function(component,event,title,type,message){
        $A.get("e.force:closeQuickAction").fire();
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "type" : type,
            "message": message
        });
        toastEvent.fire();
    }
})