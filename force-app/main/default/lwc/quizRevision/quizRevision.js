import { LightningElement,track } from 'lwc';

export default class QuizRevision extends LightningElement {


    myQuestions=[
        {
            id:'Question1',
            Question:'Who is Ritesh',
            options:{
                a:'Ritesh',
                b:'Ramesh',
                c:'Rajesh'
            }
        },
        {
            id:'Question2',
            Question:'Who is Ramesh',
            options:{
                a:'Ritesh',
                b:'Ramesh',
                c:'Rajesh'
            }
        }
    ]

    changeHandler(event){
        console.log(event.target.value);
    }




}