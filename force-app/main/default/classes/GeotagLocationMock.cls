@isTest
global class GeotagLocationMock  implements HttpCalloutMock{
    
     global HTTPResponse respond(HTTPRequest req) {                
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"15.5":"20.2"}');
        res.setStatusCode(200);
        return res;
    }

}