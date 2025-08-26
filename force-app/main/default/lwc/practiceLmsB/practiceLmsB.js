import { LightningElement,wire,track } from 'lwc';
import PRACTICEMC from '@salesforce/messageChannel/LmsPractice__c';
import { APPLICATION_SCOPE,subscribe,MessageContext } from 'lightning/messageService';


export default class PracticeLmsB extends LightningElement {
   @wire(MessageContext) context
    receivedMessage
    outputMessage
    connectedCallback()
    {
        this.subscribeMessage();
    }

    subscribeMessage()
   {
        this.receivedMessage=subscribe(this.context,PRACTICEMC,(message)=>{this.handleMessage(message)},{scope:APPLICATION_SCOPE});
        

    }
   handleMessage(message) {
    const val = message.lmsdata.value;
     this.outputMessage = val.name;
    this.outputMessage2=val.test;
}

}