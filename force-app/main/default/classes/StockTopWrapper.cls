public with sharing class StockTopWrapper {

    @AuraEnabled(cacheable=false)
    public static MarketWrapper getTopMarketData(String marketType, Integer fetchCount) {
       // fetchCount=1000;
        String endPoint = 'https://api-en.cnbctv18.com/nodeapi/v1/markets/top?type=' 
                          + EncodingUtil.urlEncode(marketType,'UTF-8') 
                          + '&limit=' + fetchCount;

        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endPoint);
        req.setMethod('GET');
        HttpResponse res = http.send(req);
        
        if(res.getStatusCode() == 200){
            MarketWrapper mw = (MarketWrapper) JSON.deserialize(res.getBody(), MarketWrapper.class);
            return mw;
        } else {
            throw new AuraHandledException('Error fetching market data: ' + res.getStatus());
        }
    }

    public class MarketWrapper {
        @AuraEnabled public String element_name;
        @AuraEnabled public List<TabList> tab_list;
        @AuraEnabled public MarketData nse;
        @AuraEnabled public MarketData bse;
    }

    public class TabList {
        @AuraEnabled public String name;
        @AuraEnabled public String tab_key;
        @AuraEnabled public String status;
    }

    public class MarketData {
        @AuraEnabled public String lastUpdatedDate;
        @AuraEnabled public List<String> display_table_columns;
        @AuraEnabled public List<MarketItem> data;
        @AuraEnabled public Integer count;
    }

    public class MarketItem {
        @AuraEnabled public String sc_comp;
        @AuraEnabled public String close;
        @AuraEnabled public String change;
        @AuraEnabled public String gain;
        @AuraEnabled public String loss;
        @AuraEnabled public String percentChange; // added for LWC
    }
}