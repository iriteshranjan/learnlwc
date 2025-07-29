public class CompanyBruteForceScheduler implements Schedulable {
    public void execute(SchedulableContext sc) {
        System.enqueueJob(new CompanyBruteForceJob());
    }
}