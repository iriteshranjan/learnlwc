public class IndexQueueableCallout implements Queueable {
    
     public void execute(QueueableContext context) {
           StockHTTPsync.doCallout();
    }
}