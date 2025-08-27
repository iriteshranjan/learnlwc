import { LightningElement,wire } from 'lwc';
import practiceApexCode from '@salesforce/apex/practiceApex.practiceApexCode'

export default class PracticeApexLwc extends LightningElement {
 contacts
 accounts


@wire(practiceApexCode)
    practiceApex({data,error})
    {
        if(data)
        {
           this.accounts=data.map(acc=>{
            return {
                accountId:acc.id,
                accountName:acc.Name,
                contacts: acc.Contacts ? acc.Contacts.map(con=>{
                    return {
                        contactId:con.Id,
                        contactName:con.Name
                    }
                }) : []

            }
           })
           
        }
        if(error)
        {
            console.log('error occured')
        }
    }
}