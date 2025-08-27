public with sharing class practiceAPEX {

    @AuraEnabled(Cacheable=true)
    public static List<Account>practiceApexCode() {

        List<Account> ll=[Select id,name ,(Select id, name from contacts) from Account LIMIT 5];
        return ll;
    }
}