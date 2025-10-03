public with sharing class dividendController {

    public static void dividendControllerJson() {
        // 1. Get all existing dividends
        List<Dividend__c> existingDividends = [
            SELECT Id, Name, stockName__c, exDate__c, announcementDate__c
            FROM Dividend__c
        ];

        // 2. Build a map of stockName -> latest announcement date
        Map<String, Date> stockToAnnouncementDate = new Map<String, Date>();
        for (Dividend__c d : existingDividends) {
            if (d.stockName__c != null) {
                String key = d.stockName__c.trim();
                if (!stockToAnnouncementDate.containsKey(key) || 
                    d.announcementDate__c > stockToAnnouncementDate.get(key)) {
                    stockToAnnouncementDate.put(key, d.announcementDate__c);
                }
            }
        }

        List<Dividend__c> newDividends = new List<Dividend__c>();

        // 3. Loop through MoneyControl API pages
        for (Integer i = 1; i <= 20; i++) {
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(
                'https://api.moneycontrol.com/mcapi/v1/ecalendar/corporate-action' +
                '?indexId=All&event=D&apiVersion=161&orderBy=asc&deviceType=W&duration=UP&page=' + i
            );
            request.setMethod('GET');

            HttpResponse response = http.send(request);
            String rawResponse = response.getBody();
            System.debug('Page ' + i + ' Response: ' + rawResponse);

            String jsonString = rawResponse.replace('"list":', '"list_x":');
            dividendWrapper wrapper = 
                (dividendWrapper) JSON.deserialize(jsonString, dividendWrapper.class);

            if (wrapper == null || wrapper.data == null || wrapper.data.list_x == null) {
                break; // no more data, exit loop
            }

            for (dividendWrapper.Stock ss : wrapper.data.list_x) {
                String stockName = ss.stockName != null ? ss.stockName.trim() : null;
                if (String.isBlank(stockName)) continue;

                Date incomingAnnouncementDate = Date.parse(ss.announcementDate);
                Date existingDate = stockToAnnouncementDate.get(stockName);

                Boolean isNewOrUpdated = 
                    (existingDate == null || existingDate < incomingAnnouncementDate);

                if (isNewOrUpdated) {
                    // Handle '-' values safely
                    if (ss.perChange == '-') ss.perChange = '0';
                    if (ss.dividend == '-') ss.dividend = '0';

                    newDividends.add(new Dividend__c(
                        stockName__c = stockName,
                        name = stockName,
                        eventType__c = ss.eventType,
                        dividend__c = Decimal.valueOf(ss.dividend),
                        ratio__c = ss.ratio,
                        lastValue__c = Decimal.valueOf(ss.lastValue.replaceAll(',', '')),
                        perChange__c = Decimal.valueOf(ss.perChange),
                        scDid__c = ss.scDid,
                        ex__c = ss.ex,
                        marketCap__c = ss.marketCap,
                        url__c = ss.url,
                        scId__c = ss.scId,
                        exDate__c = Date.parse(ss.exDate),
                        announcementDate__c = incomingAnnouncementDate
                    ));
                }
            }
        }

        if (!newDividends.isEmpty()) {
            insert newDividends;
            System.debug('Inserted ' + newDividends.size() + ' new dividend records.');
        } else {
            System.debug('No new dividend records to insert.');
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<Dividend__c> dividendLwcController() {
        return [
            SELECT Id, Name, stockName__c, dividend__c, exDate__c, lastValue__c, announcementDate__c
            FROM Dividend__c
            WHERE exDate__c >= TODAY and dividend__c>0
            ORDER BY exDate__c
        ];
    }
}
