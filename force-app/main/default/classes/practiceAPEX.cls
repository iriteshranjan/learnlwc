public with sharing class practiceAPEX {

    @AuraEnabled(Cacheable=true)
    public static List<Account>practiceApexCode() {

        List<Account> ll=[Select Id,Name ,(Select Id, Name from contacts) from Account LIMIT 5];
        system.debug('Accounts:'+ll);
        return ll;
    }
}