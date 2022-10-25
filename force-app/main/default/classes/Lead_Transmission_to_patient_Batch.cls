// Description : Batch class to create the lead directly into the Account 
//               If the Account Name And Phone Is same as Contact LastName and Phone
// Created By : Prashant Gahlaut            


global class Lead_Transmission_to_patient_Batch implements  DataBase.Batchable<Sobject>{
    
    //Start Method
    global DataBase.QueryLocator start(Database.BatchableContext bs){
        String query='';
        query = 'select lastName, Phone,(select name,id from leads__r where RecordType.Name = \'Call Center\') from contact where Phone != null And RecordType.Name = \'Patient\'';
        return DataBase.getQueryLocator(query);
    }
    
    //Execution Method
    global void execute(DataBase.BatchableContext bc , list<Contact> conlist){
        
        
        //Set the Phone And Lastname of Contact in Sets
        //And put lead records into the map
        map <string ,list<lead__c>>leadmap= new map<string,list<lead__c>>();
        set<string> phoneset = new set<string>();
        set<string> nameset = new set<string>();
        for(Contact c  : conlist){
            phoneset.add(c.Phone); 
            nameset.add(c.lastName);
            if(c.leads__r.size()>0)
                leadmap.put(c.Phone +'@@'+ c.lastName,c.leads__r);
        }
        
        
        // Put the Account Record in Map 
        map<string ,account> accmap = new map<string,account>();
        if((phoneset != null && phoneset.size()>0) && (nameset != null && nameset.size()>0)){
            for(Account acc : [select name,PersonMobilePhone,Phone from account 
                               where RecordType.name = 'Patient' and (PersonMobilePhone in : phoneset or Phone in:phoneset)
                               and name in : nameset]){
                                   if(acc.PersonMobilePhone != null )
                                       accmap.put(acc.PersonMobilePhone +'@@'+ acc.Name,acc);
                                   else
                                       accmap.put(acc.Phone +'@@'+ acc.Name,acc); 
                                   
                               }
        }
        
        
        //Create the leads Under the Account Record
        //And remove from Contact Record
        list<lead__c> leadlist = new list<lead__c>();
        if((accmap !=null && accmap.size()>0) && (leadmap != null && leadmap.size()>0)){
            for(string keys : leadmap.keyset()){
                if(accmap.containskey(keys)){
                    for(lead__c l: leadmap.get(keys)){
                        Lead__c ld = new Lead__c();
                        ld.id =  l.id;
                        ld.Patient__c = accmap.get(keys).Id;
                        ld.Parent_Contact_for_lead__c=null;
                        leadlist.add(ld);
                    }
                }
            }
            
        }
        
        //updating the list 
        if(leadlist.size()>0){
            Database.SaveResult[] srList = Database.update(leadlist,false);
        }
        
    }
    
    //Finish Method
    global void finish(DataBase.BatchableContext bc){
        
    }
    
}