import { LightningElement, wire } from 'lwc';
import SAMPLEMC from "@salesforce/messageChannel/SampleMessageChannel__c";
import {publish,MessageContext} from 'lightning/messageService'


export default class LmsComponentA extends LightningElement {
    inputValue
    @wire(MessageContext) context
    inputHandler(event)
    {
        this.inputValue=event.target.value
    }
    publishMessage()
    {   
            const message={
                lmsdata:{
                    value:this.inputValue
                }
            }
            publish(this.context,SAMPLEMC,message)
    }
}