import { LightningElement } from 'lwc';

export default class DuplicateQuiz extends LightningElement {
selected={};
answerkeys={};
sum=0;
correctanswers=0
 check=false
    questions=[
        {
            Question:"What is HTML",
            id:"Question 1",
            Option:{
                a:"HTML",
                b:"TEXT",
                c:"WORD"
            },
            correct:"a"
        },
        {
            Question:"What is TEXT",
            id:"Question 2",
            Option:{
                a:"HTML",
                b:"TEXT",
                c:"WORD"
            },
            correct:"b"
        },
        {
            Question:"What is WORD",
            id:"Question 3",
            Option:{
                a:"HTML",
                b:"TEXT",
                c:"WORD"
            },
            correct:"c"
        },
        {
            Question:"What is Ritesh",
            id:"Question 4",
            Option:{
                a:"Ritesh",
                b:"TEXT",
                c:"WORD"
            },
            correct:"a"
        },
    ]

    changeHandler(event)
    {
        console.log("name=>"+event.target.name)
        console.log("value=>"+event.target.value)
        this.selected={...this.selected,[event.target.name]:event.target.value}
        console.log("logging selected=>",JSON.stringify(this.selected));
    }
    submitHandler(event)
    {
        event.preventDefault();
        this.looponanswers();
        for(let i=0;i<this.questions.length;i++)
        {
            
           let qid=this.questions[i].id;
           if(this.selected[qid]===this.answerkeys[qid])
            {
                this.sum++;
            }
            this.check=true
           
    }
    this.correctanswers=this.sum
    this.sum=0
        }


    looponanswers()
    {
        for(let i=0;i<this.questions.length;i++)
        {
            let qid=this.questions[i].id;
            this.answerkeys={...this.answerkeys,[qid]:this.questions[i].correct}

        }
    }
    
    resetHandler(event){
                this.sum=0;
                this.correctanswers=0;
                //this.selected={}
                this.answerkeys={}
                this.check=false

    }

}