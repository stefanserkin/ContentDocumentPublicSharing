/*
 * Created by Stefan Serkin on July 29, 2021
 * */

public with sharing class ContentDocumentLinkTriggerHandler {

    public static void checkForPublicDocs(List<ContentDocumentLink> lstCDLsInTrigger) {
        // Create empty list of documents to update
        List<ContentDocumentLink> lstCDLsToUpdate = new List<ContentDocumentLink>();
        // Get titles from custom metadata
        Set<String> setPublicTitles = new Set<String>(getPublicTitles());
        // Create map with content document titles
        Set<Id> setCDIds = new Set<Id>();
        for (ContentDocumentLink cdl : lstCDLsInTrigger) {
            setCDIds.add(cdl.ContentDocumentId);
        }
        List<ContentDocument> lstCDs = [SELECT Id, Title FROM ContentDocument WHERE Id IN :setCDIds];
        Map<Id, String> mapDocumentTitles = new Map<Id, String>();
        for (ContentDocument cd : lstCDs) {
            mapDocumentTitles.put(cd.Id, cd.Title);
        }

        for (ContentDocumentLink cdl : lstCDLsInTrigger) {
            // Get document title from map
            String strCDTitle = mapDocumentTitles.get(cdl.ContentDocumentId);
            if (setPublicTitles.contains(strCDTitle) && cdl.Visibility != 'AllUsers') {
                lstCDLsToUpdate.add(cdl);
            }
        }

        if (!lstCDLsToUpdate.isEmpty()) {
            makeDocsPublic(lstCDLsToUpdate);
        }
    }

    public static void makeDocsPublic(List<ContentDocumentLink> lstCDLsToUpdate) {
        for (ContentDocumentLink cdl : lstCDLsToUpdate) {
            cdl.ShareType  = 'I';
            cdl.Visibility = 'AllUsers';
        }
    }

    public static Set<String> getPublicTitles() {
        // Store titles of documents that should be public in a set
        List<Public_Document_Title__mdt> lstPDTs = Public_Document_Title__mdt.getall().values();
        Set<String> setPDTLabels = new Set<String>();
        for (Public_Document_Title__mdt pdt : lstPDTs) {
            setPDTLabels.add(pdt.Label);
        }
        return setPDTLabels;
    }
    
}