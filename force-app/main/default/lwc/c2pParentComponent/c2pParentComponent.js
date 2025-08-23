import { LightningElement } from 'lwc';

export default class C2pParentComponent extends LightningElement {

    showModal=false;
    msg='parent'

    clickHandler(event)
    {
        this.showModal=true;
    }
    closeParentHandler(event)
    {
         this.msg=event.detail.msg
         this.testmsg=event.detail.testmsg
        this.showModal=false
    }


}