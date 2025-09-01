import { LightningElement,track } from 'lwc';
import findAccounts from '@salesforce/apex/AccountController.findAccounts';

export default class ApexImperetiveWithParamsDemo extends LightningElement {
    key
    @track account=[];

// inputHandler(event)
// {
// this.key=event.target.value
// }
inputHandler(event)
{   this.key=event.target.value
     findAccounts({searchkey:this.key}).then(data=>{
        this.account=data && data.length> 0 ? data.map(item => {
            return {accountName: item.Name};
            47491597
            
        }):[{accountName: 'No Account Found'}];
     }).catch(error=>{
        [{accountName: 'No Account Found'}];
     })
    
}



}