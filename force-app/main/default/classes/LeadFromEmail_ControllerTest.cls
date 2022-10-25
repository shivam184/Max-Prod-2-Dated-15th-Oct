@isTest
public class LeadFromEmail_ControllerTest {
    
    static testMethod void testUnsubscribe() 
    {
        
        String leadRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('International Tagging').getRecordTypeId();
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env    = new Messaging.InboundEnvelope();
        
        lead__c  ld = new lead__c();
        ld.Name='smith'; 
        ld.Email__c='test@test.com';
        ld.RecordTypeId=leadRecordTypeId;
        insert ld ;
        
        email.subject = 'Test Contact Email';
        env.fromAddress = 'test@test.com';
        email.htmlBody ='<html> <head> <meta http-equiv="Content-Type" content="text/html; charset=utf-8"> <title>SMS To Mail Report</title> </head> <body> <p>Hi, <br> <br> &nbsp; Kindly find attached the following auto generated information mapped for you via your E-mail ID: </p> <div align="center"> <table width="50%" border="0" cellpadding="1" cellspacing="1"> <tbody> <tr> <td> <div align="center"><br> <strong style="color: #CC0099;">SMS To Mail Report</strong> </div> </td> </tr> </tbody> </table> </div> <div align="center"> <table width="50%" border="1" cellpadding="1" cellspacing="0" bordercolor="#000000" bgcolor="#CC0099" style="color: #FFFFFF;"> <tbody> <tr> <td width="22%"> <p><strong>Name :</strong> </p> </td> <td width="28%"> <p><strong>NA</strong> </p> </td> </tr> <tr> <td width="22%"> <p><strong>Mobile No.:</strong> </p> </td> <td width="28%"> <p><strong>&#43;8105536434</strong> </p> </td> </tr> <tr> <td width="22%"> <p><strong>Executive Name :</strong> </p> </td> <td width="28%"> <p><strong>NA</strong> </p> </td> </tr> <tr> <td width="22%"> <p><strong>Message :</strong> </p> </td> <td width="28%"> <p><strong>MSS Patient Aseel Ali ahmed hetar Referred by Abu saad Regards Lavanya Medicare</strong> </p> </td> </tr> <tr> <td width="22%"> <p><strong>Time :</strong> </p> </td> <td width="28%"> <p><strong>16:30:56</strong> </p> </td> </tr> <tr> <td width="22%"> <p><strong>Date :</strong> </p> </td> <td width="28%"> <p><strong>02-Apr-2019</strong> </p> </td> </tr> </tbody> </table> </div> <p><br> Hope this information was useful for you. <br> <br> Thanks !!! </p> <br> <hr> <font face="Arial" color="Green" size="1"><br> “Please avoid printing this email unless necessary.<br> </font><br> <hr> <font face="Arial" color="Black" size="1"><br> This email (including any accompanying attachments/ documents) is intended for the use of the addressee(s) alone and may contain confidential and privileged information. Access, disclosure, copying, distribution or reliance upon this email by any other person is prohibited.<br> <br> If you have received this e-mail by error, please delete it forthwith with due confirmation to the sender. Any opinion, conclusion and other information in this message not relating to the official business of Max Healthcare Institute Limited shall be understood as neither given nor endorsed by it.<br> <br> Emails are not secure and capable of interception, corruption and delays. Anyone communicating with Max Healthcare Institute Limited by email accepts the risks involved and their consequences.”<br> </font> </body> </html>';        
        LeadFromEmail_Controller obj= new LeadFromEmail_Controller();
        obj.handleInboundEmail(email, env );
    }
}