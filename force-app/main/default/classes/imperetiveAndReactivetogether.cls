public with sharing class imperetiveAndReactivetogether {
    @AuraEnabled(Cacheable=True)
    public static List<Race1__c> imperetiveAndReactivetogetherss() {

        List<Race1__c> race1=new List<Race1__c>();
        race1=[Select Id,Name from Race1__c];

        return race1;

    }
}