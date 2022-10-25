public class CampaignCodeManagementTriggerHelper {
    
    public static void CampaignCodeGenerate(List<Campaign_Code_Management__c> triggerNewList){
        
        Map<Id,List<Campaign_Code_Management__c>> mapBUnitToCmpnCodMng = new Map<Id,List<Campaign_Code_Management__c>>();
        Map<String,String> mapKeyToCountValue = new Map<String,String>();
        List<CampaignCodeGenerato__c> ListcstmSetting = new List<CampaignCodeGenerato__c>();
        
        for(Campaign_Code_Management__c cmpgnInstnce : triggerNewList){
            if(cmpgnInstnce.Business_Unit__c != Null && cmpgnInstnce.Campaign_Channel__c != Null){
                List<Campaign_Code_Management__c> tempList = new List<Campaign_Code_Management__c>();
                if(mapBUnitToCmpnCodMng.containsKey(cmpgnInstnce.Business_Unit__c) && mapBUnitToCmpnCodMng.get(cmpgnInstnce.Business_Unit__c) != Null)
                    tempList = mapBUnitToCmpnCodMng.get(cmpgnInstnce.Business_Unit__c);
                tempList.add(cmpgnInstnce);
                mapBUnitToCmpnCodMng.put(cmpgnInstnce.Business_Unit__c,tempList);
            }
        }
        
        Map<Id,Business_Unit__c> mapIdToBusinessUnit = new Map<Id,Business_Unit__c>([SELECT Id, Business_Unit_Code__c FROM Business_Unit__c
                                                                                     WHERE Id IN : mapBUnitToCmpnCodMng.keySet()]);
        
        
        
        if( mapBUnitToCmpnCodMng.keySet().size() > 0){
            Integer count =0;
            for(Id keyString : mapBUnitToCmpnCodMng.keySet()){
                
                if(mapBUnitToCmpnCodMng.get(keyString) != Null){
                    
                    for(Campaign_Code_Management__c cmpgnCode : mapBUnitToCmpnCodMng.get(keyString)){
                        
                        if(mapIdToBusinessUnit.get(keyString) != Null ){
                            String namsetting='';
                            String codesetting='';
                            
                            CampaignCodeGenerato__c setting = CampaignCodeGenerato__c.getInstance(String.valueOf(mapIdToBusinessUnit.get(keyString).Business_Unit_Code__c+cmpgnCode.Campaign_Channel__c.Left(1)));
                            if(setting != Null ){
                                if(setting.Name != Null && setting.Name == String.valueOf(mapIdToBusinessUnit.get(keyString).Business_Unit_Code__c+cmpgnCode.Campaign_Channel__c.Left(1))){
                                    integer sequence1=Integer.valueof((setting.CampaignCode__c));
                                    sequence1 = sequence1+1;
                                    
                                    String temp = '' ;
                                    
                                    if(sequence1 >= 100 && sequence1 < 999)
                                        temp ='0' ;
                                    else if(sequence1 >= 10 && sequence1 < 99)
                                        temp +='00' ;
                                    else if(sequence1 >= 1 && sequence1 < 9)
                                        temp +='000' ;		
                                    else if(sequence1 == 0 )
                                        temp +='0000' ;
                                    
                                    String sequence2 = String.valueof(sequence1 );	
                                    sequence2 = temp + sequence1 ;
                                    cmpgnCode.Campaign_Code__c = String.valueOf(mapIdToBusinessUnit.get(keyString).Business_Unit_Code__c)
                                        +String.valueOf(cmpgnCode.Campaign_Channel__c).Left(1)+sequence2;
                                    
                                    setting.CampaignCode__c = sequence2;
                                    
                                }
                                ListcstmSetting.add(setting);
                            }
                            else{
                                setting = new CampaignCodeGenerato__c();
                                setting.Name =  mapIdToBusinessUnit.get(keyString).Business_Unit_Code__c+cmpgnCode.Campaign_Channel__c.Left(1);
                                setting.CampaignCode__c = '0001';
                                cmpgnCode.Campaign_Code__c =  setting.Name + setting.CampaignCode__c;
                                
                                ListcstmSetting.add(setting);
                            }
                        }
                    }
                    
                }
            }
            
            
        }
        if(ListcstmSetting.size() > 0)
            upsert ListcstmSetting;
    }
}