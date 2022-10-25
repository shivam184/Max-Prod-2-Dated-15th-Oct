public class RecmmondedTestTriggerHelper {
    
    public void RollUpTestMrpToLead(list<Recommended_Test__c> triggerNew){
        
        Map<String,Decimal> LeadToRCTestMap = new Map<String,Decimal>();
        List<Lead__c> listLeadToUpdate=new List<Lead__c>();
        
        for(Recommended_Test__c mem : triggerNew){
            if(mem.Leads__c != null)
                LeadToRCTestMap.put(mem.Leads__c, null);
        }
        
       /* for(Recommended_Test__c mem :triggerold){
            if(mem.Leads__c != null)
                LeadToRCTestMap.put(mem.Leads__c, null);
        } */
        
        
        
        for(AggregateResult event : [SELECT SUM(Test_MRP__c) tstMrp, Leads__c lead FROM Recommended_Test__c
                                     WHERE 	Leads__c IN: LeadToRCTestMap.keySet()
                                     GROUP BY Leads__c]){
                                         
                                         LeadToRCTestMap.put((string)event.get('lead'), (Decimal)event.get('tstMrp'));
                                     }
        for(Lead__c lead : [SELECT Id,TestMRP__c
                            FROM Lead__c
                            WHERE Id IN :LeadToRCTestMap.keySet()]){
                                lead.TestMRP__c = LeadToRCTestMap.get(lead.Id) != null ?LeadToRCTestMap.get(lead.Id):0;
                                listLeadToUpdate.add(lead);
                            }
        
        if(listLeadToUpdate.size() > 0)
            update listLeadToUpdate;
        
    }
}