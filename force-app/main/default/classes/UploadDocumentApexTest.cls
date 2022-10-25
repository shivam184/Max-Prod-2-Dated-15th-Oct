@isTest
public class UploadDocumentApexTest {
    @isTest
    public static void Test(){
        Account acc = new Account();
        acc.Name = 'Test';
        insert acc;
        UploadDocumentApex.doInitApex(acc.Id);
        UploadDocumentApex.handleSaveApex(acc.Id,'Anas,base64Data','Screenshot','notes','fileName');
    }
}