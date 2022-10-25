/**	 * 
	Description : this class used for SMS URL short via bitly API.
	Author : Suraj Gurung
	Date : 21APR2021
*/	

public class BitlyService {	    
       
    public Static String shorten(String url) {
        HttpRequest req = new HttpRequest();	        
        req.setEndpoint('callout:Bitly/v4/shorten');	        
        req.setMethod('POST');	        
        req.setHeader('Authorization', 'Bearer {!$Credential.Password}');	        
        req.setHeader('Accept', 'application/json');	        
        req.setHeader('Content-Type', 'application/json');	        
        req.setBody(JSON.serialize(new Map<String, Object>{	            
            'group_guid' => '{!$Credential.UserName}',	            
                'long_url' => url	        
                }));	
        
        HttpResponse res = new Http().send(req);
        Map<String, Object> response = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());	        
        return (String) response.get('link');	    
    }	
}