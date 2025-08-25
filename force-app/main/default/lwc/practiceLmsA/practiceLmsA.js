import { LightningElement,wire } from 'lwc';
import PRACTICEMC from '@salesforce/messageChannel/LmsPractice__c';
import {APPLICATION_SCOPE,publish,MessageContext} from 'lightning/messageService'

export default class PracticeLmsA extends LightningElement {
   @wire(MessageContext) context

    input
    inputHandler(event)
    {
        this.input=event.target.value;
    }
    lmsHandler(event)
    {
        const message={lmsdata:{
            value:this.input
        }
        }
        publish(this.context,PRACTICEMC,message)
    }


}