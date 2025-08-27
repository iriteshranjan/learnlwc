import { LightningElement,wire } from 'lwc';
import getAccountList from '@salesforce/apex/AccountController.getAccountList'

export default class ApexWireDemo extends LightningElement {
            accountList
    @wire(getAccountList) accounts;


    @wire(getAccountList) 
    accountHandler({data,error})
        {
            
            if(data)
            {
                this.accountList=data.map(item=>{
                    let newType=item.Type === 'Analyst' ? 'Testing' : item.Type === 'Analysts' ? 'Testings' : '-----'
                    return {...item,newType}
                })

            }
            if(error)
            {
                console.log('Error occured');
            }

        }
    
   

        
       
}