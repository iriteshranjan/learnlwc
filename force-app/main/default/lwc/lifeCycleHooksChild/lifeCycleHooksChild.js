import { LightningElement,api } from 'lwc';

export default class LifeCycleHooks extends LightningElement {


    //constructor--> connected callback-->if child then goes to child and if not then come back
    //as trigger rendered callback and ends 
    constructor()
    {
        super()
        console.log("I am chilc constructor");
    }
    connectedCallback()
    {
        console.log("I am child connectedCallback");
        throw new Error ('Loading of child component Failed');
    }

    renderedCallback()
    {
        console.log("I am child renderedCallback");
    }
    disconnectedCallback()
    {
       alert('Child is removed');
    }
}