trigger EmailMAXServicesTrigger on Service_Lead__c (after insert, after update) {
    if(trigger.isafter){
        if(trigger.isinsert || trigger.isupdate)
     {
            EmailMAXServicesHelper.EmailService(trigger.new);
        }
    }

}