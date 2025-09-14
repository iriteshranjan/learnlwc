import { LightningElement ,wire} from 'lwc';
import Id from '@salesforce/user/Id'
import {getRecord} from 'lightning/uiRecordApi';
import NAME_FIELD from '@salesforce/schema/User.Name';
import EMAIL_FIELD from '@salesforce/schema/User.Email';
const fields=[NAME_FIELD,EMAIL_FIELD]
export default class WireDemoUserDetail extends LightningElement { 
userId=Id
//005IS000000XekdYAC
//@wire(adapter,{adapterConfig})
//propertyfunction

userDetail
@wire(getRecord, { recordId: '$userId', fields})
userDetailHandler({data,error})
{
        console.log('response => ' + JSON.stringify(data));
        if(data)
        {
            //let data=data
            this.userDetail=data.fields
            console.log('response => ' + this.userDetail);

        }
        if(error)
        {
            //let error=error
        }
}


}


