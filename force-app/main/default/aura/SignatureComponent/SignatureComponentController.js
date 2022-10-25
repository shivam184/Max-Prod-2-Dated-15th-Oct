({
    Init : function(component, event, helper) {
        helper.doInit(component, event, helper);
    },
    erase: function(component, event, helper){
        helper.eraseHelper(component, event, helper);
    },
    save: function(component, event, helper){
        helper.saveHelper(component, event, helper,'close');
    },
    saveandGenerate : function(component, event, helper){
        helper.saveHelper(component, event, helper,'generate');
    },
    confirmClear : function(component,event,helper){
        component.set("v.showDialog",true);
    }
})