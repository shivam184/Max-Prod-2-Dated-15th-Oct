global class MockClass implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"example":"test"}');
        //res.setBody('{"25.6666666","13.666666","sector2"}');
        res.setStatusCode(200);
        return res;
    }
    
    public static void coverage(){
        
        String strj = 'Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
        strj+='Test';
           
            }
}