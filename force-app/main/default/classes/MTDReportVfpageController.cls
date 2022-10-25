public class MTDReportVfpageController {
    public Static  date startdate{get;set;}
    public Static  date enddate{get;set;}
    public PickListWrapper picklistWrp {
        get;
        set;
    }
    
    public DataWrapper dataWrp{
        get;
        set;
    }
    public Static  string selectedMonth{get;set;}
    public Static  string selectedYear{get;set;}
    list<string> MonthList{get;set;}
    List <string> yearList{get;set;}
    
    public MTDReportVfpageController(){
        
         selectedMonth = string.valueof(apexpages.currentpage().getparameters().get('selectedMonth'));
         selectedYear=string.valueof(apexpages.currentpage().getparameters().get('selectedYear'));
         system.debug('selectedMonth'+selectedMonth+'selectedYear'+selectedYear)        ;
      //  startdate = date.valueof(apexpages.currentpage().getparameters().get('startdt'));
      //  enddate=date.valueof(apexpages.currentpage().getparameters().get('enddate'));

        picklistWrp = new PickListWrapper();
        dataWrp = new DataWrapper();
        
        init();

    }
    
    private void init(){
        picklistWrp = this.getPicklistValues();
        dataWrp = this.fetchRevenueDetails();
    }
     /* Method to hold all the picklist values. */

    public PickListWrapper getPicklistValues(){
        PickListWrapper wrp = new PickListWrapper();
        wrp.zoneList = getPickVal('Business_Unit__c','Zone__c');
        wrp.channelList = getPickVal('MTD_Revenue_Details__c','Channel__c');
        wrp.recordTypeList = getRecordTypeList('MTD_Revenue_Details__c');
        return wrp;
        
    }
    
    /* Method to fetch the picklist fields values. */ 
    private static List<String> getPickVal(String obj,String field){
        List <String> pickVals = new List <String>();
        List <String> pickValsdummy = new List <String>();
        Schema.sObjectType objType = Schema.getGlobalDescribe().get(obj);
        
        List<Schema.PicklistEntry> values = objType.getDescribe().fields.getMap().get(field).getDescribe().getPickListValues();
        for (Schema.PicklistEntry a: values) {
            pickValsdummy.add(a.getValue());
        }
        pickValsdummy.sort();
        for(Integer i = pickValsdummy.size()-1; i>=0;i--)
{
    pickVals.add(pickValsdummy.get(i));
}
       
        return pickVals;
    }
    /* Method to fetch the record type values. */
    private static List<String> getRecordTypeList(String objName){
        List<String> recordTypeList = new List<String>();
        for(RecordType rt : [SELECT Id,Name FROM RecordType WHERE SobjectType = :objName]){
            recordTypeList.add(rt.Name);
        }
        return recordTypeList;
    }
    /* Method to fill the data wrapper. */
   
    public DataWrapper fetchRevenueDetails(){
        Map<String,List<String>> zoneToUnitsMap = new Map<String,List<String>>();
        DataWrapper wrp = new DataWrapper();
          
                 List<AggregateResult>  groupedResults = [Select Name,Zone__c, Business_Unit_Code__c  From Business_Unit__c Where Id IN (select Business_Unit__c from MTD_Revenue_Details__c) AND Zone__c != NULL AND Active__c=True  
                     group by Business_Unit_Code__c,Zone__c,Name order by Zone__c desc,Business_Unit_Code__c desc];
        for (AggregateResult bu : groupedResults)  {
            
             List<String> tempList = new List<String>();
            if(zoneToUnitsMap.containsKey((string)bu.get('Zone__c'))){
                tempList = zoneToUnitsMap.get((string)bu.get('Zone__c'));
            }
            tempList.add((string)bu.get('Business_Unit_Code__c'));
            zoneToUnitsMap.put((string)bu.get('Zone__c'),tempList);

        }
      
        /*
        
        for(Business_Unit__c bu : [Select Name,Zone__c, Business_Unit_Code__c  From Business_Unit__c Where Zone__c != NULL  AND HIS_ID__c!='7'  order by Business_Unit_Code__c desc]){
            List<String> tempList = new List<String>();
            if(zoneToUnitsMap.containsKey(bu.Zone__c)){
                tempList = zoneToUnitsMap.get(bu.Zone__c);
            }
            tempList.add(bu.Business_Unit_Code__c);
            zoneToUnitsMap.put(bu.Zone__c,tempList);
        } 
         */
        
        wrp.zoneToUnitsMap = zoneToUnitsMap;
        
        /* Map to hold the value of every cell in table */
        Map<String,Decimal> dataMap = new Map<String,Decimal>();
        for(AggregateResult agg : getQueryResult(',Business_Unit__r.Zone__c zone,Business_Unit__r.Business_Unit_Code__c buName,Channel__c ch,RecordType.Name rt','Channel__c,Business_Unit__r.Business_Unit_Code__c,Business_Unit__r.Zone__c,RecordType.Name')){
            wrp.finalDataMap.put((String)agg.get('zone')+'@@'+(String)agg.get('ch')+'@@'+(String)agg.get('buName')+'@@'+(String)agg.get('rt'),((Decimal)agg.get('amt')).setScale(2));
        }
        
        /* Map to hold the vertical Sum of each record type value in table */
        Map<String,Decimal> dataSumMap = new Map<String,Decimal>();
        for(AggregateResult agg : getQueryResult(',Business_Unit__r.Zone__c zone,Business_Unit__r.Business_Unit_Code__c buName,RecordType.Name rt','Business_Unit__r.Business_Unit_Code__c,Business_Unit__r.Zone__c,RecordType.Name')){
            wrp.finalDataMap.put((String)agg.get('zone')+'@@'+(String)agg.get('buName')+'@@'+(String)agg.get('rt'),((Decimal)agg.get('amt')).setScale(2));
        }
        
        /* Map to hold the sum of all Business Unit of a Zone in table */
        Map<String,Decimal> zoneSumMap = new Map<String,Decimal>();
        for(AggregateResult agg : getQueryResult(',Business_Unit__r.Zone__c zone,Channel__c ch,RecordType.Name rt','Channel__c,Business_Unit__r.Zone__c,RecordType.Name')){
            wrp.finalDataMap.put((String)agg.get('zone')+'@@'+(String)agg.get('ch')+'@@'+(String)agg.get('rt'),((Decimal)agg.get('amt')).setScale(2));
        }
        
        /* Map to hold the sum of every zone in table */
        Map<String,Decimal> grandTotalMap = new Map<String,Decimal>();
        for(AggregateResult agg : getQueryResult(',Business_Unit__r.Zone__c zone,RecordType.Name rt','Business_Unit__r.Zone__c,RecordType.Name')){
            wrp.finalDataMap.put((String)agg.get('zone')+'@@'+(String)agg.get('rt'),((Decimal)agg.get('amt')).setScale(2));
        }
        
        /* Map to hold the sum of all the zone in table */
        Map<String,Decimal> channelTotalMap = new Map<String,Decimal>();
        for(AggregateResult agg : getQueryResult(',Channel__c ch,RecordType.Name rt','RecordType.Name,Channel__c')){
            wrp.finalDataMap.put((String)agg.get('ch')+'@@'+(String)agg.get('rt'),((Decimal)agg.get('amt')).setScale(2));
        }
        
        /* Map to hold the grand total of  all zones with recordType in table */
        Map<String,Decimal> grandChannelTotalMap = new Map<String,Decimal>();
        for(AggregateResult agg : getQueryResult(',RecordType.Name rt','RecordType.Name')){
            wrp.finalDataMap.put((String)agg.get('rt'),((Decimal)agg.get('amt')).setScale(2));
        }
        
        wrp.finalMapKeys = String.join((Iterable<String>)wrp.finalDataMap.keySet(), ',');
        //wrp.grandChannelTotalMap = grandChannelTotalMap;
        return wrp;
    }
    /* Method to fetch the AggregateResult. */
    private static List<AggregateResult> getQueryResult(String fieldWithAlias,String groupingFields){
        string strMonth='4';//string.valueof(Date.today().month());
        string strYear=string.valueof(Date.today().year());
        string strMonthh=string.valueof(Date.today().month());
        string startdatemonth;
        string enddateyear;
        if(!string.isBlank(selectedMonth) && !string.isBlank(selectedYear)){
            startdatemonth=string.valueof(selectedMonth);
            enddateyear=string.valueof(selectedYear);
        }
        else{
             startdatemonth=string.valueof(strMonthh);
             enddateyear=string.valueof(strYear);
        }
        
        system.debug('startdatemonth'+startdatemonth+'enddateyear'+enddateyear);
        //string startdateyear=string.valueof(startdate.year()); 
        //string enddateyear=string.valueof(enddate.year()); 
        system.debug(groupingFields);

       // String query = 'Select SUM(Amount__c) amt'+fieldWithAlias+' FROM MTD_Revenue_Details__c WHERE Month__c=\''+String.escapeSingleQuotes(strMonth)+'\' AND Year__c=\''+String.escapeSingleQuotes(strYear)+'\'  AND Zone__c != NULL GROUP BY '+groupingFields+' HAVING SUM(Amount__c) != NULL  order by Channel__c,Business_Unit__c ';
       // String query = 'Select SUM(Amount__c) amt'+fieldWithAlias+' FROM MTD_Revenue_Details__c WHERE (Month__c>=\''+String.escapeSingleQuotes(startdatemonth)+'\'  AND  Month__c<=\''+String.escapeSingleQuotes(enddatemonth)+'\') AND (Year__c>=\''+String.escapeSingleQuotes(startdateyear)+'\'  AND Year__c<=\''+String.escapeSingleQuotes(enddateyear)+'\')  AND Zone__c != NULL GROUP BY '+groupingFields+' HAVING SUM(Amount__c) != NULL  ';
       String query = 'Select SUM(Amount__c) amt'+fieldWithAlias+' FROM MTD_Revenue_Details__c WHERE Month__c=\''+String.escapeSingleQuotes(startdatemonth)+'\'  AND Year__c=\''+String.escapeSingleQuotes(enddateyear)+'\'  AND Zone__c != NULL GROUP BY '+groupingFields+' HAVING SUM(Amount__c) != NULL ';

        return Database.query(query);
    }
    
    
    /* Wrapper Class for Report Data. */
    public class DataWrapper{
        public String finalMapKeys {get;set;}
        public Map<String,Decimal> finalDataMap{get;set;}
        public Map<String,List<String>> zoneToUnitsMap{get;set;}
       
        
        public DataWrapper(){
            finalMapKeys = '';
            finalDataMap = new Map<String,Decimal>();
            zoneToUnitsMap = new Map<String,List<String>>();
            
        }
    }
    
    /* Wrapper class for the all picklist. */
    public class PickListWrapper{
        public List<String> MonthList{get;set;}
        public List<String> yearList{get;set;} 
        public List<String> zoneList{get;set;}
        
        public List<String> channelList{get;set;}
        
        public List<String> recordTypeList{get;set;}
        
    }
    
        public class PickListWrapp{
            @AuraEnabled
        public List<String> MonthList;
            @AuraEnabled
            public List<String> yearList;
            public PickListWrapp(){
                MonthList =new list<string>();
                 yearList =new list<string>();
            }
        }
    @AuraEnabled
    public static PickListWrapp MonthYearPicklist(){
        
        PickListWrapp pw=new PickListWrapp();

        Schema.DescribeFieldResult fieldResult = MTD_Revenue_Details__c.month__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry f : ple)
        pw.MonthList.add(f.getValue());
        
        Schema.DescribeFieldResult fieldResult1 = MTD_Revenue_Details__c.year__c.getDescribe();
        List<Schema.PicklistEntry> ple1 = fieldResult1.getPicklistValues();
        for(Schema.PicklistEntry f : ple1)
        pw.yearList.add(f.getValue());  
system.debug(pw);
        return pw;
    } 
}