global class mutualFundInsertQueueable implements Queueable, Database.allowsCallouts{
        //mutualFundInsertQueueable=>mutualFundInsertQueueable=>mutualFundController

    global void execute(QueueableContext Qc)
    {
                mutualFundController.mutualFundOverNightInserter();

    }

}