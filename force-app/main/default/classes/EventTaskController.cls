public class EventTaskController {
    
    @AuraEnabled
    public static WrapEventTask onComLoad(){
        
        WrapEventTask wrapET = new WrapEventTask();
        List<Event> eventList = [Select Id,What.Name,Subject FROM Event WHERE OwnerId =:userinfo.getUserId() AND ActivityDate =: System.today()];         
        List<Task>  taskList = [Select Id,What.Name,Subject FROM Task WHERE OwnerId =:userinfo.getUserId() AND ActivityDate =: System.today() AND Status='Open'];
        wrapET.EWrapList =eventList;
        wrapET.TWrapList =taskList; 
        wrapEt.todayDate = System.today();
        return wrapET;
    }    
    
    @AuraEnabled
    public static WrapEventTask save(Date edate){
        
        WrapEventTask wrapET = new WrapEventTask();
        List<Event> eventList = [Select Id,What.Name,Subject FROM Event WHERE OwnerId =:userinfo.getUserId() AND ActivityDate =: edate];        
        List<Task>  taskList = [Select Id,What.Name,Subject FROM Task WHERE OwnerId =:userinfo.getUserId() AND ActivityDate =: edate AND Status='Open'];
        wrapET.EWrapList =eventList;
        wrapET.TWrapList =taskList;
        
        return wrapET;
    }
    
    public class WrapEventTask{
        @AuraEnabled
        public Date todayDate;
        @AuraEnabled
        public List<Event> EWrapList;
        @AuraEnabled
        public List<Task> TWrapList;
        
        public WrapEventTask(){
            EWrapList = new List<Event>();
            TWrapList = new List<Task>();
        }
        
    }
}