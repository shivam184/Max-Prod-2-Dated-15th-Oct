@RestResource(urlMapping='/OptoOpLeads/*')

global class CreateLeadAndLineItem {
    @HttpPOST
    global static string doCreate() {
        RestRequest req = RestContext.request;
        if(String.isNotBlank(req.requestBody.toString())){
            try{
                Wrapper jsonBody = (Wrapper)JSON.deserialize(req.requestBody.toString(),Wrapper.class);
                LIST<Recommended_Test__c> listRecTest=new List<Recommended_Test__c>();
                set<string> MaxidSet=new set<string>();
                map<string,LeadWrapper> ls2insertmap =new map<string,LeadWrapper>();
                map<string,List<wrapNew>> service2insertmap =new map<string,List<wrapNew>>();
                
                map<string,Services__c> idset = new map<string,Services__c>();
                set<string> DoctoridSet=new set<string>();
                Map<string,Account> maxIDMap=new map<string,Account>();
                List<string> setmaxId=new list<string>();
                set<string> businessUnitSet=new set<string>();
                Map<string,Lead__c> MaxVisitIdMap=new map<string,Lead__c>();
                Map<string,string> unitIDBusinessUnitMap=new map<string,string>();
                string msg='';
                if(jsonBody.LEADINFO != Null){
                    
                    
                    //if(accList.size()>0){
                    for(cls_LEADINFO leadinfo : jsonBody.LEADINFO){
                        setmaxId.add(leadinfo.MAXID);
                        businessUnitSet.add(leadinfo.UNITID);
                    }
                    list<Business_Unit__c> businessUnitList=[select id,name,HIS_ID__c  from Business_Unit__c where HIS_ID__c IN:businessUnitSet AND active__c=true];
                    if(businessUnitList.size()>0)
                    for(Business_Unit__c bu:businessUnitList){
                        unitIDBusinessUnitMap.put(bu.HIS_ID__c,bu.name);
                    }
                    /*
                    list<lead__c> existingLeadList=[select id,Visit_Id__c,Max_ID__c from lead__c where Max_ID__c IN:setmaxId ];
                    for(Lead__c ld : existingLeadList){
                        MaxVisitIdMap.put(ld.Max_ID__c+'@@'+ld.Visit_Id__c,ld);
                    }*/
                    id RecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('OP-OP').getRecordTypeId(); 
                    for(cls_LEADINFO leadinfo : jsonBody.LEADINFO){
                        
                        DoctoridSet.add(leadinfo.DOCTORID);
                        LeadWrapper wty = new LeadWrapper();
                        lead__c lead=new lead__c();
                        lead.RecordTypeId=RecordTypeId;
                        lead.Max_ID__c=leadinfo.MAXID;
                        lead.name= leadinfo.Name;  
                        lead.Bill_Number__c=leadinfo.OPBILL; 
                        //  lead.APISave__c=True;
                        lead.DoctorId__c=leadinfo.DOCTORID; 
                        lead.Bill_Date__c=leadinfo.OPDDATE != null ? leadinfo.OPDDATE : null; 
                        lead.Visit_Date__c=leadinfo.VISITDATE != null ? leadinfo.VISITDATE : null ;
                        lead.Lead_Channel__c= leadinfo.CHANNEL;
                        if(leadinfo.CHANNEL =='EWS' || leadinfo.CHANNEL=='PSU'){
                            lead.Stage__c='Closed Lost';   
                        }
                        else
                            lead.Stage__c='NEW'; 
                        lead.Business_Unit_HIS__c= leadinfo.UNITID ; 
                        if(unitIDBusinessUnitMap.containsKey(leadinfo.UNITID)){
                            lead.Business_Unit__c=unitIDBusinessUnitMap.get(leadinfo.UNITID);
                        }
                        lead.Patient_Type__c=leadinfo.PATIENTTYPE != null ? leadinfo.PATIENTTYPE : 'OP';
                        lead.Visit_Id__c = leadinfo.VISITID;
                        wty.ld = lead;
                        wty.docid = leadinfo.DOCTORID;
                        wty.maxid = leadinfo.MAXID;
                        ls2insertmap.put(leadinfo.VISITID,wty);
                        //maxIDMap.put(leadinfo.VISITID,leadinfo.DOCTORID);
                        
                        if(!service2insertmap.containsKey(leadinfo.VISITID))
                            service2insertmap.put(leadinfo.VISITID, new list<wrapNew>());
                        
                        for(cls_RECOMENDEDTEST line : leadinfo.RECOMENDEDTEST){
                            integer i=0;
                            wrapNew wrp = new wrapNew();
                            Recommended_Test__c rec=new Recommended_Test__c();
                            //rec.Leads__c = ListLead[0].id;
                            system.debug(line.SERVICEID);
                            /*if(idServiceIdMap.get(line.SERVICEID) != Null){
system.debug('indidr if');
rec.Service_Id__c=line.SERVICEID;
rec.Services__c=idServiceIdMap.get(line.SERVICEID);
}*/
                            rec.Test_Id__c=line.TESTID != null ? line.TESTID : '';
                            rec.Test_Name__c=line.TESTNAME != null ? line.TESTNAME : '';
                            rec.Test_MRP__c=Decimal.valueof(line.TESTMRP);
                            i=i+1;
                            idset.put(line.serviceid,null);
                            wrp.rcmtest = rec;
                            wrp.serviceId = line.SERVICEID;
                            listRecTest.add(rec);
                            service2insertmap.get(leadinfo.VISITID).add(wrp);
                        }
                        
                    }
                    
                    system.debug(setmaxId);
                    
                    for(Account acc : [select id,Max_ID__c,Name,PersonMobilePhone,phone from Account where  Max_ID__c IN: setmaxId AND Recordtype.name='Patient']){
                        maxIDMap.put(acc.Max_ID__c,acc); 
                       /* if(ls2insertmap.containskey(acc.Max_ID__c)){
                            lead__c lead  = ls2insertmap.get(acc.Max_ID__c);
                            lead.Patient__c = acc.id; 
                            lead.Mobile_Phone__c= acc.PersonMobilePhone;
                            ls2insertmap.put(acc.Max_ID__c,lead);
                        }*/
                    }
                    Map<string,id> doctoridaccountMap=new map<string,id>();
                    Map<string,string> doctoridSpecialtyMap=new map<string,string>();

                    for(Account acc : [select id,alletec_doctorid__c,Name,Doctor_Specialty__c from Account where  alletec_doctorid__c IN:DoctoridSet AND Recordtype.name='Doctor'])
                    { doctoridaccountMap.put(acc.alletec_doctorid__c,acc.id);
                     doctoridSpecialtyMap.put(acc.alletec_doctorid__c,acc.Doctor_Specialty__c);
                    }
                    system.debug(doctoridSpecialtyMap);
                    map<string,lead__c> lead2insert = new map<string,lead__c>();
                    for(string str:ls2insertmap.keyset()){
                        
                        Lead__c ler  = ls2insertmap.get(str).ld;
                        if(doctoridaccountMap.containskey(ls2insertmap.get(str).docid)){
                           ler.Doctor__c = doctoridaccountMap.get(ls2insertmap.get(str).docid);
                           ler.Speciality_Text__c=doctoridSpecialtyMap.get(ls2insertmap.get(str).docid);
                        }
                        
                        
                        system.debug(maxIDMap);
                        system.debug(ls2insertmap);
                        system.debug(str);

                        if(maxIDMap.containskey(ls2insertmap.get(str).maxid)){
                            system.debug('hiiii');
                            ler.Patient__c = maxIDMap.get(ler.Max_ID__c).ID;
                            if(maxIDMap.get(ler.Max_ID__c).PersonMobilePhone !=Null)
                            ler.Mobile_Phone__c = maxIDMap.get(ler.Max_ID__c).PersonMobilePhone;
                            else{
                                if(maxIDMap.get(ler.Max_ID__c).phone != Null)
                                ler.Mobile_Phone__c = maxIDMap.get(ler.Max_ID__c).phone;
                            }
                        }
                        lead2insert.put(str,ler);
                    }
                    
                    if(lead2insert.keyset().size() > 0)
                        upsert lead2insert.values() Visit_Id__c;
                    string leadId='';
                    
                    for(Lead__C keyVal : lead2insert.values()){
                        leadId+=' '+keyVal.id+' '+',';
                    }
                   leadId= leadId.removeend(',');
                    
                  msg=  '{"success" : true,"message" : "Lead created successfully","ids":"'+leadId+'"}';
                    
                    
                 // msg='Lead created successfully with id' +leadId+' ';
                    for(Services__c ser : [select id,Service_Id__c from Services__c where Service_Id__c IN:idset.keyset()]){
                        if(idset.containskey(ser.Service_Id__c)){
                            idset.put(ser.Service_Id__c,ser);
                        }
                    }
                    
                    
                    list<Recommended_Test__c> rmd = new list<Recommended_Test__c>();
                    for(string id : lead2insert.keyset()){
                        for(wrapNew wrap : service2insertmap.get(id)){
                            Recommended_Test__c ery = wrap.rcmtest;
                            if(idset.get(wrap.serviceId) !=NULL)
                            ery.Services__c = (id)idset.get(wrap.serviceId).Id;
                            if(wrap.serviceId !=NULL)
                            ery.Service_Id__c=wrap.serviceId;
                            if(lead2insert.get(id).Id !=NULL)
                            ery.Leads__c = lead2insert.get(id).Id;
                            rmd.add(ery);
                        }
                    }
                    if(rmd.size() > 0)
                        insert rmd;
                    /*lead.Patient__c=accList[0].id; 
lead.Mobile_Phone__c=accList[0].PersonMobilePhone;

lead.Doctor__c=DocList[0].Id;  */ 
                    //lead.Doctor_Name__c='test';  
                    
                    //  lead.Test_MRP__c=   jsonBody.TESTMRP != null ? jsonBody.TESTMRP:null;
                    
                    
                    
                    
                    
                    
                    /*map<string,string> idServiceIdMap=new map<string,string>();
for(string key:serviceIDMAP.keyset()){
system.debug('key='+key);
system.debug('value='+serviceIDMAP.get(key).Service_Id__c);
idServiceIdMap.put(serviceIDMAP.get(key).Service_Id__c,key);
}
system.debug('map'+idServiceIdMap);
for(cls_RECOMENDEDTEST line : jsonBody.RECOMENDEDTEST){


}


if(listRecTest !=NULL && listRecTest.size()>0)
Insert listRecTest;*/
                    
                    
                    //}
                    
                    
                    
                }
                
                else{
                    return 'Please Provide lead details';
                }
                // if(!hjmap.containsKey(line.SERVICEID))
                //  hjmap.put(line.SERVICEID,null);
                
                /* 
// Map<id,map<id,s>>
//     map<id,Services__c> serviceIDMAP = new map<id,Services__c>();

List<Account> accList=[select id,Max_ID__c,Name,PersonMobilePhone from Account where  Max_ID__c IN: MaxidSet AND Recordtype.name='Patient'];
List<Account> DocList=[select id,alletec_doctorid__c,Name from Account where  alletec_doctorid__c IN:DoctoridSet AND Recordtype.name='Doctor'];
List<Lead__c> leadList=[select id from lead__c where Max_ID__c  IN: MaxidSet AND  Recordtype.name='OP-OP'];*/
                //  map<id,Account> AccountMAP = new map<id,Account>([select id,Max_ID__c,Name from Account where Max_ID__c =:jsonBody.MAXID AND Recordtype.name='Patient']);
                //  
                //  
                return msg;
            }
            catch(Exception e){
                return e.getMessage()+' '+e.getLineNumber();
            }
        }
        else{
            return 'Please Provide Request Body';
        }
    }
    
    public class Wrapper{
        
        // public decimal TESTMRP;
        public cls_LEADINFO[] LEADINFO;
        
    }
    public class cls_RECOMENDEDTEST {
        public String SERVICEID;	//14901758
        public String TESTID;	//6086
        public String TESTNAME;	//TestName
        public String TESTMRP;	//420
    } 
    public class cls_LEADINFO {
        public cls_RECOMENDEDTEST[] RECOMENDEDTEST;
        public String MAXID;
        public String OPBILL;
        public String DOCTORID;
        public date   OPDDATE;
        public String VISITID;
        public String CHANNEL;
        public String PATIENTTYPE;
        public String UNITID;
        //public String TESTID;
        //public String TESTNAME;
        Public date VISITDATE;
        public string TEXTMRP;
        public string NAME;
    }
    public class wrapNew{
        public String serviceId;
        public Recommended_Test__c rcmtest;
        public wrapNew(){
            serviceId = '';
            rcmtest = new Recommended_Test__c();
        }
    }
    public class LeadWrapper{
        public Lead__c ld;
        public string docid;
        public string maxid;
        public LeadWrapper(){
            ld = new Lead__c();
            docid = '';
            maxid = '';
        }
    }
    
}