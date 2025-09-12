public with sharing class JBVNL_CalloutQueueable implements Queueable, Database.AllowsCallouts {
    public void execute(QueueableContext qc) {
        jbvnlCalloutController.calloutController();
    }
}