import { LightningElement,wire } from 'lwc';
import { getObjectInfo,getObjectInfos} from 'lightning/uiObjectInfoApi';
import ACCOUNT_OBJECT from '@salesforce/schema/Account'
import CONTACT_OBJECT from '@salesforce/schema/Contact'


export default class GetObjectInfoWire extends LightningElement {
    getDefaultRecordTypeId
    getObjectApi
    name
    objectApiNames=[ACCOUNT_OBJECT,CONTACT_OBJECT];
@wire(getObjectInfo, {objectApiName:ACCOUNT_OBJECT})
objectInfo({data,error})
{
    if(data)
    {
        console.log(data.defaultRecordTypeId);
        this.getDefaultRecordTypeId=data.defaultRecordTypeId
        this.name=data.apiName
    }
    if(error)
    {
        console.log(error)

    }
}


@wire(getObjectInfos ,{objectApiNames:'$objectApiNames'})
objectInfos({data,error})
{
    if(data)
    {
        console.log('objectApiNames=>',data)
        this.getObjectApi=data;

    }
}

}