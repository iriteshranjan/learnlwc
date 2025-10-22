public class StockStatusHTMLJob implements Schedulable {
    public void execute(SchedulableContext sc) {
        StockStatusCreator.createMissingStockStatusHTMLs();
    }
}