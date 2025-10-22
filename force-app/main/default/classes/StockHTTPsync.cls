public class StockHTTPsync {
    @Future(callout=true)
    public static void doCallout() {
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api-en.cnbctv18.com/nodeapi/v1/markets/other-indices?type=all');
        req.setMethod('GET');

        HttpResponse resp = h.send(req);
		List<Indexes__c > index=new List<Indexes__c>();
        List<Indexes__c > toUpdate=new List<Indexes__c>();
        List<Indexes__c> indexValues=[SELECT Id, stkexchg__c, exchangeSymbol__c, id__c, lastupdated__c, sectorId__c, percentchange__c, change__c, lastprice__c, Name FROM Indexes__c];
        Map<String, String> checkName=new Map<String,String>();
         Map<String, Indexes__c> checkNameMap=new Map<String,Indexes__c>();
        for(Indexes__c ind:indexValues)
        {
            checkName.put(ind.name,ind.id);
            checkNameMap.put(ind.name,ind);
        }
        
        
        Map<String,Indexes__c> stockMap=new Map<String,Indexes__c>();
        if (resp.getStatusCode() == 200) {
            String updatedJson = resp.getBody()
                .replace('"list":', '"list_x":');
             updatedJson = updatedJson
                .replace('"id":', '"id_x":');
            
            IndexSyncWrapper result = (IndexSyncWrapper) JSON.deserialize(updatedJson, IndexSyncWrapper.class);
            for(IndexSyncWrapper.Indice stock:result.list_x.indices)
            {
                if(checkName.containsKey(stock.stkexchg))
                {
                    Indexes__c old=checkNameMap.get(stock.stkexchg);
              
                        old.change__c=stock.change;
                old.exchangeSymbol__c=stock.exchangeSymbol;
               old.id__c=stock.id_x;
                old.lastprice__c=stock.lastprice;
               old.lastupdated__c=stock.lastupdated;
               old.percentchange__c=stock.percentchange;
                old.sectorId__c=stock.sectorId;
                old.stkexchg__c=stock.stkexchg;
                    toUpdate.add(old);
                }
                else
                {
                    
                    StockMap.put(stock.stkexchg,new Indexes__C(name=stock.stkexchg,change__c=stock.change,
                exchangeSymbol__c=stock.exchangeSymbol,
               id__c=stock.id_x,
                lastprice__c=stock.lastprice,
               lastupdated__c=stock.lastupdated,
               percentchange__c=stock.percentchange,
                sectorId__c=stock.sectorId,
                stkexchg__c=stock.stkexchg));
                }
               
            }
             index.addall(StockMap.values());
            if(index.size()>0)
            {
           
            Database.insert(index, false);
            }
              if(toUpdate.size()>0)
              {
                   Database.update(toUpdate, false);
              }
            
            
        }
    }
}