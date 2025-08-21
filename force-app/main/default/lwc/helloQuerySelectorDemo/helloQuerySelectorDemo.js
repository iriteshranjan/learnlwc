import { LightningElement } from 'lwc';

export default class HelloQuerySelectorDemo extends LightningElement {

    userNames=["a","b","c","d"];
    submitHandler(event)
    {


          //lwc:manual dom
        const childElement=this.template.querySelector('.child');
        childElement.innerHTML='<p> Hey I am child</p>'


       const elem= this.template.querySelector('h1');
       elem.style.border="1px solid red";
       console.log(elem)
       console.log(elem.innerText);


       const userElements=this.template.querySelectorAll('.name');
       Array.from(userElements).forEach(item=>{
        console.log(item.innerText)
        item.setAttribute("title",item.innerText)

        const childrenElement=this.template.querySelector('.children');
        childrenElement.innerHTML='<p style="color:red;">I am children</p>'

      
       })

    }
}