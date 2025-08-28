import { LightningElement,wire } from 'lwc';
import practiceApexCode from '@salesforce/apex/practiceApex.practiceApexCode'

export default class ApexImperetiveDemo extends LightningElement {
    accounts
    accountIm
    @wire(practiceApexCode ) 
    practice({data,error})
    {
        if(data)
        {
            this.accounts=data.map(item=>{
                return{
                    accountName:item.Name,
                    contacts:item.Contacts?item.Contacts.map(con=>{
                            return{
                                contactName:con.Name
                            }
                    }):[]
                }

            })
        }
        if(error)
        {
            console.log('Some error occured')
        }
    }


    imHandler(event)
    {
       practiceApexCode().then(data=> {
        this.accountIm=data.map(item=> {
            return {
                accountName : item.Name,
                contacts : item.Contacts ? item.Contacts.map(con => {
                    return{
                    contactName:con.Name
                    }
                }):[]
            };
        });
       })
       .catch(error => {
        console.log('Some error occured');
       })


}
}