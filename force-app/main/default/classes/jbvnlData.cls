public with sharing class JbvnlData {
    public String data;
    public String message;
    public Integer status;
    public List<DataItem> dataItems;

    public class DataItem {
        public String lpDate;
        public Decimal kWImp;
        public Decimal kVaImp;
        public Decimal kWExp;
        public Decimal kVaExp;
    }

    // After deserialization, call this to fix the data
    public void parseData() {
        if (String.isNotBlank(data)) {
            dataItems = (List<DataItem>) JSON.deserialize(data, List<DataItem>.class);
        } else {
            dataItems = new List<DataItem>();
        }
    }
} 