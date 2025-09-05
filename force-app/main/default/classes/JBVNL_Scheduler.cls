global with sharing class JBVNL_Scheduler implements Schedulable {
    global void execute(SchedulableContext sc) {
        // Enqueue the callout job
        System.enqueueJob(new JBVNL_CalloutQueueable());
    }
}
