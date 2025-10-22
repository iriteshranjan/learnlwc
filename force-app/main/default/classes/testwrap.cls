public class testwrap {
    
    public class FormattedQuoteResultWrapper{
        public DataWrapper FormattedQuoteResult;
        
    }
    public class DataWrapper {
        public list<FormattedQuoteResult> FormattedQuote;
        
        
    }
    public class FormattedQuoteResult {
    public String symbol;
    public String symbolType;
    public Integer code;
    public String name;
    public String shortName;
    public String onAirName;
    public String altName;
    public String last;
    public String last_timedate;
    public String last_time;
    public String changetype;
    public String type;
    public String subType;
    public String exchange;
    public String source;
    public String open;
    public String high;
    public String low;
    public String change;
    public String change_pct;
    public String currencyCode;
    public String volume;
    public String volume_alt;
    public String provider;
    public String previous_day_closing;
    public String altSymbol;
    public String realTime;
    public String curmktstatus;
    public String pe;
    public String dividend;
    public String dividendyield;
    public String yrhiprice;
    public String yrhidate;
    public String yrloprice;
    public String yrlodate;
    public String eps;
    public String streamable;
    public String issue_id;
    public String issuer_id;
    public String countryCode;
    public String timeZone;
    public String feedSymbol;
    public String portfolioindicator;
}
     public static void test()
     {
         List<FormattedQuoteResult> result=new List<FormattedQuoteResult>();
         HttpRequest req = new HttpRequest();
req.setEndpoint('https://quote.cnbc.com/quote-html-webservice/restQuote/symbolType/symbol?symbols=INFY-IN');
req.setMethod('GET');

// Set headers as per your curl command
req.setHeader('sec-ch-ua-platform', '"macOS"');
req.setHeader('Referer', 'https://www.cnbc.com/quotes/INFY-IN');
req.setHeader('User-Agent', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36');
req.setHeader('sec-ch-ua', '"Not)A;Brand";v="8", "Chromium";v="138", "Google Chrome";v="138"');
req.setHeader('sec-ch-ua-mobile', '?0');

Http http = new Http();
HttpResponse res = http.send(req);

// Log the response body
System.debug(res.getBody());

         FormattedQuoteResultWrapper wrapper=(FormattedQuoteResultWrapper) JSON.deserialize(res.getBody(), FormattedQuoteResultWrapper.class);
         
         result.addall(wrapper.FormattedQuoteResult.FormattedQuote);
         System.debug(result);
     }
}