public class HourlyStockScheduler implements Schedulable {
    public void execute(SchedulableContext sc) {
        Database.executeBatch(new StockDataBatch(), 20); // 40 records per batch
    }
}