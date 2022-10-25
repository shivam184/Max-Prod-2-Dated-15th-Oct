({
    init: function (component, event, helper) {
        var action = component.get("c.fetchUserList");
        action.setCallback(this,function(response){
            //alert(JSON.stringify(response.getReturnValue()));
            if(response.getState() === 'SUCCESS') {
                
                var res = response.getReturnValue();
                component.set("v.visitDate",res.yesterdayDate);
                component.set("v.visitDateend",res.todayDate);
                component.set("v.tod",res.todayDate);
                component.set("v.userList",res.usrList);
                console.log('res.usrList-->'+res.usrList);
                component.set("v.mapMarkers",res.actLocWrap);
                component.set("v.mapCenter",{
                    location:{
                        City:'New Delhi'
                    }
                }); 
                component.set('v.markersTitle', 'Related Accounts');
                component.set('v.zoomLevel', 12);
            }
        })
        
        $A.enqueueAction(action);   
        
    },
    
    dateAndUserUpdate:function(component,event,helper){
        if(component.get("v.visitDate") >= component.get("v.visitDateend")){
            document.getElementById("error1").style.display = "block";
        }
        else{
            if(component.get("v.visitDate") < component.get("v.visitDateend")){
                document.getElementById("error1").style.display = "none";
            }
            var action  = component.get("c.getUserAndDateDetails");
            action.setParams({
                "userId" : component.find("select").get("v.value"),
                'startDate': JSON.stringify(component.get('v.visitDate')),
                'endDate': JSON.stringify(component.get('v.visitDateend'))
            });
            action.setCallback(this, function(response){
                //alert(response.getReturnValue());
                if(response.getState()==="SUCCESS"){
                    var res = response.getReturnValue();
                    
                    if(res.actLocWrap.length>0){
                        component.set("v.mapMarkers",[]);
                        component.set("v.mapMarkers",res.actLocWrap);
                        component.set("v.mapCenter",{
                            location:{
                                City:'New Delhi'
                            }
                        }); 
                    }
                    else{
                        var showMyToast = $A.get('e.force:showToast');
                        showMyToast.setParams({
                            type:'Warning',
                            title:'Message',
                            message:'No Related Account Found',
                            duration:1000
                        }).fire();
                        
                        
                        component.set("v.mapMarkers",[]);
                        component.set("v.mapCenter",{
                            location:{
                                City:'New Delhi'
                            }
                        }); 
                    }
                    
                    
                }
                
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
                
            });
            component.set('v.markersTitle', 'Related Accounts');
            
            $A.enqueueAction(action); 
        }}
    
    
    
})