public class BeatVisitOnGoogleMapController {
    
    @AuraEnabled
    public static visitWrapper fetchUserList(){
        Set<Id> actIdList = new Set<Id>();
        Set<Id> userIds = new Set<Id>();
        List<accountLocationWrapper> oWrapperList = new List<accountLocationWrapper>();
        visitWrapper visitWrap = new VisitWrapper();
        /*
        //---------------Added By Anas Yar Khan (16 March 2019)--------------------------------------
        Set<Id> setEmployeeId = new Set<Id>();
        setEmployeeId.add(UserInfo.getUserId());
        While(setEmployeeId.size() > 0) {
            Set<Id> setEmployeeIdNew = setEmployeeId;
            setEmployeeId.clear();
            for(User usr : [SELECT Id,Name FROM User WHERE ManagerId IN :setEmployeeIdNew])	{
            	visitWrap.usrLisT.add(usr);
            	userIds.add(usr.Id);	
                setEmployeeId.add(usr.Id);
            }				    
        }
        //-----------------------------------------------------------------------------------------
        for(User usr : [SELECT ID,Name FROM User WHERE ManagerId=:UserInfo.getUserId()]){
            visitWrap.usrLisT.add(usr);
            userIds.add(usr.Id);
        }
		*/ 
        
        Map<Id,List<User>> mapManagerIdToListUser = new Map<Id,List<User>>();
        
        for(User u : [SELECT Id,Name,ManagerId FROM USER])
            if(u.ManagerId != NULL) {
                List<User> listUser = new List<User>();
                if(mapManagerIdToListUser.containsKey(u.ManagerId)) 
                	 listUser = mapManagerIdToListUser.get(u.ManagerId);
                listUser.add(u);
                mapManagerIdToListUser.put(u.ManagerId,listUser);
            }
			
		Set<Id> setManagerId = new Set<Id>();
        setManagerId.add(UserInfo.getUserId());
        
        while(setManagerId.size() > 0) {
            set<Id> setManagerIdTemp = new Set<Id>();
            setManagerIdTemp.addAll(setManagerId);
            setManagerId.clear();
            for(Id managerId : setManagerIdTemp) {
                if(mapManagerIdToListUser.containsKey(managerId)) {
                    for(User u : mapManagerIdToListUser.get(managerId)) {
                        visitWrap.usrLisT.add(u);
            			userIds.add(u.Id);
                        setManagerId.add(u.Id);
                    }
                }
            }	    
        }
		        
        
        visitWrap.todayDate = System.today();
        visitWrap.yesterdayDate = System.today()-1;
        
      
        for(Beat_Visit__c acc:[SELECT Account__c,Account__r.OwnerId,Account__r.Name,Checkout_Date_Time__c,Checkin_Location__latitude__s,
                               Account__r.City__c,Account__r.Country__c,Checkin_Address__c,Checkin_Date_Time__c,Checkin_Location__longitude__s
                               from Beat_Visit__c  
                               WHERE Checkin_Date_Time__c >= YESTERDAY  and Checkin_Date_Time__c <= TODAY and CreatedById in:userIds and Checkin_Location__latitude__s!=null and Checkin_Location__longitude__s!=null]){
                                   
                                   
                                   
                                   locationDetailWrapper oLocationWrap = new locationDetailWrapper();
                                   if(acc.Account__r.City__c!=Null)
                                       oLocationWrap.City = acc.Account__r.City__c;
                                   if(acc.Account__r.Country__c!=Null)
                                       oLocationWrap.Country = acc.Account__r.Country__c;
                                   if(acc.Checkin_Location__latitude__s!=Null)
                                       oLocationWrap.Latitude = acc.Checkin_Location__latitude__s;
                                   if(acc.Checkin_Location__longitude__s!=Null)
                                       oLocationWrap.Longitude = acc.Checkin_Location__longitude__s;
                                   
                                   // Add values in Account Wrapper
                                   accountLocationWrapper oWrapper = new accountLocationWrapper();
                                   oWrapper.icon = 'standard:location'; 
                                   oWrapper.title = acc.Account__r.Name;
                                   oWrapper.description = 'Check-in Date/Time: '+String.valueOf(acc.Checkin_Date_Time__c);
                                   oWrapper.description +='<br/>'+'Check-out Date/Time: '+String.valueOf(acc.Checkout_Date_Time__c);
                                   oWrapper.description +='<br/>'+'Check-in Address: '+acc.Checkin_Address__c;
                                   
                                   oWrapper.location = oLocationWrap;
                                   oWrapperList.add(oWrapper);                                                
                               }
        visitWrap.actLocWrap = oWrapperList;
        system.debug('visitWrap@@' +visitWrap);
        return visitWrap;
        
    }
    
    @auraEnabled
    public static visitWrapper getUserAndDateDetails(String userId,String startDate,String endDate){
        System.debug('User--->'+userId+'-----------Date---->'+startDate);
        System.debug('User--->'+userId+'-----------Date---->'+endDate);
        startDate = startDate.remove('"');
        Date datf = Date.valueOf(startDate);
        endDate = endDate.remove('"');
        Date datt = Date.valueOf(endDate);
        visitWrapper visitWrap = new VisitWrapper();
        List<Beat_Visit__c> beatActList = new List<Beat_Visit__c>();
        if(userId == '0'){
            beatActList = [SELECT Account__c,Account__r.OwnerId,Account__r.Name,Checkout_Date_Time__c,Checkin_Location__longitude__s,
                           Account__r.City__c,Account__r.Country__c,Checkin_Address__c,Checkin_Date_Time__c,Checkin_Location__latitude__s
                           from Beat_Visit__c  
                           WHERE Checkin_Date__c >=:datf and Checkin_Date__c <=:datt and Checkin_Location__latitude__s!=null and Checkin_Location__longitude__s!=null];
        }
        
        else{
            
            beatActList = [SELECT Name,Account__c,Account__r.OwnerId,Account__r.Name,Checkout_Date_Time__c,Checkin_Location__latitude__s,
                           Account__r.City__c,Account__r.Country__c,Checkin_Address__c,Checkin_Date_Time__c,Checkin_Location__longitude__s,
                           Checkin_Date__c
                           from Beat_Visit__c  
                           WHERE Beat_Day__r.Agent__c =:userId 
                           AND Checkin_Date__c >=:datf and Checkin_Date__c <=:datt and Checkin_Location__latitude__s!=null and Checkin_Location__longitude__s!=null];
        }
        
        List<accountLocationWrapper> oWrapperList = new List<accountLocationWrapper>();
        for(Beat_Visit__c act:beatActList){
            locationDetailWrapper oLocationWrap = new locationDetailWrapper();
            if(act.Account__r.City__c!=Null)
                oLocationWrap.City = act.Account__r.City__c;
            if(act.Account__r.Country__c!=Null)
                oLocationWrap.Country = act.Account__r.Country__c;
            if(act.Checkin_Location__latitude__s!=Null)
                oLocationWrap.Latitude = act.Checkin_Location__latitude__s;
            if(act.Checkin_Location__longitude__s!=Null)
                oLocationWrap.Longitude = act.Checkin_Location__longitude__s;
            
            // Add values in Account Wrapper
            accountLocationWrapper oWrapper = new accountLocationWrapper();
            oWrapper.icon = 'standard:location'; 
            oWrapper.title = act.Account__r.Name;
            oWrapper.description = 'Check-in Date/Time: '+String.valueOf(act.Checkin_Date_Time__c);
            oWrapper.description +='<br/>'+'Check-out Date/Time: '+String.valueOf(act.Checkout_Date_Time__c);
            oWrapper.description +='<br/>'+'Check-in Address: '+act.Checkin_Address__c;
            
            oWrapper.location = oLocationWrap;
            oWrapperList.add(oWrapper);
        }
        
        visitWrap.actLocWrap = oWrapperList;
        
        
        return visitWrap;
    }
    
    public class visitWrapper{
        @AuraEnabled public Date todayDate;
        @AuraEnabled public Date yesterdayDate;
        @AuraEnabled public List<User> usrList;
        @AuraEnabled public List<accountLocationWrapper> actLocWrap {get;set;}
        public visitWrapper(){
            usrList = new List<User>();
        }
        
    }
    
    public class accountLocationWrapper{
        @AuraEnabled public string icon{get;set;} 
        @AuraEnabled public string title{get;set;} 
        @AuraEnabled public string description{get;set;} 
        @AuraEnabled public locationDetailWrapper location{get;set;} 
    }
    
    /* sub wrapper class to store location details for "accountLocationWrapper" location property.*/ 
    public class locationDetailWrapper{
        @AuraEnabled public string City{get;set;}
        @AuraEnabled public string Country{get;set;}
        @AuraEnabled public Decimal Latitude{get;set;}
        @AuraEnabled public Decimal Longitude{get;set;}
    }
    
}