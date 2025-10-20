global class mutualFundInsertQueueable implements Queueable, Database.allowsCallouts{
    
    global void execute(QueueableContext Qc)
    {
                mutualFundController.mutualFundOverNightInserter();

    }

}