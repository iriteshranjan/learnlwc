public with sharing class AccountController {
   
    @AuraEnabled(Cacheable=true)//if gettigng some data
    public static List<Account>getAccountList()
    {
        return [Select id,name , type from Account where RecordTypeId!='012IS0000016ps4YAA' LIMIT 5];
    }

    @AuraEnabled(Cacheable=true)
    public static List<Account> filterAccountByType(String type)
    {
      return [Select id,name , Type from Account where Type=:type Limit 5];

    }

    @AuraEnabled(Cacheable=false)
    public static List<Account> findAccounts(String searchkey)
    {
      String key='%'+searchkey+'%';
      return [Select Id,Name  from Account WHERE Name like :key limit 5];

    }




    
}