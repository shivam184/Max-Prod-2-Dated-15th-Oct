/*
 * Description : Class to fetch route distance and approximate time between two locations from coordinates
 */


public class AcquireDistanceFromLocation {
    public static DistanceAndTime getDistance(LocationCoordinate startLocation, LocationCoordinate endLocation){
        string endpoint = System.Label.baseUrlForDistanceFetch;
        endpoint+='origins='+startLocation.latitude+','+startLocation.longitude;
        endpoint+='&destinations='+endLocation.latitude+','+endLocation.longitude;
        endpoint+='&mode=driving&language=en-EN&sensor=false&key='+Label.ApiKey;
        HTTP http = new HTTP();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('GET');
        system.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>endpoint>>>>>>>>>>>>>>>'+endpoint);
        HttpResponse res = new HttpResponse();
         String body = '';
        if(Test.isRunningTest()){
           // Test.startTest();
            body = '{"destination_addresses" : ["Dadri Main Rd, Bhangel, Sector - 106, Noida, Uttar Pradesh 201304, India"],"origin_addresses" : ["Dadri Main Rd, Bhangel, Sector - 106, Noida, Uttar Pradesh 201304, India"],"rows" : [ {"elements" : [{"distance" : {"text" : "1 m", "value" : 0 },"duration" : { "text" : "1 min","value" : 0},"status" : "OK"}]}],"status" : "OK"}';
           // Test.stopTest();
        }else{
            res = http.send(req);
            if(res.getStatusCode() == 200)
                body = res.getBody();
        }
        system.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>res>>>>>>>>>>>>>>>>>>>>>>>>'+res);
        if(Test.isRunningTest() || res.getStatusCode() == 200){
            system.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>body>>>>>>>>>>>>>>>>>>>>>>>>'+body);
            DistanceDestinationResponceParser parse = DistanceDestinationResponceParser.parse(body);
            System.debug('parse-->'+parse);
            if(parse.rows != NULL && parse.rows.size() > 0 && parse.rows[0].elements != NULL && parse.rows[0].elements.size() > 0 && parse.rows[0].elements[0].distance != NULL && parse.rows[0].elements[0].duration != NULL)
            	return new DistanceAndTime(parse.rows[0].elements[0].distance.value,parse.rows[0].elements[0].duration.value);
            return null;
        }else{
            system.debug('Distance fetching API callout>>>>>>>>>>>>>>>>>>'+res.getStatusCode());
            system.debug('Response Body>>>>>>>>>>>>>>>>>>'+res.getBody());
        }
        
        return null;
    }
}