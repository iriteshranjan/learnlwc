global class mutualFundControllerSchedule implements Schedulable,Database.AllowsCallouts{
    global void execute(SchedulableContext sc)
    {
        delete [select id from mutualFund__c];
        System.enqueueJob(new mutualFundInsertQueueable());
    }
    
    //mutualFundInsertQueueable=>mutualFundInsertQueueable=>mutualFundController

}