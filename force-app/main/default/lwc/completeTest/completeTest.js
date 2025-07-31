import { LightningElement,track } from 'lwc';

export default class CompleteTest extends LightningElement {
flag=false


@track testing=
{
            name:'ritesh',
            address:'kumar'
}
testController(event)
{
    this.testing.name=event.target.value;
}
testing1=
{
            name:'ritesh',
            address:'kumar'
}
testController1(event)
{
    this.testing1={...this.testing1,"name":event.target.value}
}
booleanController(event)
{
    this.flag=true
}
forloop=[
    {
        'name':'Ritesh',
        'title':'kumar'
    },
    {
        'name':'Kiran',
        'title':'Kumari'
    }
]


}