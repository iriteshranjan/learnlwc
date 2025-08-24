import { LightningElement,wire } from 'lwc';
import SAMPLEMC from "@salesforce/messageChannel/SampleMessageChannel__c";
import {MessageContext,subscribe,unsubscribe,APPLICATION_SCOPE} from 'lightning/messageService';

export default class LmsComponentX extends LightningElement {

    @wire(MessageContext) context
    messagetest
    subscription
    
   connectedCallback()
   {
    this.subscribeMessage()
   }

    subscribeMessage()
    {
         this.subscription=subscribe(this.context,SAMPLEMC,(message)=>{this.handleMessage(message)},{scope:APPLICATION_SCOPE})
    }   
    
    handleMessage(message)
    {
        this.messagetest=message.lmsdata.value ?  message.lmsdata.value:'NO MEssage Published';

    }

    unsubscribeMessage()
    {
         unsubscribe(this.subscription)
         this.subscription=null
    }



}