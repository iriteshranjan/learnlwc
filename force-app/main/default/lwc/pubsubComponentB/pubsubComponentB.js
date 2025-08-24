import { LightningElement } from 'lwc';
import pubsub from 'c/pubsub';


export default class PubsubComponentB extends LightningElement {
    message='test'
     saveorcancel='test'
    connectedCallback()
    {
        this.callSubsciber()
    }
    callSubsciber()
    {
        pubsub.subscribe('componentA',(messages)=>{
            this.message=messages;
        })
        pubsub.subscribe('save',(messages)=>{
            this.saveorcancel=messages;
        })
        pubsub.subscribe('cancel',(messages)=>{
            this.saveorcancel=messages;
        })
    }

}