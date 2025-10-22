public class StockStatusBatchJob implements Database.Batchable<SObject> {

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Id, Name FROM Stock__c');
    }

    public void execute(Database.BatchableContext bc, List<Stock__c> stockList) {
        // Fetch existing StockStatusHTML__c for all stock__c in this batch
        Set<Id> stockIds = new Set<Id>();
        for (Stock__c stock : stockList) {
            stockIds.add(stock.Id);
        }

        Map<Id, StockStatusHTML__c> existingStatusMap = new Map<Id, StockStatusHTML__c>();
        for (StockStatusHTML__c status : [
            SELECT Id, stock__c FROM StockStatusHTML__c WHERE stock__c IN :stockIds
        ]) {
            existingStatusMap.put(status.stock__c, status);
        }

        List<StockStatusHTML__c> toInsert = new List<StockStatusHTML__c>();
        List<StockStatusHTML__c> toUpdate = new List<StockStatusHTML__c>();

        for (Stock__c stock : stockList) {
            if (existingStatusMap.containsKey(stock.Id)) {
                StockStatusHTML__c existing = existingStatusMap.get(stock.Id);
                existing.Name = stock.Name;
                toUpdate.add(existing);
            } else {
                toInsert.add(new StockStatusHTML__c(
                    Name = stock.Name,
                    stock__c = stock.Id
                ));
            }
        }

        if (!toInsert.isEmpty()) {
            insert toInsert;
        }
        if (!toUpdate.isEmpty()) {
            update toUpdate;
        }
    }

    public void finish(Database.BatchableContext bc) {
        // Optional: log, email, etc.
    }
}