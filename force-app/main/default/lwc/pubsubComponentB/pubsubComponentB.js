import { LightningElement } from 'lwc';
import pubsub from 'c/pubsub';


export default class PubsubComponentB extends LightningElement {
    message='test'
    connectedCallback()
    {
        this.callSubsciber()
    }
    callSubsciber()
    {
        pubsub.subscribe('componentA',(messages)=>{
            this.message=messages;
        })
    }

}