public with sharing class dividendController {

    public static void dividendControllerJson() {
        // 1. Get all existing dividends
        List<Dividend__c> existingDividends = [
            SELECT Id, Name, stockName__c, exDate__c, announcementDate__c, dividend__c
            FROM Dividend__c
        ];

        // 2. Build helper maps
        Map<String, Date> stockToAnnouncementDate = new Map<String, Date>();
        Map<String, Dividend__c> existingRecordMap = new Map<String, Dividend__c>();

        for (Dividend__c d : existingDividends) {
            if (d.stockName__c != null && d.exDate__c != null && d.announcementDate__c != null) {
                String key = d.stockName__c.trim() + '|' + d.exDate__c.format() + '|' + d.announcementDate__c.format();
                existingRecordMap.put(key, d);
            }

            // Track latest announcement date for insert logic
            if (d.stockName__c != null) {
                String key = d.stockName__c.trim();
                if (!stockToAnnouncementDate.containsKey(key) || d.announcementDate__c > stockToAnnouncementDate.get(key)) {
                    stockToAnnouncementDate.put(key, d.announcementDate__c);
                }
            }
        }

        List<Dividend__c> newDividends = new List<Dividend__c>();
        List<Dividend__c> updateDividends = new List<Dividend__c>();

        // 3. Loop through API pages
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

            String jsonString = rawResponse.replace('"list":', '"list_x":');
            dividendWrapper wrapper = (dividendWrapper) JSON.deserialize(jsonString, dividendWrapper.class);

            if (wrapper == null || wrapper.data == null || wrapper.data.list_x == null) break;

            for (dividendWrapper.Stock ss : wrapper.data.list_x) {
                String stockName = ss.stockName != null ? ss.stockName.trim() : null;
                if (String.isBlank(stockName)) continue;

                // Parse and clean values
                Date incomingAnnouncementDate = Date.parse(ss.announcementDate);
                Date exDate = Date.parse(ss.exDate);
                if (ss.perChange == '-') ss.perChange = '0';
                if (ss.dividend == '-') ss.dividend = '0';

                Decimal incomingDividend = Decimal.valueOf(ss.dividend);

                // Create unique key for match check
                String key = stockName + '|' + exDate.format() + '|' + incomingAnnouncementDate.format();

                Dividend__c existingRec = existingRecordMap.get(key);

                // 🟢 CASE 1: Update if existing record has 0 dividend and new value > 0
                if (existingRec != null && existingRec.dividend__c == 0 && incomingDividend > 0) {
                    existingRec.dividend__c = incomingDividend;
                    existingRec.lastValue__c = Decimal.valueOf(ss.lastValue.replaceAll(',', ''));
                    existingRec.perChange__c = Decimal.valueOf(ss.perChange);
                    existingRec.eventType__c = ss.eventType;
                    updateDividends.add(existingRec);
                    continue;
                }

                // 🟢 CASE 2: Insert new if announcement date is newer
                Date existingDate = stockToAnnouncementDate.get(stockName);
                Boolean isNewOrUpdated = (existingDate == null || existingDate < incomingAnnouncementDate);

                if (isNewOrUpdated && existingRec == null) {
                    newDividends.add(new Dividend__c(
                        stockName__c = stockName,
                        name = stockName,
                        eventType__c = ss.eventType,
                        dividend__c = incomingDividend,
                        ratio__c = ss.ratio,
                        lastValue__c = Decimal.valueOf(ss.lastValue.replaceAll(',', '')),
                        perChange__c = Decimal.valueOf(ss.perChange),
                        scDid__c = ss.scDid,
                        ex__c = ss.ex,
                        marketCap__c = ss.marketCap,
                        url__c = ss.url,
                        scId__c = ss.scId,
                        exDate__c = exDate,
                        announcementDate__c = incomingAnnouncementDate
                    ));
                }
            }
        }

        // 4. DML operations
        if (!newDividends.isEmpty()) {
            insert newDividends;
            System.debug('Inserted ' + newDividends.size() + ' new dividend records.');
        }

        if (!updateDividends.isEmpty()) {
            update updateDividends;
            System.debug('Updated ' + updateDividends.size() + ' existing dividend records with new values.');
        }

        if (newDividends.isEmpty() && updateDividends.isEmpty()) {
            System.debug('No new or updated dividend records to process.');
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<Dividend__c> dividendLwcController() {

        List<Dividend__c> reutrnDividend= [
            SELECT Id, Name, stockName__c, dividend__c, exDate__c, lastValue__c, announcementDate__c
            FROM Dividend__c
            WHERE exDate__c >= TODAY 
            ORDER BY exDate__c
        ];
        
        return reutrnDividend;
    }
}