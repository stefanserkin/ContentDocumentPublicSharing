/*
 * Created by Stefan Serkin on July 29, 2021
 * */

trigger ContentDocumentLinkTrigger on ContentDocumentLink (before insert) {
    ContentDocumentLinkTriggerHandler.checkForPublicDocs(Trigger.new);
}