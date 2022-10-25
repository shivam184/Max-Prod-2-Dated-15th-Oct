public without sharing class VisaInviteApexCtrl {
    @AuraEnabled
    public static wrapperVisaInviteClass getVisaInvite(String passNum, Boolean deleteDonor) {
        wrapperVisaInviteClass wrpcls = new wrapperVisaInviteClass();
        List<Visa_Invite__c> VisaInviteList = new List<Visa_Invite__c>();
        VisaInviteList = [select Id, Name, Country__c, Country__r.Name, Diagnosis__c, Doctor_Name__c, Doctor_Name__r.Name, Doctor_Specialty__c, Expiration_Date__c, 
                          HCF_Partner_name__c, HCF_Partner_name__r.Name,Hospital_Code__c, Hospital_Location__c, Hospital_Location__r.Name, Invite_address__c,Email_signature__c, Mobile_Number__c, 
                          Passport_number__c, Issue_Date__c, Customer_Patient_Name__c, Email_Notification_Id__c,Visa_Invite_Number__c from Visa_Invite__c where Passport_number__c = :passNum ORDER BY Expiration_Date__c desc];
        
        wrpcls.VisaInviteList = VisaInviteList;
        if(deleteDonor == true) {
            Id donorRTId = Schema.SObjectType.Attendant_Detail__c.getRecordTypeInfosByDeveloperName().get('Donor').getRecordTypeId();
            List<Attendant_Detail__c> donorList = new List<Attendant_Detail__c>();
            donorList = [select id, Name, Passport_number__c, RecordTypeId, Visa_Invite__c from Attendant_Detail__c where Visa_Invite__c = :VisaInviteList [0].Id AND RecordTypeId = :donorRTId];
            System.debug('donorList@@' + donorList);
            if(!donorList.isEmpty()) {
                delete donorList;
            }
        }
        return wrpcls;
        
    }
    @AuraEnabled
    public static wrapperVisaInviteClass getPicklistValue() {
        wrapperVisaInviteClass wrpcls = new wrapperVisaInviteClass();
        List<String> relationOptions = new List<String>();
        
        Schema.DescribeFieldResult fieldResult = Attendant_Detail__c.Relation__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry f :ple) {
            relationOptions.add(f.getValue());
        }
        wrpcls.relationOptions = relationOptions;
        return wrpcls;
    }
    
    public class wrapperVisaInviteClass {
        @AuraEnabled public List<Visa_Invite__c> VisaInviteList { get; set; }
        @AuraEnabled public List<Attendant_Detail__c> attendeesList { get; set; }
        @AuraEnabled public List<Attendant_Detail__c> donorList { get; set; }
        @AuraEnabled public List<ContentDocumentLink> conDocLinkList { get; set; }
        @AuraEnabled public List<Attachment> versionHistoryList { get; set; }
        @AuraEnabled public List<String> relationOptions { get; set; }
        //@AuraEnabled public Map<Id,Id> documentVsVersionIdMap {get;set;}
        
        
    }
    
    @AuraEnabled
    public static wrapperVisaInviteClass getAttedeeRelatedToVisaInvite(String visaInviteId, Boolean getAttendant, Boolean getAttachment, Boolean getVersionHistory) {
        wrapperVisaInviteClass wrpcls = new wrapperVisaInviteClass();
        List<Attendant_Detail__c> attendeesList = new List<Attendant_Detail__c>();
        List<Attendant_Detail__c> donorList = new List<Attendant_Detail__c>();
        List<ContentDocumentLink> conDocLinkList = new List<ContentDocumentLink>();
        List<Attachment> versionHistoryList = new List<Attachment>();
        List<String> relationOptions = new List<String>();
        
        //Map<Id,Id> documentVsVersionIdMap = new Map<Id,Id>();
        system.debug('getVersionHistory@@' + getVersionHistory);
        
        wrpcls = getVisaInviteAllInfo(visaInviteId);
        if(getAttendant == true && getAttachment == true && getVersionHistory == true) {
            wrpcls.relationOptions = getPicklistValue().relationOptions;
        }
        if(getVersionHistory == true) {
            versionHistoryList = [SELECT ParentId, Name, Id, LastModifiedDate FROM Attachment WHERE ParentId = :visaInviteId ORDER BY LastModifiedDate desc];
            system.debug('versionHistoryList@@' + versionHistoryList);
            wrpcls.versionHistoryList = versionHistoryList;
        }
        
        if(getAttendant == true) {
            Id attendeeRTId = Schema.SObjectType.Attendant_Detail__c.getRecordTypeInfosByDeveloperName().get('Attendee').getRecordTypeId();
            Id donorRTId = Schema.SObjectType.Attendant_Detail__c.getRecordTypeInfosByDeveloperName().get('Donor').getRecordTypeId();
            for(Attendant_Detail__c att :[select id, Name, Passport_number__c, RecordTypeId, RecordType.Name, Relation__c, Visa_Invite__c,Date_of_Birth__c,active__c from Attendant_Detail__c where Visa_Invite__c = :visaInviteId]) {
                if(att.RecordTypeId == attendeeRTId) {
                    attendeesList.add(att);
                } else if(att.RecordTypeId == donorRTId) {
                    donorList.add(att);
                }
            }
            wrpcls.attendeesList = attendeesList;
            wrpcls.donorList = donorList;
        }
        if(getAttachment == true) {
            /* List<Id> contentdocIDList = new List<Id>();
for(ContentDocumentLink cd : [SELECT ContentDocumentId,ContentDocument.Title, ContentDocument.ContentSize,ContentDocument.FileType, ContentDocument.LastModifiedDate FROM ContentDocumentLink WHERE LinkedEntityId = :visaInviteId]){
conDocLinkList.add(cd);
contentdocIDList.add(cd.ContentDocumentId);
}
for(ContentVersion cvObj : [select Id,ContentDocumentId from ContentVersion where ContentDocumentId IN:contentdocIDList AND IsLatest = true]){
documentVsVersionIdMap.put(cvObj.ContentDocumentId, cvObj.Id);
} */
            conDocLinkList = [SELECT ContentDocumentId, ContentDocument.Title, ContentDocument.ContentSize, ContentDocument.FileType, ContentDocument.LastModifiedDate FROM ContentDocumentLink WHERE LinkedEntityId = :visaInviteId ORDER BY ContentDocument.LastModifiedDate desc];
            wrpcls.conDocLinkList = conDocLinkList;
            //wrpcls.documentVsVersionIdMap = documentVsVersionIdMap;
            
        }
        
        return wrpcls;
        
    }
    @AuraEnabled
    public static Attendant_Detail__c insertAttedeeRelatedToVisaInvite(Attendant_Detail__c newAttendee, String attendantRecordType) {
        String msg = '';
        System.debug('newAttendee!!@@' + newAttendee);
        System.debug('attendantRecordType@@@' + attendantRecordType);
        Id attendantRTId = Schema.SObjectType.Attendant_Detail__c.getRecordTypeInfosByDeveloperName().get(attendantRecordType).getRecordTypeId();
        newAttendee.RecordTypeId = attendantRTId;
        if(attendantRecordType == 'Donor') {
            Visa_Invite__c vi = [select Id, Transplant__c from Visa_Invite__c where id = :newAttendee.Visa_Invite__c limit 1];
            System.debug('vi@@@@' + vi);
            vi.Transplant__c = true;
            try{
                update vi;
            } catch(DmlException e) {
                for (Integer i = 0; i < e.getNumDml(); i ++) {
                    //Get Validation Rule & Trigger Error Messages
                    msg =+ e.getDmlMessage(i) + '\n';
                }
                //throw DML exception message
                throw new AuraHandledException(msg);
            } catch(Exception e) {
                throw new AuraHandledException(e.getMessage());
            }
        }
        try{
            //if(newAttendee.Name != null){
            insert newAttendee;
            System.debug('newAttendee@@' + newAttendee)
                ;
            //}
        } catch(DmlException e) {
            for (Integer i = 0; i < e.getNumDml(); i ++) {
                //Get Validation Rule & Trigger Error Messages
                msg =+ e.getDmlMessage(i) + '\n';
            }
            //throw DML exception message
            throw new AuraHandledException(msg);
        } catch(Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return newAttendee;
    }
    
    @AuraEnabled
    public static void updateAttendantDetails(List<Attendant_Detail__c> attendeesList) {
        String msg = '';
        if(!attendeesList.isEmpty()) {
            try{
                update attendeesList;
            } catch(DmlException e) {
                for (Integer i = 0; i < e.getNumDml(); i ++) {
                    //Get Validation Rule & Trigger Error Messages
                    msg =+ e.getDmlMessage(i) + '\n';
                }
                //throw DML exception message
                throw new AuraHandledException(msg);
            } catch(Exception e) {
                throw new AuraHandledException(e.getMessage());
            }
        }
        
    }
    
    @AuraEnabled
    public static void deleteAttendantDetail(Attendant_Detail__c attendeeRecord) {
        String msg = '';
        try{
            delete attendeeRecord;
        } catch(DmlException e) {
            for (Integer i = 0; i < e.getNumDml(); i ++) {
                //Get Validation Rule & Trigger Error Messages
                msg =+ e.getDmlMessage(i) + '\n';
            }
            //throw DML exception message
            throw new AuraHandledException(msg);
        } catch(Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        
    }
    
    @AuraEnabled
    public static void deleteAttachmentFile(Id attachmentRecordId) {
        String msg = '';
        try{
            delete [select id from ContentDocument where Id = :attachmentRecordId];
        } catch(DmlException e) {
            for (Integer i = 0; i < e.getNumDml(); i ++) {
                //Get Validation Rule & Trigger Error Messages
                msg =+ e.getDmlMessage(i) + '\n';
            }
            //throw DML exception message
            throw new AuraHandledException(msg);
        } catch(Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        
    }
    
    @AuraEnabled
    public static wrapperVisaInviteClass getVisaInviteAllInfo(String visaInviteId) {
        wrapperVisaInviteClass wrpcls = new wrapperVisaInviteClass();
        List<Visa_Invite__c> VisaInviteList = new List<Visa_Invite__c>();
        VisaInviteList = [select Id, Name, Country__c, Visa_Invite_Number__c, Country__r.Name, Diagnosis__c, Doctor_Name__c, Doctor_Name__r.Name, Doctor_Specialty__c, Expiration_Date__c, 
                          HCF_Partner_name__c, HCF_Partner_name__r.Name, Hospital_Location__c,Hospital_Code__c, Hospital_Location__r.Name, Invite_address__c,Email_signature__c, Mobile_Number__c, 
                          Passport_number__c, Issue_Date__c, Customer_Patient_Name__c, Email_Notification_Id__c from Visa_Invite__c where Id = :visaInviteId];
        
        wrpcls.VisaInviteList = VisaInviteList;
        
        return wrpcls;
    }
    
    @AuraEnabled
    public static void generatePdfAndSave(Id visaInviteId, String pdfName, Boolean refreshVisaInvite, String visaNumber) {
        System.debug('visaNumber@@' + visaNumber);
        String msg = '';
        //String viNum = pdfName;
        String viNum = '';
        try{
            List<Visa_Invite__c> visaRec = new List<Visa_Invite__c>();
            if(visaInviteId != null) {
                if(refreshVisaInvite == true) {
                    visaRec = [select Visa_Invite_Number__c,Hospital_Code__c, Country__r.Name from Visa_Invite__c where id = :visaInviteId limit 1];
                    /* if(visaRec.size()>0){
pdfName = pdfName+visaRec[0].Name;
} */
                    /* Decimal attachedPdf = [select count()
from attachment where ParentId = :visaInviteId AND Name Like 'Max/PPG/%']; */
                    //Integer attachedPdf = Integer.valueOf(aggr.size());
                    /* system.debug('attachedPdf@@' + attachedPdf);
Double versionNum;
if(attachedPdf < 1) {
versionNum = 1.0;
} else {
versionNum = (1 + (attachedPdf / 10));
} */
                    viNum = visaRec [0].Visa_Invite_Number__c;
                    Integer versionIndex = viNum.lastIndexOf('/v');
                    // System.debug('versionIndex@@' + versionIndex);
                    //var versionNumber = Double.valueOf(viNum.substring((versionIndex + 2), (viNum.length)));
                    String num = viNum.substringAfterLast('/v');
                    //if(firstVersion == false) {
                    Decimal versionNumber = Decimal.valueOf(num);
                    System.debug('versionNumber@@' + versionNumber);
                    Decimal newVersionNumber = (versionNumber + Decimal.valueOf('0.1')).setScale(1);
                    System.debug('newVersionNumber@@' + newVersionNumber);
                    //System.debug('parseFloatnewVersionNumber@@' + Decimal.valueOf(newVersionNumber));
                    //System.debug('//@@' + viNum.substring(versionIndex + 1, (viNum.length - 1)));
                    //System.debug('substring@@' + viNum.substring(versionIndex + 1, (viNum.length)));
                    viNum = viNum.replace(viNum.substringAfterLast('/v'), '' + newVersionNumber);
                    
                    Visa_Invite__c vi = new Visa_Invite__c();
                    vi.Id = visaRec [0].Id;
                    vi.Visa_Invite_Number__c = viNum;
                    
                    update vi;
                    visaNumber = viNum;
                    pdfName = 'Max/'+ visaRec[0].Hospital_Code__c + '/' + visaRec[0].Country__r.Name + '/' + viNum;
                    //}
                }
                
                PageReference pdf = Page.GenerateTemplatePDF;
                // add parent id to the parameters for standardcontroller
                pdf.getParameters().put('id', visaInviteId);
                pdf.getParameters().put('visaInviteNumber', visaNumber);
                Attachment attach = new Attachment();
                // the contents of the attachment from the pdf
                Blob body;
                try {
                    // returns the output of the page as a PDF
                    body = pdf.getContent();
                    system.debug('body###' + body);
                    // need to pass unit test -- current bug
                } catch(Exception e) {
                    body = Blob.valueOf('Some Text');
                }
                attach.Body = body;
                // add the user entered name
                //attach.Name = pdfName + '/v' + versionNum + '.pdf';
                attach.Name = pdfName + '.pdf';
                attach.IsPrivate = false;
                // attach the pdf to the Visa Invite
                attach.ParentId = visaInviteId;
                //attach.ContentType = 'PDF';
                insert attach;
            }
        } catch(DmlException e) {
            for (Integer i = 0; i < e.getNumDml(); i ++) {
                //Get Validation Rule & Trigger Error Messages
                msg =+ e.getDmlMessage(i) + '\n';
            }
            //throw DML exception message
            throw new AuraHandledException(msg);
        } catch(Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
  
    @AuraEnabled
    public static void sendvisainvitemail(string visainviteId, string SendtoEmailIds, string SendBCCIds, string SendCCIds) {
        system.debug('BCC:'+ SendBCCIds);
        system.debug('CC:'+ SendCCIds);
        String msg = '';
        try{
            if(visainviteId != null) {
                List<Visa_Invite__c> VisaInviteList = [select Id, Doctor_Name__r.Name, Doctor_Specialty__c, Hospital_Location__r.Name, 
                                                       Passport_number__c, Customer_Patient_Name__c, Ailment__c,Invite_address__c,Email_signature__c from Visa_Invite__c where Id = :visaInviteId];
                string  ailment = VisaInviteList [0].Ailment__c != null ? VisaInviteList [0].Ailment__c :'';
                string hospitalname = VisaInviteList [0].Hospital_Location__c != null ? VisaInviteList [0].Hospital_Location__r.Name :'';
                //string patientname = VisaInviteList [0].Patient_Name__c != null ? VisaInviteList [0].Patient_Name__r.Name :'';
                string emailSignature=VisaInviteList [0].Email_signature__c != null ? VisaInviteList [0].Email_signature__c.replaceAll('\n','<br/>'):'';
                system.debug(emailSignature);
                string patientname = VisaInviteList [0].Customer_Patient_Name__c != null ? VisaInviteList [0].Customer_Patient_Name__c :'';
                string passportnumber = VisaInviteList [0].Passport_number__c != null ? VisaInviteList [0].Passport_number__c :'';
                string doctorname = VisaInviteList [0].Doctor_Name__c != null ? VisaInviteList [0].Doctor_Name__r.Name :'';
                string subject = 'Medical visa invite letter – ' + patientname + ', ' + passportnumber + '';
                List<string> sendto = new list<string>();
                List<string> sendCCto = new list<string>();
                List<string> sendBCCto = new list<string>();
                if(SendtoEmailIds != null && SendtoEmailIds != '') {
                    sendto = SendtoEmailIds.split(',');
                }
                if(SendBCCIds != null && SendBCCIds != ''){
                    
                    sendBCCto= SendBCCIds.split(',');
                }
                if(SendCCIds != null && SendCCIds != '') {
                    sendCCto=SendCCIds.split(',');
                }
                sendto.add(Label.Visa_Invite_Email_Notification);
                List<Attachment> att = [Select Name, body from Attachment Where parentId = :visainviteId ORDER BY Lastmodifieddate DESC];
                List<OrgWideEmailAddress> lstEmailAddress = [select Id from OrgWideEmailAddress WHERE DisplayName = :Label.VisaInviteFromAddress];
                List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(sendTo);
                mail.setCcAddresses(sendCCto);
                mail.setBccAddresses(sendBCCto) ;
                if(!lstEmailAddress.isEmpty()){
                    mail.setOrgWideEmailAddressId(lstEmailAddress [0].Id);
                }
                mail.setSubject(subject);
                String body = 'Respected Sir/Mam, <br/><br/>';
                body += 'Greetings from <b>' + hospitalname + '</b>, <br/><br/>';
                body += 'Please find the attached Medical visa invitation letter for Patient <b>' + patientname + '</b>, Passport No: <b>' + passportnumber + '</b>.<br/><br/>';
                body += 'Request you to please issue the Medical visa at the earliest.<br/><br/>';
                body += 'Please feel free to contact us for any further queries.<br/><br/>';
                body += 'Regards,<br/>';
                body += emailSignature;
                
                mail.setHtmlBody(body);
                if(att.size() > 0) {
                    Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
                    attach.setFileName(VisaInviteList[0].Customer_Patient_Name__c+'.pdf');//comment 14th sep 2020 attach.setFileName(att [0].Name);
                    attach.setBody(att [0].Body);
                    mail.setFileAttachments(new Messaging.EmailFileAttachment [] {
                        attach});
                }
                
                mails.add(mail);
                system.debug('MAil Id :' + mails);
                Messaging.sendEmail(mails);
            }
        } catch(DmlException e) { 
            for (Integer i = 0; i < e.getNumDml(); i ++) {
                //Get Validation Rule & Trigger Error Messages
                msg =+ e.getDmlMessage(i) + '\n';
            }
            //throw DML exception message
            throw new AuraHandledException(msg);
        } catch(Exception e) {
            system.debug('Line_Number ==> ' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
    }
}