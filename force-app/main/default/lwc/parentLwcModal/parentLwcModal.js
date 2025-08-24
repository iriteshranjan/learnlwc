import { LightningElement } from 'lwc';
import pubsub from './pubsub'

export default class ParentLwcModal extends LightningElement {
    flag=false;
    msg
    formHandler(event)
    {
        this.flag=true
    }

    cancelHandler(event)
    {
        this.msg=event.detail.msg
        this.flag=event.detail.flag
    }
    saveHandler(event)
    {
        this.msg=event.detail.msg
        this.flag=event.detail.flag
        
    }



}