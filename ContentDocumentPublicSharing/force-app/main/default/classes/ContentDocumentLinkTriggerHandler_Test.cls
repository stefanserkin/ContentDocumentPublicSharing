/*
 * Created by Stefan Serkin on July 29, 2021
 * */

 @isTest
public with sharing class ContentDocumentLinkTriggerHandler_Test {

    @isTest
    public static void unitTest1() {
        Account acc = new Account(Name='Test Account');
        insert acc;

        Contact ct = new Contact(FirstName='Test', LastName='Contact', Email='test@testcontact.com', AccountId=acc.Id);
        insert ct;

        Test.startTest();

        ContentVersion cv = new ContentVersion();
        cv.Title = 'Billing Statement';
        cv.PathOnClient='/' + cv.Title + '.jpg';
        Blob bodyBlob = Blob.valueOf('Doc Body Blob');
        cv.VersionData = bodyBlob;
        cv.origin = 'H';
        insert cv;

        // Requery for content document id
        ContentVersion cvWithDocId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id LIMIT 1];

        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.LinkedEntityId = ct.Id;
        cdl.ContentDocumentId = cvWithDocId.ContentDocumentId;
        cdl.ShareType = 'V';
        cdl.Visibility = 'InternalUsers';
        insert cdl;

        Test.stopTest();

        ContentDocumentLink cdlToVerify = [SELECT Id, ShareType, Visibility FROM ContentDocumentLink WHERE Id = :cdl.Id LIMIT 1];

        System.assertEquals('I', cdlToVerify.ShareType, 'Share type unexpected');
        System.assertEquals('AllUsers', cdlToVerify.Visibility, 'Visibilty unexpected');
    }
    
}
