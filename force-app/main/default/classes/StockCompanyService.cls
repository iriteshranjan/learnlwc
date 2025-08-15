public class StockCompanyService {

    public class ResponseWrapper {
        public Boolean status;
        public String message;
        public DataWrapper data;
    }

    public class DataWrapper {
        public List<CompanyRecord> values;
        public Integer count;
    }

    public class CompanyRecord {
        public String dionCompanyCode;
        public String moneycontrolCompanyCode;
        public String sector;
        public String companyName;
        public String companyShortName;
        public Integer exchangeId;
        public String exchangeSymbol;
        public String slug;
        public String series;
        public String moneycontrolCompanyId;
        public String isInCode;
        public String industryName;
        public String industryCode;
        public String broadIndustryCode;
    }

    public static void bruteForceImportAllCompanies() {
        Http http = new Http();
        List<CompanyRecord> allApiRecords = new List<CompanyRecord>();

        allApiRecords.addAll(callAndCollect(http, 'a'));
        allApiRecords.addAll(callAndCollect(http, 'b'));
        allApiRecords.addAll(callAndCollect(http, 'c'));
        allApiRecords.addAll(callAndCollect(http, 'd'));
        allApiRecords.addAll(callAndCollect(http, 'e'));
        allApiRecords.addAll(callAndCollect(http, 'f'));
        allApiRecords.addAll(callAndCollect(http, 'g'));
        allApiRecords.addAll(callAndCollect(http, 'h'));
        allApiRecords.addAll(callAndCollect(http, 'i'));
        allApiRecords.addAll(callAndCollect(http, 'j'));
        allApiRecords.addAll(callAndCollect(http, 'k'));
        allApiRecords.addAll(callAndCollect(http, 'l'));
        allApiRecords.addAll(callAndCollect(http, 'm'));
        allApiRecords.addAll(callAndCollect(http, 'n'));
        allApiRecords.addAll(callAndCollect(http, 'o'));
        allApiRecords.addAll(callAndCollect(http, 'p'));
        allApiRecords.addAll(callAndCollect(http, 'q'));
        allApiRecords.addAll(callAndCollect(http, 'r'));
        allApiRecords.addAll(callAndCollect(http, 's'));
        allApiRecords.addAll(callAndCollect(http, 't'));
        allApiRecords.addAll(callAndCollect(http, 'u'));
        allApiRecords.addAll(callAndCollect(http, 'v'));
        allApiRecords.addAll(callAndCollect(http, 'w'));
        allApiRecords.addAll(callAndCollect(http, 'x'));
        allApiRecords.addAll(callAndCollect(http, 'y'));
        allApiRecords.addAll(callAndCollect(http, 'z'));

        if (allApiRecords.isEmpty()) {
            System.debug('⚠️ No API records returned.');
            return;
        }

        // Step 1: Prepare filters and deduplicate records using moneycontrolCompanyId
        Set<String> codes = new Set<String>();
        Set<String> ids = new Set<String>();
        Map<String, CompanyRecord> uniqueById = new Map<String, CompanyRecord>();

        for (CompanyRecord comp : allApiRecords) {
            if (comp.moneycontrolCompanyCode != null) {
                codes.add(comp.moneycontrolCompanyCode);
            }
            if (comp.moneycontrolCompanyId != null && !uniqueById.containsKey(comp.moneycontrolCompanyId)) {
                uniqueById.put(comp.moneycontrolCompanyId, comp);
                ids.add(comp.moneycontrolCompanyId);
            }
        }

        // Step 2: Query existing companies
        Map<String, company__c> existingMap = new Map<String, company__c>();
        Map<String, company__c> existingIdMap = new Map<String, company__c>();
        for (company__c existing : [
            SELECT Id, Name, companyShortName__c, exchangeSymbol__c, isInCode__c, industryName__c,
                   sector__c, Series__c, Slug__c, moneycontrolCompanyCode__c, dionCompanyCode__c,
                   exchangeId__c, moneycontrolCompanyId__c
            FROM company__c
            WHERE moneycontrolCompanyCode__c IN :codes OR moneycontrolCompanyId__c IN :ids
        ]) {
            if (existing.moneycontrolCompanyCode__c != null) {
                existingMap.put(existing.moneycontrolCompanyCode__c, existing);
            }
            if (existing.moneycontrolCompanyId__c != null) {
                existingIdMap.put(existing.moneycontrolCompanyId__c, existing);
            }
        }

        // Step 3: Prepare inserts and updates
        List<company__c> toInsert = new List<company__c>();
        List<company__c> toUpdate = new List<company__c>();

        for (CompanyRecord comp : uniqueById.values()) {
            if (String.isBlank(comp.moneycontrolCompanyId)) continue;

            company__c existing = existingIdMap.get(comp.moneycontrolCompanyId);

            company__c record = new company__c();
            record.Name = comp.companyName;
            record.companyShortName__c = comp.companyShortName;
            record.exchangeSymbol__c = comp.exchangeSymbol;
            record.isInCode__c = comp.isInCode;
            record.industryName__c = comp.industryName;
            record.sector__c = comp.sector;
            record.Series__c = comp.series;
            record.Slug__c = comp.slug;
            record.moneycontrolCompanyCode__c = comp.moneycontrolCompanyCode;
            record.dionCompanyCode__c = comp.dionCompanyCode;
            record.exchangeId__c = comp.exchangeId;
            record.moneycontrolCompanyId__c = comp.moneycontrolCompanyId;

            if (existing == null) {
                toInsert.add(record);
            } else if (hasChanged(record, existing)) {
                record.Id = existing.Id;
                toUpdate.add(record);
            }
        }

        // Step 4: Perform DML
        if (!toInsert.isEmpty()) {
            insert toInsert;
            System.debug('✅ Inserted ' + toInsert.size() + ' new companies.');
        }

        if (!toUpdate.isEmpty()) {
            update toUpdate;
            System.debug('♻️ Updated ' + toUpdate.size() + ' companies.');
        }

        if (toInsert.isEmpty() && toUpdate.isEmpty()) {
            System.debug('✅ No changes found. All records up to date.');
        }
    }

    private static Boolean hasChanged(company__c incoming, company__c existing) {
        return incoming.Name != existing.Name ||
               incoming.companyShortName__c != existing.companyShortName__c ||
               incoming.exchangeSymbol__c != existing.exchangeSymbol__c ||
               incoming.isInCode__c != existing.isInCode__c ||
               incoming.industryName__c != existing.industryName__c ||
               incoming.sector__c != existing.sector__c ||
               incoming.Series__c != existing.Series__c ||
               incoming.Slug__c != existing.Slug__c ||
               incoming.dionCompanyCode__c != existing.dionCompanyCode__c ||
               incoming.exchangeId__c != existing.exchangeId__c ||
               incoming.moneycontrolCompanyId__c != existing.moneycontrolCompanyId__c;
    }

    private static List<CompanyRecord> callAndCollect(Http http, String letter) {
        List<CompanyRecord> result = new List<CompanyRecord>();
        try {
            String endpoint = 'https://api-en.cnbctv18.com/nodeapi/v1/markets/companies?letter=' + letter + '&limit=1000&offset=0&pagination=true';
            HttpRequest req = new HttpRequest();
            req.setEndpoint(endpoint);
            req.setMethod('GET');
            HttpResponse res = http.send(req);

            if (res.getStatusCode() == 200) {
                ResponseWrapper wrapper = (ResponseWrapper) JSON.deserialize(res.getBody(), ResponseWrapper.class);
                if (wrapper != null && wrapper.data != null && wrapper.data.values != null) {
                    result.addAll(wrapper.data.values);
                }
            } else {
                System.debug('❌ Failed for letter ' + letter + ' | Status: ' + res.getStatus());
            }
        } catch (Exception ex) {
            System.debug('❌ Exception for letter ' + letter + ': ' + ex.getMessage());
        }

        return result;
    }
}