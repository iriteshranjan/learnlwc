import { LightningElement } from 'lwc';

export default class LifeCycleHooks extends LightningElement {


    //constructor--> connected callback-->if child then goes to child and if not then come back
    //as trigger rendered callback and ends 
    constructor()
    {
        super()
        console.log("I am Parent constructor");
    }
    connectedCallback()
    {
 console.log("I am Parent connectedCallback");
    }

    renderedCallback()
    {
        console.log("I am Parent renderedCallback");
    }
}