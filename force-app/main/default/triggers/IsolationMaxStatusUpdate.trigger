trigger IsolationMaxStatusUpdate on E_Prescription__c (after insert,Before insert) {
    SET<String> MaxIsolationList = new Set<String>();
    for(E_Prescription__c  epres : Trigger.new){
        if(epres.Isolation_Max_Home__c != null)
            MaxIsolationList.add(epres.Isolation_Max_Home__c);
    }
    if(Trigger.IsBefore && MaxIsolationList.size()>0){
        List<Max_at_Home_Enquiry_Page__c> Lstmax =[SELECT Id,Age__c, Diagnosis__c,Severity__c,Patient_Name__c ,Gender__c ,stage__c FROM Max_at_Home_Enquiry_Page__c WHERE ID IN:MaxIsolationList];
        for(E_Prescription__c  Eps : Trigger.New) {
            Eps.Patient_Name__c=Lstmax[0].Patient_Name__c;
            Eps.Gender__c=Lstmax[0].Gender__c;
            Eps.Severity__c=Lstmax[0].Severity__c;
            Eps.Age__c=string.valueOf(Lstmax[0].Age__c);
            Eps.Diagnosis__c=Lstmax[0].Diagnosis__c;
        }  
    }
    if(MaxIsolationList.size()>0){
        List<Max_at_Home_Enquiry_Page__c> tempMaxList = new List<Max_at_Home_Enquiry_Page__c>();
        for(Max_at_Home_Enquiry_Page__c max :[SELECT stage__c FROM Max_at_Home_Enquiry_Page__c WHERE ID IN:MaxIsolationList]){
            max.Stage__c='Prescription Generated';
            tempMaxList.add(max);
        }
        if(tempMaxList.size()>0)
            update tempMaxList;
    }
    
}