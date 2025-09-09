public with sharing class DividendQueueable implements Queueable, Database.AllowsCallouts {
    public void execute(QueueableContext context) {
        dividendController.dividendControllerJson();
    }
}
