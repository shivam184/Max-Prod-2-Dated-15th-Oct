public class OutboundAPIUtilityController {
    
    //Variable to store the End Point of API call
    public static String endpoint;
	//Variable to store the api key of API request header
    public static String api_key;
    //Variable to store the salt of API request header
    public static String salt;
    //Variable to store the source of API request header
    public static String source;
    
    
    //API Headers (Static)
    public static String dtFormat;
	public static String apikeyHeader;
    public static String timeStampHeader;
    public static String signatureHeader; 
    
    
    //Method to fetch API detils to be used in API callout headers
    public static void fetchDetailsFromMetadata(String apiMethod){
        //Filling in API details
        for(Max_Healthcare_Outbound_APIs__mdt maxApi : [SELECT Id,MasterLabel,API_Key__c,End_Point__c ,Salt__c ,Source__c 
                                                        FROM Max_Healthcare_Outbound_APIs__mdt]){
        	if(String.isNotBlank(maxApi.End_Point__c))
                endpoint = maxApi.End_Point__c;
            if(String.isNotBlank(maxApi.API_Key__c))
                api_key = maxApi.API_Key__c;
            if(String.isNotBlank(maxApi.Salt__c))
                salt = maxApi.Salt__c;
            if(String.isNotBlank(maxApi.Source__c))
                source =maxApi.Source__c;
        }
        if(String.isNotBlank(apiMethod))
            endpoint+=apiMethod;
        
        //Fetching header details
        for(Max_Healthcare_API_Headers__mdt apiHeader : [SELECT Id,MasterLabel,Date_Time_Format__c ,API_Key_Header__c, 
                                                         Time_Stamp_Header__c,Signature_Header__c FROM
                                                         Max_Healthcare_API_Headers__mdt]){
            if(String.isNotBlank(apiHeader.Date_Time_Format__c))
                dtFormat = apiHeader.Date_Time_Format__c;
            if(String.isNotBlank(apiHeader.API_Key_Header__c))
                apikeyHeader = apiHeader.API_Key_Header__c;
            if(String.isNotBlank(apiHeader.Time_Stamp_Header__c))
                timeStampHeader = apiHeader.Time_Stamp_Header__c;
            if(String.isNotBlank(apiHeader.Signature_Header__c))
                signatureHeader =apiHeader.Signature_Header__c;
        }
    }
    
    
    public static Map<String,Object> doOutboundApiCall(String apiMethod,String jsonBody,String searchValue,String methodType){
        fetchDetailsFromMetadata(apiMethod);
        String signature = generateSignature(apiMethod,searchValue);
        //API Call       
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setHeader(apikeyHeader,api_key);
        request.setHeader(timeStampHeader,system.now().format(dtFormat));
        request.setHeader(signatureHeader,signature);
        request.setHeader('Content-Type', 'application/json');
        request.setEndpoint(endpoint);
        request.setMethod(methodType);
        request.setBody(jsonBody);
        
        HttpResponse response = new HttpResponse();
        
        if(!test.isRunningTest()){
            response = Http.send(request);
            if(response.getStatusCode()==200){
             	return (Map<String,Object>)JSON.deserializeUntyped(response.getBody());   
            }
        }
        else{
            
        }
        return NULL;
    }
    
    //Method to generate signature
    public static String generateSignature(String apiMethod,String searchValue){
        String data = api_key+'|'+apiMethod+'|'+searchValue+'|'+system.now().format(dtFormat)+'|'+salt;
        Blob tempBlob = Blob.valueOf(data);
        Blob encryptedData = Crypto.generateDigest('SHA-512', tempBlob);
        return EncodingUtil.convertToHex(encryptedData);
    }
}