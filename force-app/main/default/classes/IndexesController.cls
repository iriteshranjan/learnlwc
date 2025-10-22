public with sharing class IndexesController {
    @AuraEnabled(cacheable=true)
    public static List<Indexes__c> getIndexes() {
        return [
            SELECT Id, Name, lastprice__c,change__c
            FROM Indexes__c 
            
        ];
    }
}