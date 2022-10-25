({
    getLocation : function(component,event,helper) {
        if (navigator.geolocation) { 
            navigator.geolocation.getCurrentPosition(function(e) {
                component.set("v.longitude",e.coords.longitude);
                component.set("v.latitude",e.coords.latitude);
                helper.saveData(component,event);
            }, function(error) {
                var msg = '';
                switch(error.code) {
                    case error.PERMISSION_DENIED:
                        msg = "User denied the request for Geolocation.";
                        break;
                    case error.POSITION_UNAVAILABLE:
                        msg = "Location information is unavailable.";
                        break;
                    case error.TIMEOUT:
                        msg = "The request to get user location timed out.";
                        break;
                    case error.UNKNOWN_ERROR:
                        msg= "An unknown error occurred.";
                        break;
                }
            });
        }
    }
})