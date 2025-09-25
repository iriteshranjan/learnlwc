public with sharing class dividendController {

  public static void dividendControllerJson()
  {
   
   List<Dividend__c> getAll=[select id,name,stockName__c ,exDate__c,announcementDate__c from dividend__c ];
map<String,Date> stock=new map<String,Date>();
List<Dividend__c> div=new list<Dividend__c>();
for(Dividend__c divv:getAll)
{
    stock.put(divv.stockName__c.trim(),divv.announcementDate__c);
    system.debug('map=>'+divv.stockName__c);
}

for(integer i=1;i<=20;i++)
{
Http http=new Http();
        HttpRequest request=new HttpRequest();
        request.setEndpoint('https://api.moneycontrol.com/mcapi/v1/ecalendar/corporate-action?indexId=All&event=D&apiVersion=161&orderBy=asc&deviceType=W&duration=UP&page='+i);
        request.setMethod('GET');
        HttpResponse response=http.send(request);
        String sss=response.getBody();
		system.debug('test'+sss);
		String jsonString = sss.replace('"list":', '"list_x":');
		dividendWrapper wrapper=(dividendWrapper) JSON.deserialize(jsonString,dividendWrapper.class);
		System.debug('test=>'+wrapper); 
		
		for(dividendWrapper.Stock ss:wrapper.data.list_x)
        {
            if(!stock.containsKey(ss.stockName.trim()) )
            {
                   system.debug('Count=>'+i);

               system.debug('Ritesh=>'+ss.stockName);
                if(ss.perChange.equals('-')){
                  ss.perChange='0';  
                }
                 if(ss.dividend.equals('-')){
                  ss.dividend='0';  
                }
          div.add(new Dividend__c(
            stockName__c=ss.stockName.trim(),
              name=ss.stockName.trim(),
            eventType__c=ss.eventType,
            dividend__c=Decimal.valueOf(ss.dividend),
            ratio__c=ss.ratio,
            lastValue__c=Decimal.valueOf(ss.lastValue.replaceAll(',', '')),
             perChange__c=Decimal.valueOf(ss.perChange),
             scDid__c=ss.scDid,
             ex__c=ss.ex,
             marketCap__c=ss.marketCap,
             url__c=ss.url,
             scId__c=ss.scId,
              exDate__c=Date.parse(ss.exDate),
              announcementDate__c=Date.parse(ss.announcementDate)
          ));
            }
        }
}
insert div;

		
        




  }

    @AuraEnabled(cacheable=true)
  public static List<Dividend__c>dividendLwcController()
  {
      return [select Id,Name,stockName__c,dividend__c,exDate__c,lastValue__c,announcementDate__c from Dividend__c where exDate__c>=Today  order by exDate__c  ];
  }

    
}