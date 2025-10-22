public class IndexSyncWrapper {
    
    public string lastUpdatedDate;
    public stockList list_x;
    
    public class stockList
    {
        public list<Indice> indices;
    }
    public class Indice
    {
        public string stkexchg;
        public string exchangeSymbol;
        public decimal sectorId;
        public decimal change;
        public decimal percentchange;
        public decimal lastprice;
        public string id_x;
        public string lastupdated;
    }
    

}