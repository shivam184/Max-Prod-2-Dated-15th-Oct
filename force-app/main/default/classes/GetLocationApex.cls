public class GetLocationApex {
    
    @AuraEnabled
    public static String fetchLocationAddress(Decimal lat,Decimal lon) {
        System.debug('lat-->'+lat);
        System.debug('lon-->'+lon);
        if(lat != NULL && lon != NULL) {
            String address='';
            String url = 'https://maps.googleapis.com/maps/api/geocode/json?&key='+Label.ApiKey+'&latlng=' + String.valueOf(lat) + ',' + String.valueOf(lon) + '&sensor=true';
            Http httpProtocol = new Http();
            
            HttpRequest request = new HttpRequest();    
            request.setEndPoint(url);
            request.setMethod('GET');
            request.setTimeout(100000);
            HttpResponse response = httpProtocol.send(request);
            system.debug('response.getBody()-->'+response.getBody());
            JSON2ApexParser.JSON2Apex japx = new JSON2ApexParser.JSON2Apex();
            japx = JSON2ApexParser.parse(response.getBody());
            system.debug('japx-->'+japx);
            if(japx.status=='OK'){
                if(japx.results!=null && japx.results.size()>0){
                    if(japx.results[0].formatted_address!=null){
                        address = japx.results[0].formatted_address;
                    }
                }
            }
            return address;    
        }
        else {
            return 'Latitude and Longitude Not Captured Successfully';
        }
        
    }
    
    @AuraEnabled 
    public static void saveLocationApex(Id accId,Decimal lat,Decimal lon,String address){
        System.debug('accId-->'+accId);
        System.debug('lat-->'+lat);
        System.debug('lon-->'+lon);
        System.debug('address-->'+address);
        Account acc = new Account();
        acc.Id = accId;
        acc.Office_Geolocation__Latitude__s = lat;
        acc.Office_Geolocation__Longitude__s = lon;
        acc.Address_From_Geolocation__c = address;
        update acc;
    }
    
    @AuraEnabled
    public static String getLocationFromBillingAddress(String billingAddress) {
        System.debug('billingAddress-->'+billingAddress);
        
        billingAddress = billingAddress.replaceAll(' ','+');
        String url = 'https://maps.googleapis.com/maps/api/geocode/json?address=';
        url += billingAddress;
        url += '&key=AIzaSyBvZEGn5jPzfm9QnGB1we3_Rb7TO0vDqtM';
            
        //url += '&key=AIzaSyCriVdAeSSgiSAWUwdikYMH5nVy8MkTq3k';
        //url += '&key=AIzaSyD-PcqkWbvcOHAOLKxaDPrOp6u33bm2S1Q';
        //AIzaSyCwugLqQde_DRwV-mCwBlj1E8JizlySCUI
        //AIzaSyDJP-O5K8mkwHkkDKzE6plJd6kO8vp7AgM
        //AIzaSyAP5Bnh1jXpI2crcyd8CMJYSV9P8RH8Ip4
        //AIzaSyAYC7iRCjRnnW6FDnYBDKlzPofv_aoYvX8
        // System.debug('url-->'+url);
        
        Http h = new Http();
        
        // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('GET');
        
        // Send the request, and return a response
        HttpResponse res = h.send(req);
        system.debug('response----'+res.getBody());
        JSON2ApexParser.JSON2Apex japx = new JSON2ApexParser.JSON2Apex();
        japx = JSON2ApexParser.parse(res.getBody());
        //system.debug('====japx='+japx);
       // System.debug('Lat-->'+japx.results[0].geometry.location.lat);
        //System.debug('Lng-->'+japx.results[0].geometry.location.lng);
       // System.debug('Address-->'+japx.results[0].formatted_address);
       String address = '';
        if(!Test.isRunningTest())
        	address = String.valueOf(japx.results[0].geometry.location.lat)+'*'+String.valueOf(japx.results[0].geometry.location.lng)+'*'+String.valueOf(japx.results[0].formatted_address);
        return address;
    }
    
    @AuraEnabled
    public static void saveBillingLocationApex(Id accId,Decimal lat,Decimal lon,String address,String billingStreet,String billingCity,String billingState,String billingCountry,String billingPostalCode) {
        System.debug('accId-->'+accId);
        System.debug('lat-->'+lat);
        System.debug('lon-->'+lon);
        System.debug('address-->'+address);
        System.debug('billingStreet-->'+billingStreet);
        System.debug('billingCity-->'+billingCity);
        System.debug('billingState-->'+billingState);
        System.debug('billingCountry-->'+billingCountry);
        System.debug('billingPostalCode-->'+billingPostalCode);
        
        Account acc = new Account();
        acc.Id = accId;
        acc.Office_Geolocation__Latitude__s = lat;
        acc.Office_Geolocation__Longitude__s = lon;
        acc.Address_From_Geolocation__c = address;
        acc.BillingStreet = billingStreet;
        acc.BillingCity = billingCity;
        acc.BillingState = billingState;
        acc.BillingCountry = billingCountry;
        acc.BillingPostalCode = billingPostalCode;
        update acc;
    }
}