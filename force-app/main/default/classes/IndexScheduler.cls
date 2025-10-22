public class IndexScheduler implements Schedulable {
     public void execute(SchedulableContext SC) {
     System.enqueueJob(new IndexQueueableCallout());
   }
}