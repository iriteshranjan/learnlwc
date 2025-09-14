import { LightningElement,wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import NAME_FIELD from '@salesforce/schema/Account.Name';
import DESCRIPTION_FIELD from '@salesforce/schema/Account.Description';

const fields=[NAME_FIELD,DESCRIPTION_FIELD]

export default class PracticeUiApiRecord extends LightningElement {
    accountDetail
    @wire(getRecord, {recordId:'001IS00000B271BYAR',fields})
    accountData({data,error})
    {
        if(data)
        {
            this.accountDetail=data.fields
            console.log('Accounts=>',this.accountDetail)
        }
        if(error)
        {
            alert('Some error occured');
        }
    }

}