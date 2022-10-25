global class MTDRevenueCalculationBatch implements Database.Batchable<AggregateResult> {
    global Iterable<AggregateResult> start(Database.BatchableContext bc){ 
        String query='';
        
                String trans='Transferred';

        
        query= 'SELECT R_Channel__c,SUM(alletec_hisamount__c)amt,alletec_isbillcancelled__c';
        query+=' , Hospital_Location__c ';
        
        query +=' FROM Billing_Summary__c Where '; 
        if(!test.isRunningTest()){
        query+=' Hospital_Location__c!=NULL AND ';
        }
        query+=' alletec_billdate__c = THIS_MONTH AND alletec_billdate__c=Yesterday AND R_Channel__c!=NULL AND Is_Patient_Transfer__c !=\''+String.escapeSingleQuotes(trans)+'\' AND alletec_isbillcancelled__c = false   GROUP BY R_Channel__c,alletec_isbillcancelled__c';
        query+=' , Hospital_Location__c ';
        
       
        return new AggregateResultIterable(query);
    } 
    
    global void execute(Database.BatchableContext bc, List<sObject> scope){
        Map<String,Decimal> mapChannelToRevenue = new Map<String,Decimal>();
        List<MTD_Revenue_Details__c> mtdRevenueDetails = [Select Id,Amount__c,Business_Unit__c,Business_Unit__r.Name,Channel__c,Month__c,Year__c,RecordTypeId From MTD_Revenue_Details__c Where RecordType.Name = 'Achievement' AND Business_Unit__c !=NULL AND Channel__c!=NULL];
        List<MTD_Revenue_Details__c> mtdRevenueDetailsOutlook = [Select Id,Amount__c,Channel__c,Business_Unit__r.Name,Month__c,Year__c,RecordTypeId From MTD_Revenue_Details__c Where RecordType.Name = 'Outlook' AND Business_Unit__c !=NULL AND Channel__c!=NULL ];
        List<MTD_Revenue_Details__c> mtdRevenueDtls = new  List<MTD_Revenue_Details__c>();

        
            Integer numberDays = date.daysInMonth(system.today().year(),system.today().month());
        
            Date todaydate =Date.valueOf(system.today());
            Integer todayMonth = todayDate.month();
            String month=String.valueOf(todayMonth);


        for(sObject sObj : scope){
            
            AggregateResult ar = (AggregateResult)sObj;
            String chn=   ((string)ar.get('R_Channel__c')).toLowerCase();
            string chnnl= chn;
                    
            string BusinessUnit= (string)ar.get('Hospital_Location__c');
            
                    
            String newkey=month+'@'+BusinessUnit+'@'+chnnl;
            
                    
            
            
            if(!mapChannelToRevenue.containsKey(newkey)){
                mapChannelToRevenue.put(newkey,(decimal)ar.get('amt'));
            }
            
        }
        system.debug('====map='+mapChannelToRevenue);
        if(mtdRevenueDetails !=null && mtdRevenueDetails.size()>0){
            for(MTD_Revenue_Details__c mtdRevenue : mtdRevenueDetails){
             String chnnl=  (mtdRevenue.Channel__c).toLowerCase();
             String mtdkey=mtdRevenue.month__c+'@'+mtdRevenue.Business_Unit__r.Name+'@'+chnnl;
                system.debug('==key'+mtdkey);
                if(mapChannelToRevenue.containsKey(mtdkey)){
                    system.debug('==map111'+mapChannelToRevenue);
                    mtdRevenue.Amount__c = (mapChannelToRevenue.get(mtdkey))/100000;
                    mtdRevenueDtls.add(mtdRevenue);
                }
            }
        }
        
        if(mtdRevenueDetailsOutlook !=null && mtdRevenueDetailsOutlook.size()>0){
            for(MTD_Revenue_Details__c mtdOutlook:mtdRevenueDetailsOutlook){
               String chnnl=  (mtdOutlook.Channel__c).toLowerCase();
               String mtdOutkey=mtdOutlook.month__c+'@'+mtdOutlook.Business_Unit__r.Name+'@'+chnnl;
                if(mapChannelToRevenue.containsKey(mtdOutkey)){
                   mtdOutlook.Amount__c = (((mapChannelToRevenue.get(mtdOutkey))/100000)/(system.today().addDays(-1).day()))*numberDays;
                     mtdRevenueDtls.add(mtdOutlook);
                }
            }
        }
       Update mtdRevenueDtls;
        system.debug('---->'+mtdRevenueDtls);
    }
    
    global void finish(Database.BatchableContext bc){
        
    }
    
}