public class GeotagLocationApex {

    @auraEnabled
    public static String saveDataApex(Decimal latitude,Decimal longitude,String recordId) {
        try {
        	Customer_Activation__c ca = new Customer_Activation__c();
            ca.Location1__Latitude__s = latitude;
            ca.Location1__Longitude__s = longitude;
            ca.Id = recordId; 
            
            String address = TodayPlanApexController.fetchLocationAddress(String.valueOf(latitude),String.valueOf(longitude));
            if(!String.isBlank(address))
                ca.Address__c = address;
            
            update ca;
            
            return 'SUCCESS';
        }
        catch(Exception e) {
            return 'ERROR:'+e.getMessage();
        }
    }
}