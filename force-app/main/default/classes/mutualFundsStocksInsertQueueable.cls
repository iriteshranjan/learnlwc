global class mutualFundsStocksInsertQueueable implements Queueable, Database.allowsCallouts{
    
    private List<mutualFundStocks__c> stockList;
    
    global mutualFundsStocksInsertQueueable(List<mutualFundStocks__c> stockLists)
    {
        this.stockList=stockLists;
    }
    
   global void execute(QueueableContext qc)
   {
       insert stockList;
       
   }

}