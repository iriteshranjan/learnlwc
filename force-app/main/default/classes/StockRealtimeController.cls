public  without sharing class StockRealtimeController {
    
    @AuraEnabled(cacheable=true)
    public static List<Stock__c> getAllStocks() {
        return [SELECT Id, Name,pricecurrent__c FROM Stock__c LIMIT 7000];
    }

    @AuraEnabled(cacheable=true)
    public static Stock__c getStockById(Id stockId) {
        return [
            SELECT Id, Name, slug__c, company__c, pricecurrent__c, Exchange__c, lastupd__c
            FROM Stock__c
            WHERE Id = :stockId
            LIMIT 1
        ];
    }

    @AuraEnabled
    public static Map<String, String> fetchAndUpdateStockData(Id stockId) {
        Stock__c stock = [SELECT Id, slug__c, company__c FROM Stock__c WHERE Id = :stockId LIMIT 1];
        List<Company__c> companies = [SELECT Id, moneycontrolCompanyId__c FROM Company__c WHERE slug__c = :stock.slug__c LIMIT 1];
        if (companies.isEmpty()) throw new AuraHandledException('No Company found.');

        String moneyId = companies[0].moneycontrolCompanyId__c;
        Map<String, Object> data = fetchFromAPI(moneyId, 'nse');

        if (String.isEmpty((String)data.get('pricecurrent'))) {
            data = fetchFromAPI(moneyId, 'bse');
        }

        if (!String.isEmpty((String)data.get('pricecurrent'))) {
            stock.pricecurrent__c = Decimal.valueOf((String)data.get('pricecurrent'));
            stock.Exchange__c = (String)data.get('exchange');
            stock.lastupd__c = (String)data.get('lastupd');
            update stock;
        }

        return new Map<String, String>{
            'company' => (String)data.get('company'),
            'pricecurrent' => (String)data.get('pricecurrent'),
            'exchange' => (String)data.get('exchange'),
            'lastupd' => (String)data.get('lastupd')
        };
    }

    private static Map<String, Object> fetchFromAPI(String id, String exchange) {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint('https://api-en.cnbctv18.com/nodeapi/v1/markets/equityCash?id=' + id + '&exchange=' + exchange);
        req.setTimeout(10000);
        HttpResponse res = http.send(req);
        if (res.getStatusCode() == 200) {
            Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            return (Map<String, Object>)result.get('data');
        } else {
            throw new CalloutException('Callout failed: ' + res.getStatus());
        }
    }
}