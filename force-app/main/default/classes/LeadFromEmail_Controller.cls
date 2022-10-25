global class LeadFromEmail_Controller implements Messaging.InboundEmailHandler {
    
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email,Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        system.debug('body---->'+email.htmlBody);
        
       
        string bdy=string.valueof(email.htmlBody).replaceAll('(\\r|\\n)+', ' ');
        string[] str1;
        string[] str2;
        string[] str=bdy.split('<td width="22%"> <p><strong>');
        
        try{
            if(email.htmlBody != Null && email.htmlBody.length() > 0){
                Map<String,Integer> monthNameToMonthNumberMap = new Map<String,Integer>{'Jan'=>1,'Feb'=>2,'Mar'=>3,'Apr'=>4,'May'=>5,'Jun'=>6,'Jul'=>7,'Aug'=>8,'Sep'=>9,'Oct'=>10,'Nov'=>11,'Dec'=>12};
                String[] fromName = email.fromName !=null ? email.fromName.split(' ') : new List<String>();
                string[] body = new List<String>();
                String tempbody = email.htmlBody.stripHtmlTags().substringAfterLast('Report');
                body = tempbody.split(':');
                string timePart = '';
                String DatePart = '';
                if(body.size() > 0 ){
                    string[] descriptionLst = new List<String>();
                    Lead__c l = new Lead__c();
                   for(integer i=1;i<str.size();i++){
                       
                       str1=str[i].split('</strong> </p> </td>');
                       if(i==1){
                           if(str1.size()>=2)
                            l.Name =  str1[1].split('<td width="28%"> <p><strong>')[1];
                       }
                       if(i==2){
                           if(str1.size()>=2)
                            l.Mobile_Phone__c =  str1[1].split('<td width="28%"> <p><strong>')[1].substring(5);
                       }
                        if(i==3){
                           if(str1.size()>=2)
                            l.Executive_Name__c =  str1[1].split('<td width="28%"> <p><strong>')[1];
                       }
                       if(i==4){
                           if(str1.size()>=2)
                            descriptionLst =str1[1].split('<td width="28%"> <p><strong>')[1].split(' ');
                       }
                       if(i==5){
                           if(str1.size()>=2)
                            timePart =str1[1].split('<td width="28%"> <p><strong>')[1]; 
                       }
                       if(i==6){
                           if(str1.size()>=2)
                             DatePart =str1[1].split('<td width="28%"> <p><strong>')[1];
                       }
                        
                    }
                   
                    timePart = timePart.trim();
                    integer ms=0;
                    if(timePart.split(':').size()>4)
                        ms= Integer.valueOf(timePart.split(':')[3]);
                    l.Intlr_Intimation_Time__c = Time.newInstance(Integer.valueOf(timePart.split(':')[0]), Integer.valueOf(timePart.split(':')[1]), Integer.valueOf(timePart.split(':')[2]), ms);
                    String[] tempLs = DatePart.split('-');
                    Integer monthNumber = 0;
                    if(tempLs != NULL && tempLs.size() >=3){ 
                        if(monthNameToMonthNumberMap.containsKey(tempLs[1]))
                            monthNumber = monthNameToMonthNumberMap.get(tempLs[1]);
                        l.Intlr_Intimation_Date__c = Date.newInstance(Integer.valueOf(tempLs[2].trim()), monthNumber, Integer.valueOf(tempLs[0].trim()));
                    }
                    if(descriptionLst.size() >= 2){
                        string code ='';
                        String query = '';
                        query += 'SELECT Name,Business_Unit_Code__c FROM Business_Unit__c WHERE ';
                        if(descriptionLst[0]=='Max' && descriptionLst[1]=='Skt'){
                            code = 'SKT';
                            query +='Business_Unit_Code__c=:code';
                        }
                        else{
                            code = descriptionLst[0];
                            query += 'Business_Unit_Code__c=:code';
                        }
                        List<Business_Unit__c> bu = Database.query(query);
                        if(bu != NULL && bu.size() > 0)
                            l.Business_Unit__c = bu[0].Name;
                        
                        l.Description__c = '';
                        for(Integer i =0; i<descriptionLst.size(); i++){
                            l.Description__c += descriptionLst[i]+' ';
                        }
                    }
                    l.Description__c =  l.Description__c.remove('Time');
                    l.EmailBody__c=email.htmlBody;
                    l.RecordTypeId = Schema.SObjectType.lead__c.getRecordTypeInfosByName().get('International Tagging').getRecordTypeId();
                    l.First_Name__c = (fromName.size() >0) ? fromName[0] : '';
                    l.Last_Name__c = (fromName.size() >=2) ? fromName[1] : '';
                    l.Lead_Channel__c = 'International';
                    l.Lead_Source__c='Email';
                    l.Email__c = email.fromAddress != null ? email.fromAddress : '';
                    l.Subject__c = email.subject !=null ? email.subject : '';
                    insert l;
                    system.debug('Lead--------inserted successfully----->>>>>>>>>>>>>'+ l.Executive_Name__c);
                    system.debug('Lead--------inserted successfully----->'+l);
                }
            }
        }catch(Exception e){
            system.debug('----error Message----'+e.getMessage()+' at Line '+e.getLineNumber());
        }
        result.success = true;
        return result;
    }
}