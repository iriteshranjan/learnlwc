public class mutualFundLwc {
    
    @auraEnabled(Cacheable=true)
    public static List<mutualFund__c> selectmutualFund(String fundName)
    {
        return [Select id,name,direct_scheme_name__c from mutualFund__c where direct_scheme_name__c like :('%' + fundName + '%')  limit 10];
    }
    
    @auraEnabled(Cacheable=true)
    public static List<mutualFundStocks__c> mutualFundStocks(List<mutualFund__c> mf)
    {
        Set<Id> ids =new Set<Id>();
        for(mutualFund__c idd:mf)
        {
            ids.add(idd.id);
        }
        
        return [Select id, name, instrument_name__c ,mutualFund__r.name, corpus_per__c from mutualFundStocks__c where mutualFund__c in:ids ];
    }

}