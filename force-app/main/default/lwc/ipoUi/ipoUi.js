import { LightningElement } from 'lwc';
import open from '@salesforce/apex/IpoAll.ipoOpen';
import closed from '@salesforce/apex/IpoAll.ipoClosed';
import upcoming from '@salesforce/apex/IpoAll.ipoUpcoming';


export default class IpoUi extends LightningElement {
    results=[];
    resultsClosed=[]

    openHandler(event)
    {
        open().then(result=>{
            const parsed = JSON.parse(result);
            console.log('data=>',parsed);
            this.results=parsed.ipoList.map(item=>{
                return {
                    symbol :item.symbol,
                    companyName: item.companyName,
                    logoUrl:item.logoUrl,
                    categories: item.categories.map(cat=>{
                        return {
                        category: cat.category
                        };
                    })
                };
            });
        })
    }
    closeHandler(event)
    {
            closed().then(result=> {
            const parsed = JSON.parse(result);
             console.log('data=>',parsed);
            this.resultsClosed = parsed.ipoList.map(item=> {
                return {
                companyName:item.companyName
                };

            });
            
        }).catch(error=>{
                    console.error('Error in closeHandler:', error);

        });
    }
    upcomingHandler(event)
    {
            upcoming().then(result=>{
            console.log('data=>',result);
        })
    }
    


}