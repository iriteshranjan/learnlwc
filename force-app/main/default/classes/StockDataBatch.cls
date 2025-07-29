public with sharing class StockDataBatch implements Database.Batchable<SObject>, Database.AllowsCallouts {

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
            SELECT Id, Name, moneycontrolCompanyId__c 
            FROM Company__c 
            WHERE moneycontrolCompanyId__c != NULL
        ]);
    }

    public void execute(Database.BatchableContext bc, List<Company__c> companies) {
        List<Stock__c> toUpdate = new List<Stock__c>();
        List<Stock__c> toInsert = new List<Stock__c>();

        // Extract Company Ids as Strings since company__c is a text field
        Set<String> companyIds = new Set<String>();
        for (Company__c comp : companies) {
            companyIds.add(comp.Id);
        }

        // Load existing Stock__c records by text match
        Map<String, Stock__c> existingStocks = new Map<String, Stock__c>();
        for (Stock__c s : [
            SELECT Id, company__c 
            FROM Stock__c 
            WHERE company__c IN :companyIds
        ]) {
            existingStocks.put(s.company__c, s);
        }

        for (Company__c comp : companies) {
            String moneyId = comp.moneycontrolCompanyId__c;
            Map<String, Object> stockData = fetchStockData(moneyId, 'nse');

            if (stockData == null || String.valueOf(stockData.get('pricecurrent')).trim() == '') {
                stockData = fetchStockData(moneyId, 'bse');
            }

            if (stockData == null) continue;

            Boolean isUpdate = existingStocks.containsKey(comp.Id);
            Stock__c stock = isUpdate ? existingStocks.get(comp.Id) : new Stock__c();

            stock.company__c = comp.Id; // Set the ID as text
            stock.name = getVal(stockData, 'full_name');
            stock.full_name__c = getVal(stockData, 'full_name');
            stock.short_name__c = getVal(stockData, 'short_name');
            stock.slug__c = getVal(stockData, 'slug');
            stock.pricecurrent__c = toDecimal(stockData.get('pricecurrent'));
            stock.exchange__c = getVal(stockData, 'exchange');
            stock.MKTCAP__c = toDecimal(stockData.get('MKTCAP'));
            stock.X52H__c = toDecimal(stockData.get('52H'));
            stock.X52HDate__c = getVal(stockData, '52HDate');
            stock.X52L__c = toDecimal(stockData.get('52L'));
            stock.X52LDate__c = getVal(stockData, '52LDate');
            stock.priceprevclose__c = toDecimal(stockData.get('priceprevclose'));
            stock.OPN__c = toDecimal(stockData.get('OPN'));
            stock.BIDP__c = getVal(stockData, 'BIDP');
            stock.BIDQ__c = getVal(stockData, 'BIDQ');
            stock.OFFERP__c = toDecimal(getVal(stockData, 'OFFERP'));
            stock.LP__c = toDecimal(stockData.get('LP'));
            stock.HP__c = toDecimal(stockData.get('HP'));
            stock.VOL__c = toDecimal(stockData.get('VOL'));
            stock.pricechange__c = toDecimal(stockData.get('pricechange'));
            stock.lastupd__c = getVal(stockData, 'lastupd');
            stock.lastupd_epoch__c = getVal(stockData, 'lastupd_epoch');
            stock.pricepercentchange__c = getVal(stockData, 'pricepercentchange');
            stock.NSEID__c = getVal(stockData, 'NSEID');
            stock.BSEID__c = getVal(stockData, 'BSEID');
            stock.isinid__c = getVal(stockData, 'isinid');
            stock.PECONS__c = toDecimal(stockData.get('PECONS'));
            stock.BVCONS__c = toDecimal(stockData.get('BVCONS'));
            stock.PBCONS__c = toDecimal(stockData.get('PBCONS'));
            stock.cl1wPerChange__c = toDecimal(stockData.get('cl1wPerChange'));
            stock.cl1mPerChange__c = toDecimal(stockData.get('cl1mPerChange'));
            stock.cl3mPerChange__c = toDecimal(stockData.get('cl3mPerChange'));
            stock.cl1yPerChange__c = toDecimal(stockData.get('cl1yPerChange'));
            stock.cl2yPerChange__c = toDecimal(stockData.get('cl2yPerChange'));
            stock.cl6mPerChange__c = toDecimal(stockData.get('cl6mPerChange'));
            stock.cl5yPerChange__c = toDecimal(stockData.get('cl5yPerChange'));
            stock.IND_PE__c = toDecimal(stockData.get('IND_PE'));
            stock.ATF__c = getVal(stockData, 'ATF');

            if (isUpdate) {
                toUpdate.add(stock);
            } else {
                toInsert.add(stock);
            }
        }

        if (!toUpdate.isEmpty()) update toUpdate;
        if (!toInsert.isEmpty()) insert toInsert;
    }

    public void finish(Database.BatchableContext bc) {
        System.debug('✔️ Stock data batch completed.');
    }

    // ========== Helpers ==========

    private static Map<String, Object> fetchStockData(String id, String exchange) {
        String url = 'https://api-en.cnbctv18.com/nodeapi/v1/markets/equityCash?id=' 
                     + EncodingUtil.urlEncode(id, 'UTF-8') + '&exchange=' + exchange;

        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('GET');
        req.setTimeout(60000);

        try {
            HttpResponse res = http.send(req);
            if (res.getStatusCode() == 200) {
                Map<String, Object> outerr = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                if (outerr != null && String.valueOf(outerr.get('code')) == '200') {
                    return (Map<String, Object>) outerr.get('data');
                }
            }
        } catch (Exception e) {
            System.debug('❌ Fetch Error for ID: ' + id + ' - ' + e.getMessage());
        }
        return null;
    }

    private static String getVal(Map<String, Object> data, String key) {
        return data.containsKey(key) && data.get(key) != null ? String.valueOf(data.get(key)) : null;
    }

    private static Decimal toDecimal(Object val) {
        if (val == null) return null;
        try {
            return Decimal.valueOf(String.valueOf(val).replace(',', ''));
        } catch (Exception e) {
            return null;
        }
    }
}