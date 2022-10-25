/*created by: IRT
 * Author: Nitya
 * Date: 14th Feb 2022
 * lastModifiedDate:25th March 2022 by Nitya
 */
public class BillingItemwiseTriggerHandler {
// Purpose: To update the IOP field on updation of Billing Itemwise record
    public static void updateIOP(List<billing_itemwise__c> triggerNew){
        Set<Id> bItemSet=new Set<Id>();
        for(billing_Itemwise__c bItem:triggerNew){
            bItemSet.add(bItem.id);
        }
        List<International_OP_Patient_Journey__c> IPOJList=new List<International_OP_Patient_Journey__c>();
        List<billing_Itemwise__c> bItemList=[select id, invoiceid__c,invoiceid__r.IOP_Journey__c, alletec_service__c from billing_Itemwise__c where id in: bItemSet];
       // system.debug(bItemList);
        //system.debug(bItemList[0].invoiceid__r.IOP_Journey__c);
        if(bItemList==null){return;}
        for(billing_Itemwise__c b:bItemList){
            if(b.invoiceid__r.IOP_Journey__c==null || b.invoiceid__c==null){continue;}
            //system.debug('Inside For Loop');
            if(b.alletec_service__c=='Consultations'){
                IPOJList.add(new International_OP_Patient_Journey__c(id=b.invoiceid__r.IOP_Journey__c, 	Consult__c=true));
            }
            else if(b.alletec_service__c=='Investigations'){
                IPOJList.add(new International_OP_Patient_Journey__c(id=b.invoiceid__r.IOP_Journey__c, 	Radiology__c=true));
            }
            else if(b.alletec_service__c=='Laboratory Services'){
                IPOJList.add(new International_OP_Patient_Journey__c(id=b.invoiceid__r.IOP_Journey__c, 	Pathology__c=true));
            }
            else if(b.alletec_service__c=='OP Consultations'){
                IPOJList.add(new International_OP_Patient_Journey__c(id=b.invoiceid__r.IOP_Journey__c, 	Pharmacy__c=true));
            }
        }
        //system.debug(IPOJList);
        //added on 25th march 2022 by NITYA
        map<id,International_OP_Patient_Journey__c> mapIPOJ=new map<id,International_OP_Patient_Journey__c>();
        for(International_OP_Patient_Journey__c ipo:IPOJList){
            if(!mapIPOJ.Isempty() && mapIPOJ.containsKey(ipo.id)){
                if(mapIPOJ.get(ipo.id).consult__c==false && ipo.consult__c==true)
                    mapIPOJ.get(ipo.id).consult__c=true;
                else if(mapIPOJ.get(ipo.id).Radiology__c==false && ipo.Radiology__c==true)
                    mapIPOJ.get(ipo.id).Radiology__c=true;
                else if(mapIPOJ.get(ipo.id).Pathology__c==false && ipo.Pathology__c==true)
                    mapIPOJ.get(ipo.id).Pathology__c=true;
                else if(mapIPOJ.get(ipo.id).Pharmacy__c==false && ipo.Pharmacy__c==true)
                    mapIPOJ.get(ipo.id).Pharmacy__c=true;
            }
            else
            mapIPOJ.put(ipo.id,ipo);
            
        }
        update mapIPOJ.values();
    }
    
}