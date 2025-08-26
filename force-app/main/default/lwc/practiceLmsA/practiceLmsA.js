import { LightningElement,wire,track } from 'lwc';
import PRACTICEMC from '@salesforce/messageChannel/LmsPractice__c';
import {APPLICATION_SCOPE,publish,MessageContext} from 'lightning/messageService'

export default class PracticeLmsA extends LightningElement {
   @wire(MessageContext) context

    input
    inputTrackHandlerValue
   @track methodEntry=[]
    inputHandler(event)
    {
        this.input=event.target.value;
    }
    inputTrackHandler(event)
    {
        this.inputTrackHandlerValue=event.target.value
       this.methodEntry= [{
        name:"ritesh",
        test:this.inputTrackHandlerValue
    }]
    }
    lmsHandler(event)
    {
        const message={lmsdata:{
            value:{
                name:this.input,
                test:this.methodEntry[0].test
            }
        }
        }
        publish(this.context,PRACTICEMC,message)
    }


}