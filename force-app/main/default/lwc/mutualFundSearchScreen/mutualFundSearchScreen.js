import { LightningElement,track, wire } from 'lwc';
import mutualFundSearch from '@salesforce/apex/mutualFundLwc.selectmutualFund';

export default class MutualFundSearchScreen extends LightningElement {
    @track mutualfundsData
    searchValue='';
    allFunds=[]
 
    searchHandler(event)
    {
        this.searchValue=event.target.value;
        if(this.searchValue && this.searchValue.length>2)
        {
           mutualFundSearch({fundName:this.searchValue}).then(
            result=>{
                this.allFunds=result && result.length>0 ?
                result:[{Id:'null',direct_scheme_name__c:'No Results found'}];
            }
           );
                
             if(this.searchValue.length<2)
             {
                this.allFunds=[]
             }
        }
        
       

   }
}