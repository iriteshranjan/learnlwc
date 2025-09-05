public with sharing class jbvnlCalloutController {

    public static Date convertDateFormatToDate(String apiDate) {
    // Example: apiDate = "05-Aug-2025"
    if (String.isBlank(apiDate)) return null;

    List<String> parts = apiDate.split('-'); // [05, Aug, 2025]
    if (parts.size() != 3) return null;

    Integer day   = Integer.valueOf(parts[0]);
    String month  = parts[1];
    Integer year  = Integer.valueOf(parts[2]);

    Map<String, Integer> monthMap = new Map<String, Integer>{
        'Jan' => 1,'Feb' => 2,'Mar' => 3,'Apr' => 4,
        'May' => 5,'Jun' => 6,'Jul' => 7,'Aug' => 8,
        'Sep' => 9,'Oct' => 10,'Nov' => 11,'Dec' => 12
    };

    Integer monthNum = monthMap.containsKey(month) ? monthMap.get(month) : 1;

    return Date.newInstance(year, monthNum, day);
}

    
    public static  void calloutController()
    {
        //perform HTTP callout
        String body='U2FsdGVkX1/qUAiNx83r/bSjKcC+saSE2WPK8610IjRHvS7VGqaZ/TQAFckaOF1ojHv5d49vAUpiNqmQNCiiGfoiuQm9DW7UnD0LLxDnqCM3cSebjav5pkvBHd0FzeuxHUg7mDClUXBAqMZjRu8MqQ==';
        HTTPRequest req=new HTTPRequest();
        req.setEndpoint('https://cportal.jbvnl.co.in/fgweb/web/json/plugin/com.fluentgrid.cp.api.ConsumptionPatternData/service');
        req.setMethod('POST');
        req.setBody(body);
        req.setHeader('Content-Type','text/plain');
        HTTP http=new HTTP();
        HttpResponse res = http.send(req);
        if(res.getStatusCode()==200)
        {
            JbvnlData wrapper=(JbvnlData) JSON.deserialize(res.getBody(),JbvnlData.class);
            wrapper.parseData();
            System.debug(wrapper.dataItems);

            List<JBVNL__c> dat=new List<JBVNL__c>();
           
           List<String> existingDates=new list<String>();
           for(JBVNL__c existingD:[Select id,name from JBVNL__c])
           {
            existingDates.add(existingD.name);
           }

            for(JbvnlData.DataItem item:wrapper.dataItems)
            {
                JBVNL__c rec=new JBVNL__c();
                rec.kVaExp__c=item.kVaExp;
                rec.kVaImp__c=item.kVaImp;
                rec.kWExp__c=item.kWExp;
                rec.kWImp__c=item.kWImp;
                 rec.LpDate__c = convertDateFormatToDate(item.lpDate);
                rec.name=item.lpDate;
                if(!(existingDates.contains(item.lpDate)))
                {
                dat.add(rec);
                }
            }

            if(!dat.isEmpty())
            {
                insert dat;
            }
            else {
                System.debug('⚠️ No records found in response');
            }


    
        }
       else {
            System.debug('❌ Status: ' + res.getStatusCode() + ' - ' + res.getStatus());
            System.debug('Response body: ' + res.getBody());
        }


}
}