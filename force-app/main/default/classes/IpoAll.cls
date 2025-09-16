public with sharing class IpoAll {


        @auraEnabled(Cacheable=true)
        public static String ipoClosed()
        {
            String calloutClosed=perfromCallout('closed');
            return calloutClosed;
        }

         @auraEnabled(Cacheable=true)
         public static String ipoOpen()
        {
            String calloutClosed=perfromCallout('open');
            return calloutClosed;
            // return JSON.serialize(calloutClosed);


        }
         @auraEnabled(Cacheable=true)
         public static String ipoUpcoming()
        {
            String calloutClosed=perfromCallout('upcoming');
            return calloutClosed;
       }

        public static String perfromCallout(String calloutType)
        {
            try
            {
             Http h=new Http();
            HttpRequest req=new HttpRequest();
            req.setEndpoint('https://groww.in/v1/api/primaries/v1/ipo/'+calloutType);
            req.setMethod('GET');
            req.setTimeout(60000);
            HttpResponse res=h.send(req);
            System.debug('response=>'+res.getBody());
            if(res.getStatusCode()==200)
           return (res.getBody());
           else
           return '{"error":"Callout failed","statusCode":' + res.getStatusCode() + '}';

            }
            catch (Exception e)
            {
                System.debug('❌ Exception during IPO API callout: ' + e.getMessage());
            return '{"error":"Exception occurred: ' + String.escapeSingleQuotes(e.getMessage()) + '"}';
            }



        }

}