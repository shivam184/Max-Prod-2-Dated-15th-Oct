public with sharing class GenerateTemplatePDFController {
    public String visaInviteId;
    public String visaInviteNumber;
    public boolean isMax{get;set;}
    public boolean isBLK{get;set;}
    public boolean isNanavati{get;set;}
    public string footerimg {
        get;
        set;
    }
    public string bottomImgURL {
        get;
        set;
    }
    public List<String> bottomImageset {
        get;
        set;
    }
    public string invitefromaddress { get; set; } 
    public GenerateTemplatePDFController(){
        isMax = false;
        isBLK = false;
        isNanavati=false;
        visaInviteId = ApexPages.CurrentPage().getparameters().get('id');
        List<Visa_Invite__c> VisaInviteListData = new List<Visa_Invite__c>();
        VisaInviteListData = [select Id, Name, Taken_care_by_Name__c,Duration_in_India__c,Taken_Care_by_Mobile_No__c,Visa_Invite_Number__c,HCF_Partner_name__r.phone, Country__c, Country__r.Name, Country__r.Capital__c, Hotel_Address__c, Diagnosis__c, Doctor_Name__c, Doctor_Name__r.Name, Doctor_Name__r.Phone, Doctor_Specialty__c, Expiration_Date__c, Hospital_Location__r.Business_Unit_Code__c, Hospital_Location__r.HIS_ID__c, 
                              HCF_Partner_name__c, HCF_Partner_name__r.Name, Hospital_Location__c, Hospital_Location__r.Name, Hospital_Location__r.Business_Unit_HIS__c, Invite_address__c, Mobile_Number__c, Appointment_Date__c,Attendee_Active_Inactive__c,donor_active_inactive__c, 
                              Passport_number__c,Visited_last_time__c,Max_Id__c,Estimate_cost_of_treatment__c, Customer_Patient_Name__c, Doctor_Name_Referred_By__c, Hospital_Name_Referred_By__c, Ailment__c, (select id, Name, Passport_number__c, Relation__c, RecordTypeId from Attendant_Details__r where active__c= true) from Visa_Invite__c where Id = :visaInviteId limit 1
                             ];
        
        if(!VisaInviteListData.isEmpty()) {
            // Added by F
            if(String.isNotBlank(VisaInviteListData[0].Hospital_Location__r.Name)){
                if(VisaInviteListData[0].Hospital_Location__r.Name.containsIgnoreCase('BLK')){
                    isBLK = true;
                }
                else if(VisaInviteListData[0].Hospital_Location__r.Name.containsIgnoreCase('NANAVATI')){
                    isNanavati = true;
                }
                else if(VisaInviteListData[0].Hospital_Location__r.Name.containsIgnoreCase('MAX')){
                    isMax = true;
                }
            }
        }
    }
    public String templateBodyPreview {
        get {
            visaInviteId = ApexPages.CurrentPage().getparameters().get('id');
            visaInviteNumber = ApexPages.CurrentPage().getparameters().get('visaInviteNumber');
            List<Visa_Invite__c> VisaInviteList = new List<Visa_Invite__c>();
            List<Attendant_Detail__c> attendeesList = new List<Attendant_Detail__c>();
            Visa_InviteTemplate_Info__mdt visaInviteTemplateInfoRecord = new Visa_InviteTemplate_Info__mdt();
            String emailBody = '';
            String attandantInfo = '';
            String attandantInfo_1 = '';
            String attandantInfo_2 = '';
            String isAttendee = '';
            Integer numOfAttendee = 0;
            String attandeenames = '';
            String attandeepassport = '';
            String attandeerelation = '';
            String typeofAttendant = ''; 
            Integer SrNo = 1;
            String donorName = '';
            String donorPassport = '';
            String donorRelation = '';
            String attendeeRelation = '';
            String isDonor='';
            string TypeofAttend = '';
            string AttendantName ='';
            string DateofBirth= '' ;
            string passportnumber = '';
            String DOBAttendee ='';
            String MaxId = '';
            String CountryName = '';
            Id attendeeRTId = Schema.SObjectType.Attendant_Detail__c.getRecordTypeInfosByDeveloperName().get('Attendee').getRecordTypeId();
            Id donorRTId = Schema.SObjectType.Attendant_Detail__c.getRecordTypeInfosByDeveloperName().get('Donor').getRecordTypeId();
            VisaInviteList = [select Id, Name, Taken_care_by_Name__c,Duration_in_India__c,Taken_Care_by_Mobile_No__c,Visa_Invite_Number__c,HCF_Partner_name__r.phone, Country__c, Country__r.Name, Country__r.Capital__c, Hotel_Address__c, Diagnosis__c, Doctor_Name__c, Doctor_Name__r.Name, Doctor_Name__r.Phone, Doctor_Specialty__c, Expiration_Date__c, Hospital_Location__r.Business_Unit_Code__c, Hospital_Location__r.HIS_ID__c, 
                              HCF_Partner_name__c, HCF_Partner_name__r.Name, Hospital_Location__c, Hospital_Location__r.Name, Hospital_Location__r.Business_Unit_HIS__c, Invite_address__c, Mobile_Number__c, Appointment_Date__c, donor_active_inactive__c,Attendee_Active_Inactive__c,
                              Passport_number__c,Visited_last_time__c,Max_Id__c,Estimate_cost_of_treatment__c, Customer_Patient_Name__c, Doctor_Name_Referred_By__c, Hospital_Name_Referred_By__c, Ailment__c, Date_of_Birth__c,(select id, Name, Passport_number__c, Relation__c, RecordTypeId,Date_of_Birth__c from Attendant_Details__r where active__c= true order by createddate  asc) from Visa_Invite__c where Id = :visaInviteId limit 1
                             ];
            
            if(!VisaInviteList.isEmpty()) {
                if(String.valueof(VisaInviteList [0].Date_of_Birth__c) != null){
                    DateofBirth = String.valueof(VisaInviteList [0].Date_of_Birth__c);  
                }
                CountryName = VisaInviteList [0].Country__r.Name;
                MaxId = String.valueof(VisaInviteList [0].Max_Id__c);
                Integer totalAttendee = VisaInviteList [0].Attendant_Details__r.size();
                numOfAttendee = totalAttendee;
                System.debug('numOfAttendee@@' + numOfAttendee);
                for (Attendant_Detail__c attendantObj :VisaInviteList [0].Attendant_Details__r) {
                    if(attendantObj.RecordTypeId == donorRTId) {
                        typeofAttendant = ' (Donor)';
                        donorName = attendantObj.Name;
                        donorPassport = attendantObj.Passport_number__c;
                        donorRelation = attendantObj.Relation__c;
                        AttendantName = attendantObj.Name;
                        passportnumber = attendantObj.Passport_number__c;
                        isDonor =', donor';
                        DOBAttendee = String.valueof(attendantObj.Date_of_Birth__c);
                        system.debug('##Donar Name' + donorName );
                    } else if((attendantObj.RecordTypeId == attendeeRTId) && (SrNo == 1 || (SrNo == 2 && typeofAttendant != '')) && attendantObj.Relation__c!=null) {
                        attendeeRelation = attendantObj.Relation__c;
                    }
                    if(attendantObj.RecordTypeId == attendeeRTId){
                        typeofAttendant = ' (Attendee)';
                        TypeofAttend =  'Attendant';
                        AttendantName = attendantObj.Name;
                        passportnumber = attendantObj.Passport_number__c;
                        DOBAttendee = String.valueof(attendantObj.Date_of_Birth__c);
                    }
                    numOfAttendee = numOfAttendee - 1;
                    system.debug('numOfAttendee'+numOfAttendee);
                    isAttendee = 'and attendant';
                    attendeesList.add(attendantObj);
                    if(typeofAttendant != ' (Donor)'){
                        if(attandeenames!='')
                            attandeenames +='   '+ attendantObj.Name;// + '<br/>';
                        
                        else
                            attandeenames += attendantObj.Name; 
                        
                        attandeepassport += 'Passport no: ' + attendantObj.Passport_number__c + '<br/>';
                    }
                    
                    if(typeofAttendant ==' (Donor)'){
                        TypeofAttend = 'Donor';
                    }
                    if(typeofAttendant ==' (Donor)')
                        
                        attandantInfo = attandantInfo + 'Donar Name: ' + attendantObj.Name  + '<br/> Passport Number: ' + attendantObj.Passport_number__c + '<br/><br/>';
                    
                    else 
                        attandantInfo = attandantInfo + 'Attendant Name: ' + attendantObj.Name  + '<br/> Passport Number: ' + attendantObj.Passport_number__c + '<br/><br/>';
                    
                    
                    attandantInfo_1 = attandantInfo_1 + attendantObj.Name + typeofAttendant + ', Passport No: ' + attendantObj.Passport_number__c;
                    if(numOfAttendee > 1) {
                        attandantInfo_1 = attandantInfo_1 + ', ';
                    } else if(totalAttendee > 1 && numOfAttendee == 1) {
                        attandantInfo_1 = attandantInfo_1 + ' and ';
                    }
                    attandantInfo_2 = attandantInfo_2 + SrNo + ') ' + attendantObj.Name + typeofAttendant + ' with Passport No:' + attendantObj.Passport_number__c + '<br/>';
                    
                    SrNo = SrNo + 1;
                    
                }
                list<Visa_Invite_Templates_Headers_Footers__mdt> templatefooters = new List<Visa_Invite_Templates_Headers_Footers__mdt>([SELECT MasterLabel, DeveloperName, Business_Unit_Code_and_HIS_Id__c, Template_Footer__c, Hospital_Address__c FROM Visa_Invite_Templates_Headers_Footers__mdt]);
                System.debug('1111 List Data ' + templatefooters.size());
                Map<String, Visa_Invite_Templates_Headers_Footers__mdt> MaptemplateFooters = new Map<String, Visa_Invite_Templates_Headers_Footers__mdt>();
                if(templatefooters.size() > 0) {
                    for (Visa_Invite_Templates_Headers_Footers__mdt temp :templatefooters) {
                        MaptemplateFooters.put(temp.Business_Unit_Code_and_HIS_Id__c, temp);
                    }
                    system.debug('111111' + MaptemplateFooters);
                }
                String capital = '';
                if(VisaInviteList [0].Country__r.Capital__c != null) {
                    capital= VisaInviteList [0].Country__r.Capital__c + '<br/> ';
                } 
                
                //system.debug('typeofAttendant153'+typeofAttendant);
                //system.debug('typeofAttendant137'+typeofAttendant);
                List<Visa_InviteTemplate_Info__mdt> visaInviteTemplateInfoList=new List<Visa_InviteTemplate_Info__mdt>();
                if(VisaInviteList[0].Attendee_Active_Inactive__c ||VisaInviteList[0].donor_active_inactive__c ){
                    visaInviteTemplateInfoList = [SELECT MasterLabel, DeveloperName, Email_Template__c, Invite_To_address__c,Type_Of_attendant__c FROM Visa_InviteTemplate_Info__mdt where MasterLabel = :VisaInviteList [0].Country__r.Name   and Type_Of_attendant__c=: TypeofAttend ];
                    system.debug('visaInviteTemplateInfoList'+visaInviteTemplateInfoList);
                    if(visaInviteTemplateInfoList.size() > 0) {
                        visaInviteTemplateInfoRecord = visaInviteTemplateInfoList [0];
                    } else if(visaInviteTemplateInfoList.size() == 0 && TypeofAttend == 'Attendant'){ 
                        system.debug('visaInviteTemplateInfoList155'+visaInviteTemplateInfoList);
                        visaInviteTemplateInfoRecord.Invite_To_address__c = 'The Visa Section <br/> High Commission of India<br/> ' + capital + VisaInviteList [0].Country__r.Name + '<br/>';
                        visaInviteTemplateInfoRecord.Email_Template__c = 'Rest_of_the_Countries_attendant';
                    }
                    /*else {
                    visaInviteTemplateInfoRecord.Invite_To_address__c = 'The Visa Section <br/> High Commission of India<br/> ' + capital + VisaInviteList [0].Country__r.Name + '<br/>';
                    visaInviteTemplateInfoRecord.Email_Template__c = 'Turkmenistan_Visa_Template';
                }*/
                }
                else if(VisaInviteList[0].Attendee_Active_Inactive__c==false && VisaInviteList[0].donor_active_inactive__c==false){
                    visaInviteTemplateInfoList = [SELECT MasterLabel, DeveloperName, Email_Template__c, Invite_To_address__c,Type_Of_attendant__c FROM Visa_InviteTemplate_Info__mdt where MasterLabel = :VisaInviteList [0].Country__r.Name   and Type_Of_attendant__c=null ];
                    if(visaInviteTemplateInfoList.size() > 0) {
                        visaInviteTemplateInfoRecord = visaInviteTemplateInfoList [0];
                    }
                    else {
                    visaInviteTemplateInfoRecord.Invite_To_address__c = 'The Visa Section <br/> High Commission of India<br/> ' + capital + VisaInviteList [0].Country__r.Name + '<br/>';
                    visaInviteTemplateInfoRecord.Email_Template__c = 'Turkmenistan_Visa_Template';
                }
                }
                
                
                // system.debug('visaInviteTemplateInfoRecord@@' + visaInviteTemplateInfoRecord);
                
                for (Visa_InviteTemplate_Info__mdt inviteInfo :visaInviteTemplateInfoList) {
                    system.debug(VisaInviteList [0].Country__r.Name);
                    system.debug(inviteInfo.MasterLabel);
                    if(VisaInviteList [0].Country__r.Name == inviteInfo.MasterLabel) {
                        visaInviteTemplateInfoRecord = inviteInfo;
                    }
                }
                system.debug('typeofAttendant153'+typeofAttendant);
                system.debug('VisaInviteList@@' + VisaInviteList);
                system.debug(visaInviteTemplateInfoRecord.Email_Template__c);
                EmailTemplate et = [SELECT Id, Name, subject,DeveloperName, Body, HTMLValue FROM EmailTemplate WHERE DeveloperName = :visaInviteTemplateInfoRecord.Email_Template__c];
                
                system.debug('et.Name'+et.Name);
                system.debug('et.DeveloperName'+et.DeveloperName);
                
                
                emailBody = et.HTMLValue;
                
                if(et.DeveloperName !='Iraq_Template')
                    emailBody = emailBody.remove('Patient will be staying in hotel_address .');
                
                if(visaInviteTemplateInfoRecord.Invite_To_address__c != null) {
                    emailBody = emailBody.replace('Visa_Invite_To_Address', visaInviteTemplateInfoRecord.Invite_To_address__c);
                } else {
                    emailBody = emailBody.replace('Visa_Invite_To_Address', '');
                }
                string hospitaladdress = '';
                
                
                
                if(VisaInviteList [0].Hospital_Location__r.Business_Unit_Code__c != null && VisaInviteList [0].Hospital_Location__r.HIS_ID__c != null) {
                    system.debug('22222' + MaptemplateFooters.containsKey(VisaInviteList [0].Hospital_Location__r.Business_Unit_Code__c + VisaInviteList [0].Hospital_Location__r.HIS_ID__c));
                    if(MaptemplateFooters.containsKey(VisaInviteList [0].Hospital_Location__r.Business_Unit_Code__c + VisaInviteList [0].Hospital_Location__r.HIS_ID__c)) {
                        footerimg = MaptemplateFooters.get(VisaInviteList [0].Hospital_Location__r.Business_Unit_Code__c + VisaInviteList [0].Hospital_Location__r.HIS_ID__c).Template_Footer__c;
                        system.debug('############################ ' +footerimg);
                        //System.debug('33333' + VisaInviteList [0].Hospital_Location__r.Business_Unit_Code__c);
                        //System.debug('444444' + VisaInviteList [0].Hospital_Location__r.HIS_ID__c);
                        //System.debug('555555' + MaptemplateFooters.get(VisaInviteList [0].Hospital_Location__r.Business_Unit_Code__c + VisaInviteList [0].Hospital_Location__r.HIS_ID__c).Hospital_Address__c);
                        hospitaladdress = MaptemplateFooters.get(VisaInviteList [0].Hospital_Location__r.Business_Unit_Code__c + VisaInviteList [0].Hospital_Location__r.HIS_ID__c).Hospital_Address__c;
                        system.debug('6666666' + hospitaladdress );
                        //hospitaladdress = MaptemplateFooters.get(VisaInviteList [0].Hospital_Location__r.Business_Unit_Code__c + VisaInviteList [0].Hospital_Location__r.HIS_ID__c).Hospital_Address__c;
                        if(String.isNotBlank(emailBody) && String.isNotBlank(hospitaladdress) && emailBody.containsIgnoreCase('Hospital_Location')){
                            emailBody = emailBody.replace('Hospital_Location', hospitaladdress);
                        }
                    }
                }
                else{
                    emailBody = emailBody.replace('Hospital_Location', '');
                }
                bottomImageset = new List<String>();
                if(VisaInviteList [0].Invite_address__c != null) {
                    if(VisaInviteList [0].Invite_address__c.contains('<img ')) {
                        String imageURL = '';
                        Matcher imgMatcher = Pattern.compile('<img(.+?)>').matcher(VisaInviteList [0].Invite_address__c);
                        while(imgMatcher.find()) {
                            String imageTag = imgMatcher.group();
                            
                            System.debug('imageURL^^' + imageURL.unescapeHtml4());
                            if(imageURL.unescapeHtml4() != null && imageURL.unescapeHtml4() != '') {
                                bottomImgURL= imageURL.unescapeHtml4();
                                //bottomImageset.add(imageURL.unescapeHtml4());
                            }
                            
                        }
                    }
                }
                
                
                system.debug('bottomImageset@@' + bottomImageset);
                // if(imageURL.unescapeHtml4()!=null && imageURL.unescapeHtml4()!=''){
                //     bottomImgURL=imageURL.unescapeHtml4();
                // }
                system.debug('bottomImgURL@@' + bottomImgURL)
                    ;
                system.debug('attendeeRelation@@' + attendeeRelation);
                //
                integer i=0;
                
                if( VisaInviteList [0].Doctor_Name_Referred_By__c!=Null){
                    emailBody = emailBody.replace('doctor_reffred', VisaInviteList [0].Doctor_Name_Referred_By__c);
                    
                }
                else{
                    emailBody = emailBody.replace('doctor_reffred', '');
                }
                
                if( VisaInviteList [0].Hospital_Name_Referred_By__c!=Null){
                    emailBody = emailBody.replace('hospita_reffred', VisaInviteList [0].Hospital_Name_Referred_By__c);
                    
                }
                else{
                    emailBody = emailBody.replace('hospita_reffred', '');
                }
                
                if( VisaInviteList [0].Duration_in_India__c!=Null){
                    emailBody = emailBody.replace('duration_c', VisaInviteList [0].Duration_in_India__c);
                    
                }
                else{
                    emailBody = emailBody.replace('duration_c', '30');
                }
                
                
                if( VisaInviteList [0].Appointment_Date__c!=Null){
                    emailBody = emailBody.replace('Appointment_Date', string.valueOf( VisaInviteList[0].Appointment_Date__c));
                    
                }
                else{
                    emailBody = emailBody.replace('Appointment_Date', '');
                }
                
                
                if( VisaInviteList [0].Taken_care_by_Name__c==Null){
                    emailBody = emailBody.replace('<b>Patient will be taken care by Care_Taker , contact no. doctor_phone</b><br/>','');
                    
                }
                
                if( VisaInviteList [0].Taken_Care_by_Mobile_No__c==Null){
                    emailBody = emailBody.replace(', contact no. doctor_phone','');
                    
                }
                emailBody = emailBody.replace('appointment_date', VisaInviteList [0].Appointment_Date__c != null ? VisaInviteList [0].Appointment_Date__c.format('dd MMMMM, yyyy hh:mm a') :'');
                emailBody = emailBody.replace('doctor_phone', VisaInviteList [0].Taken_Care_by_Mobile_No__c != null ? VisaInviteList [0].Taken_Care_by_Mobile_No__c :'');
                if(VisaInviteList [0].Hotel_Address__c != null)
                    emailBody = emailBody.replace('hotel_address', VisaInviteList [0].Hotel_Address__c != null ? VisaInviteList [0].Hotel_Address__c :'');
                else
                    emailBody = emailBody.remove('Patient will be staying in hotel_address .');
                //emailBody = emailBody.replace('ref_no', VisaInviteList [0].Visa_Invite_Number__c != null ? VisaInviteList [0].Visa_Invite_Number__c :'');
                emailBody = emailBody.replace('ref_no', visaInviteNumber != null ? visaInviteNumber :'');
                emailBody = emailBody.replace('issue_date', system.today().day() + '/' + system.today().month() + '/' + system.today().year());
                emailBody = emailBody.replace('referred_by_doctor', VisaInviteList [0].Doctor_Name_Referred_By__c != null ? VisaInviteList [0].Doctor_Name_Referred_By__c :'');
                emailBody = emailBody.replace('referred_by_hospital', VisaInviteList [0].Hospital_Name_Referred_By__c != null ? VisaInviteList [0].Hospital_Name_Referred_By__c :'');
                emailBody = emailBody.replace('patient_ailment', VisaInviteList [0].Ailment__c != null ? VisaInviteList [0].Ailment__c :'');
                emailBody = emailBody.replace('if_attendee', isAttendee != '' ? 'Yes' :'No');
                
                if(attandeenames=='' && donorName==''){
                    emailBody = emailBody.replace('<b>The patient will be accompanied by following donor and attendant;</b><br/><br/>', '');
                    emailBody = emailBody.replace('<b>Donor: </b>Donor_Name, holding Passport no. Donor_Passport_Num<br/>', '');
                    emailBody = emailBody.replace('<b>Attendant:</b>Attendee_Names , holding Attendee_Passports<br/><br/>', '');
                    emailBody = emailBody.replace('donor and Attendant', '');
                }
                if(attandeenames  !=''){
                    emailBody = emailBody.replace('Attendee_Names', attandeenames != '' ? attandeenames :'');
                    emailBody = emailBody.replace('Attendee_Passports', attandeepassport != '' ? attandeepassport :'');
                }
                else{
                    i=1;
                    emailBody = emailBody.replace('<b>Attendant:</b>Attendee_Names , holding Attendee_Passports<br/><br/>', '');
                    emailBody = emailBody.replace('Patient will be accompanied by his attendant Attendee_Names, holder of Attendee_Passports', '');
                    emailBody = emailBody.replace('<div>Attendant: Attendee_Names, Attendee_Passports</div>', '');
                    emailBody = emailBody.replace('and Attendant',''); 
                    emailBody = emailBody.replace('and attendant','');
                    emailBody = emailBody.replace('Attendant','');
                    
                }
                system.debug('i'+emailBody);
                if(i==1){
                    emailBody = emailBody.replace('Kindly issue medical Visa to the patient, donor','Kindly issue medical Visa to the patient and donor ');
                }
                
                if(donorName !=''){
                    emailBody = emailBody.replace('Donor_Name', donorName != '' ? donorName :'');
                    emailBody = emailBody.replace('Donor_Passport_Num', donorPassport != '' ? donorPassport :'');
                    emailBody = emailBody.replace('Donor_Passport_Num', donorPassport != '' ? donorPassport :'');    
                    
                }
                else{
                    system.debug('hiiiiii'+emailBody);
                    emailBody= emailBody.replace(', donor', ''); 
                    emailBody= emailBody.replace('donor and', '');
                    emailBody = emailBody.replace('<b>Donor: </b>Donor_Name, holding Passport no. Donor_Passport_Num<br/>', '');
                }
                system.debug('emailBody@@' + emailBody);
                if(attandeenames =='' && donorName=='')
                    emailBody = emailBody.replace('The patient will be accompanied by following donor and attendant;', '');
                //system.debug('emailBody@@'+emailBody);
                //system.debug('size@@'+VisaInviteList [0].Attendant_Details__r.size());
                //system.debug('size!!!@@'+VisaInviteList [0].Attendant_Details__r[0].Relation__c);
                //emailBody = emailBody.replace('Attendee_relation', (VisaInviteList [0].Attendant_Details__r.size() > 0 && VisaInviteList [0].Attendant_Details__r [0].Relation__c != null) ? VisaInviteList [0].Attendant_Details__r [0].Relation__c :'');
                emailBody = emailBody.replace('Attendee_relation', attendeeRelation != '' ? attendeeRelation :'');
                emailBody = emailBody.replace('Donor_Relationship', donorRelation != '' ? donorRelation :'');
                
                // if (VisaInviteList[0].Invite_address__c != null) {
                //     String address = VisaInviteList[0].Invite_address__c.replaceAll('</p>', '');
                //     String address1 = address.replaceAll('<p>', '<br/>');
                //     emailBody = emailBody.replace('Invite_From_Address', address1);
                // } else {
                //     emailBody = emailBody.replace('Invite_From_Address', '');
                // }
                emailBody = emailBody.replace('Invite_From_Address', '')
                    ;
                invitefromaddress = VisaInviteList [0].Invite_address__c == null ? '' :VisaInviteList [0].Invite_address__c.replaceAll('<img', '<img style="height:100px;width:100px"');
                //String address = invitefromaddress.replaceAll('</p>', '');
                // String address1 = address.replaceAll('<p>', '<br/>');
                // invitefromaddress = address1;
                //    String y = x.replaceAll('<span[^>]*>','');
                //emailBody = emailBody.replace('Invite_From_Address', address);
                //if(VisaInviteList [0].Patient_Name__r.Name != null) {
                //
                
                if(VisaInviteList [0].Taken_care_by_Name__c != null) {
                    //emailBody = emailBody.replace('Patient_Name', VisaInviteList [0].Patient_Name__r.Name);
                    emailBody = emailBody.replace('Care_Taker', VisaInviteList [0].Taken_care_by_Name__c);
                } else {
                    emailBody = emailBody.replace('Care_Taker', '');
                    
                }  
                
                
                
                
                
                if(VisaInviteList [0].Customer_Patient_Name__c != null) {
                    //emailBody = emailBody.replace('Patient_Name', VisaInviteList [0].Patient_Name__r.Name);
                    emailBody = emailBody.replace('Patient_Name', VisaInviteList [0].Customer_Patient_Name__c);
                } else {
                    emailBody = emailBody.replace('Patient_Name', '');
                    
                }
                if(VisaInviteList [0].Passport_number__c != null) {
                    emailBody = emailBody.replace('Patient_Passport', VisaInviteList [0].Passport_number__c);
                }
                if(VisaInviteList [0].Hospital_Location__r.Name != null) {
                    emailBody = emailBody.replace('Hospital_Name', VisaInviteList [0].Hospital_Location__r.Name);
                } else {
                    emailBody = emailBody.replace('Hospital_Name', '');
                }
                // if (VisaInviteList[0].Hospital_Location__r.Business_Unit_HIS__c != null) {
                //     emailBody = emailBody.replace('Hospital_Location', VisaInviteList[0].Hospital_Location__r.Business_Unit_HIS__c);
                // } else {
                //     emailBody = emailBody.replace('Hospital_Location', '');
                // }
                if(VisaInviteList [0].Doctor_Name__r.Name != null) {
                    emailBody = emailBody.replace('Doctor_Name', VisaInviteList [0].Doctor_Name__r.Name);
                } else {
                    emailBody = emailBody.replace('Doctor_Name', '');
                }
                
                
                if(VisaInviteList [0].Max_Id__c != null) {
                    emailBody = emailBody.replace('Max_id', VisaInviteList [0].Max_Id__c);
                }
                
                if(VisaInviteList [0].Visited_last_time__c != null) {
                    emailBody = emailBody.replace('Visited_last_time', string.valueOf(VisaInviteList [0].Visited_last_time__c));
                }
                
                
                if(VisaInviteList [0].Estimate_cost_of_treatment__c != null) {
                    emailBody = emailBody.replace('Estimate_cost_of_treatment',string.valueOf(VisaInviteList [0].Estimate_cost_of_treatment__c));
                }
                
                
                if(VisaInviteList [0].Doctor_Specialty__c != null) {
                    emailBody = emailBody.replace('Doctor_Specialty', VisaInviteList [0].Doctor_Specialty__c);
                } else {
                    emailBody = emailBody.replace('Doctor_Specialty', '');
                    emailBody = emailBody.replace('(Doctor_Specialty)', '');
                }
                if(VisaInviteList [0].Country__c != null) {
                    emailBody = emailBody.replace('Country_Name', VisaInviteList [0].Country__r.Name);
                }
                if(VisaInviteList [0].Diagnosis__c != null) {
                    emailBody = emailBody.replace('Diagnosis_Name', VisaInviteList [0].Diagnosis__c);
                } else {
                    emailBody = emailBody.replace('Diagnosis_Name', '');
                }
                emailBody = emailBody.replace('authorized_signatory_name', Userinfo.getUserName() != null ? Userinfo.getUserName() :'');
                List<User> LstUserPhone = [Select phone from user where id = :Userinfo.getUserId()];
                emailBody = emailBody.replace('authorized_signatory_phone', LstUserPhone [0].phone != null ? LstUserPhone [0].phone :'');
                emailBody = emailBody.replace('authorized_signatory_email', Userinfo.getUserEmail() != null ? Userinfo.getUserEmail() :'');
                emailBody = emailBody.replace('Is_Attendee', isAttendee);
                emailBody = emailBody.replace('Attendee_Info', attandantInfo);
                emailBody = emailBody.replace('Attendees_Info_1', attandantInfo_1);
                emailBody = emailBody.replace('Attendees_Info_2', attandantInfo_2);
                emailBody = emailBody.replace('Is_Donor', isDonor);
                emailBody = emailBody.replace('AttendantName', AttendantName);
                //  emailBody = emailBody.replace('attandeepassport', attandeepassport);
                emailBody = emailBody.replace('passportnumber', passportnumber);
                //donor info
                emailBody = emailBody.replace('Donor_Name,', '');
                emailBody = emailBody.replace('Donor_Passport_Num,', '');
                
                emailBody = emailBody.replace('Email_Footer', System.Label.Footer_For_Email_Template);
                emailBody = emailBody.replace('DateofBirth', DateofBirth != null ? DateofBirth :'');
                emailBody = emailBody.replace('DOBAttendee', DOBAttendee != null ? DOBAttendee :'');
                emailBody = emailBody.replace('MaxId', MaxId != null ? MaxId :'');
                emailBody = emailBody.replace('CountryName', CountryName != null ? CountryName :'');
                
                system.debug('emailBody@@' + emailBody);
            }
            return '' + emailBody;
        }
        public set;
    }
}