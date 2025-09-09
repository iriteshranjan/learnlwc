public with sharing class dividendWrapper {
    public String success;
    
    public Data data;

    public class Data{
        // @JsonName('list')
        public List<Stock> list_x;
            public String asOnDate;
        
    }
    public class Stock 
    {
            public String stockName;
            public String eventType;
            public String announcementDate;
            public String exDate;
            public String dividend;
            public String ratio;
            public String lastValue;
            public String perChange;
            public String scDid;
            public String scId;
            public String ex;
            public String marketCap;
            public String url;
            
    }
}