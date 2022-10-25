({
    waitingTimeId: null,
    setStartTimeOnUI : function(component) {
        component.set("v.ltngIsDisplayed",true);
        var currTime =component.get("v.ltngCurrTime");
        var ss = currTime.split(":");
        var dt = new Date();
        dt.setHours(ss[0]);
        dt.setMinutes(ss[1]);
        dt.setSeconds(ss[2]);
        
        var dt2 = new Date(dt.valueOf() + 1000);
        var temp = dt2.toTimeString().split(" ");
        var ts = temp[0].split(":");
        
        component.set("v.ltngCurrTime",ts[0] + ":" + ts[1] + ":" + ts[2]);
        this.waitingTimeId =setTimeout($A.getCallback(() => this.setStartTimeOnUI(component)), 1000);
    },
    setStopTimeOnUI : function(component) {
        component.set("v.ltngIsDisplayed",false);
        window.clearTimeout(this.waitingTimeId);
    },
    setResetTimeOnUI : function(component) {
        component.set("v.ltngIsDisplayed",false);
        component.set("v.ltngCurrTime","00:00:00");
        window.clearTimeout(this.waitingTimeId);
    },
    
    getCurrentTime : function(component,event,helper) {
        var dt = new Date();
        var hours = dt.getHours();
        var minutes = dt.getMinutes();
        var ampm = hours >= 12 ? 'PM' : 'AM';
        hours = hours % 12;
        hours = hours ? hours : 12; // the hour '0' should be '12'
        minutes = minutes < 10 ? '0'+minutes : minutes;
        var strTime = hours + ':' + minutes + ' ' + ampm;
        component.set("v.currentTime",strTime);
    }
})