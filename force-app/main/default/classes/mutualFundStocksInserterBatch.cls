global class mutualFundStocksInserterBatch implements Database.Batchable<SObject>,Database.allowsCallouts{
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        //List<mutualFund__c> mf=[Select id,direct_search_id__c from mutualFund__c ];
        return Database.getQueryLocator ('Select id,direct_search_id__c from mutualFund__c');
        
    }
    global void execute(Database.BatchableContext bc,List<mutualFund__c> scope)
    {
        for(mutualFund__c mf:scope)
        {
            Http h=new http();
            HttpRequest req=new HttpRequest();
            req.setEndpoint('https://groww.in/v1/api/data/mf/web/v4/scheme/search/'+mf.direct_search_id__c);
            req.setMethod('GET');
           	HttpResponse res=h.send(req);
            List<mutualFundStocks__c> stocks=new List<mutualFundStocks__c>();
            if(res.getStatuscode()==200)
            {
                Map<String,Object> data=(Map<String,Object>) JSON.deserializeUntyped(res.getBody());
                List<Object> stockHoldings=(List<Object> )data.get('holdings');
                for(Object stockHoldingsData:stockHoldings)
                {
                    Map<String,Object> holdings=(Map<String,Object>) stockHoldingsData;
                    
                    mutualFundStocks__c mfs=new mutualFundStocks__c(
                    name=(String)holdings.get('company_name'),
                    nature_name__c=(String)holdings.get('nature_name'),
                    company_name__c=(String)holdings.get('company_name'),
                    portfolio_date__c=(String)holdings.get('portfolio_date'),
                    rating__c=(String)holdings.get('rating'),
                    rating_market_cap__c=(String)holdings.get('rating_market_cap'),
                    scheme_code__c=(String)holdings.get('scheme_code'),
                    sector_name__c=(String)holdings.get('sector_name'),
                    mutualFund__c=mf.id,
                    corpus_per__c=Integer.valueOf(holdings.get('corpus_per')),
                    instrument_name__c=(String)holdings.get('instrument_name'),
                    market_cap__c=Integer.valueOf(holdings.get('market_cap')),
                    market_value__c =Integer.valueOf(holdings.get('market_value'))
                    );
                    stocks.add(mfs);
                }
                //insert stocks; bug to be fixed
            }
        }
    }
    global void finish(Database.BatchableContext bc) {
        System.debug('✅ mutualFundStocksInserterBatch completed successfully.');
    }

}