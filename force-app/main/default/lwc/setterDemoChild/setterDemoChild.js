import { LightningElement ,api} from 'lwc';

export default class SetterDemoChild extends LightningElement {
    userDetail
    @api 
    get detail()
    {
        return this.userDetail
    }

    set detail(data)
    {
        this.userDetail=data
        this.userDetail={...data,city:'Ranchi',age:data.age*2+2}
    }
}