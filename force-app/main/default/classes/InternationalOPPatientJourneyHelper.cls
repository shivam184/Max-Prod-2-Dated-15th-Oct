/* Author: Nitya (IRT)
 * Last Modifiedby:Nitya
 */
public class InternationalOPPatientJourneyHelper {
    //added by Nitya on 28th Feb 2022
    // To Update IOP Field in Billing summary 
     
    public static void updateBillingSummaryOnIopCreation(List<International_OP_Patient_Journey__c> triggerNew){
        Map<String,International_OP_Patient_Journey__c> iopjMap=new Map<String, International_OP_Patient_Journey__c>();
        for(International_OP_Patient_Journey__c iop: TriggerNew){
            if(iop.Patient_Max_id__c!=null)
            iopjMap.put(iop.Patient_Max_id__c.ToUpperCase(),iop);
        }
        List<billing_summary__c> bsList=new List<billing_summary__c>();
      
        for(billing_summary__c bs:[select id, name__c,IOP_Journey__c from Billing_Summary__c where name__c  In :iopjMap.keySet() and IOP_Journey__c=null and createdDate=TODAY ]){
            if(iopjMap.containsKey(bs.name__c.ToUpperCase())){
                bs.IOP_Journey__c=iopjMap.get(bs.name__c.ToUpperCase()).id;
                bsList.add(bs);
            }
        }
        update bsList;
    }
    //added by Nitya on 11th feb 2022 to replace process builder.
    //change iopJ stage to 'OPD mapping when fist op Bill date is not null
    
    public static void changeStage(List<International_OP_Patient_Journey__c> triggerNew,Map<id,International_OP_Patient_Journey__c> oldmap ){
        for(International_OP_Patient_Journey__c iop:triggerNew){
            if((iop.Stage__c=='New'|| iop.Stage__c==null)&& (iop.First_OP_Bill_Date__c!=null)){
                system.debug('In OPD');
                iop.Stage__c='OPD Mapping';
            }
            else if(iop.stage__c=='Admitted' && iop.Journey_Day__c>90)
            {
               // system.debug('in Admitted');
                iop.stage__c='Closed Won';
            }
            else if(iop.Journey_Day__c>90 && iop.Stage__c!='Closed Won'){
                iop.Stage__c='Closed Lost';
            }
        }
    }
   
}