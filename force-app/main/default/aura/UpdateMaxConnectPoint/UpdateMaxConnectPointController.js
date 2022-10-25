({
    openSpinnerComp : function(component, event, helper) {
        
        $A.createComponents([["c:ShowSpinner",{}]],function(content, status){
            if (status === "SUCCESS") {
                component.find('overlayLib').showCustomModal({
                    header: "Please Wait...",
                    body:content, 
                    showCloseButton: true,
                    cssClass: "my-modal,my-custom-class,my-other-class", 
                    
                }).then(function (overlay) {
                    //closes the modal immediately
                    setTimeout(function(){ 
                //close the popover after 3 seconds
                overlay.close(); 
            }, 700);
                });
                
            }
        })
    }
    
})