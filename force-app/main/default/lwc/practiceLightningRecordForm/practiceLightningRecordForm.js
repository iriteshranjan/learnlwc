import { LightningElement,api } from 'lwc';
import ACCOUNT_OBJECT from '@salesforce/schema/Account';
import NAME_FIELD from '@salesforce/schema/Account.Name'

export default class PracticeLightningRecordForm extends LightningElement {
    @api objectApiName=ACCOUNT_OBJECT
    @api fields=[NAME_FIELD]


}