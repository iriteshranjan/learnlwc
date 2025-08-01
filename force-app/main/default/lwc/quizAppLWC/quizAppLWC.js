import { LightningElement } from 'lwc';

export default class QuizAppLWC extends LightningElement {
    isSubmitted=false
    selected={}
    correctAnswers=0
    myQuestions=[
                {
                    id:'Question1',
                    question:'Which one is a city',
                    answers:{
                            a:'Ranchi',
                            b:'Tatisilwai',
                            c:'Namkum'

                    },
                    correctAnswer:'a'
                },{
                    id:'Question2',
                    question:'Which one is a game',
                    answers:{
                            a:'dfg',
                            b:'cricket',
                            c:'def'

                            
                    },
                    correctAnswer:'b'
                },{
                    id:'Question3',
                    question:'Which one is a noise',
                    answers:{
                            a:'ddddd',
                            b:'nono',
                            c:'noise'

                    },
                    correctAnswer:'c'
                }
            ]
            changeHandler(event)
            {
                console.log("name",event.target.name)
                console.log("value",event.target.value)
               const name=event.target.name
               const value=event.target.value;
               //const {name,value}=event.target
               this.selected={...this.selected,[name]:value}
            }
            submitHandler(event)
            {
                console.log("test=>",this.isSubmitted);
                event.preventDefault()
               let correct= this.myQuestions.filter(item=>this.selected[item.id] === item.correctAnswer)
                this.correctAnswers=correct.length;
               this.isSubmitted=true
                console.log("this.correctAnswers=>",this.correctAnswers)
                console.log("test=>",this.isSubmitted);
                

            }
            resetHandler(event)
            {
                    this.selected={}
                    this.correctAnswers=0
            }
            get allNotSelected()
            {
                return !(Object.keys(this.selected).length===this.myQuestions.length)
            }
}