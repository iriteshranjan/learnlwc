public with sharing class DividendScheduler implements Schedulable {
    public void execute(SchedulableContext sc) {
        System.enqueueJob(new DividendQueueable());
    }
}
