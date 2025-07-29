import { LightningElement,track } from 'lwc';

export default class HelloWorld extends LightningElement {

fullName="Ritesh kumar"
title="Swarm Lead"
num1=20
num2=30
check=false;


@track adress={
    city:'Ranchi',
    location:'tatisilwai'
}
withoutTrackAddress={
    city:'Ranchi',
    location:'tatisilwai'
}

getName(event)
{
this.title=event.target.value;
}

trackHandler(event)
{
    this.adress.city=event.target.value;
}
withoutTrackAddressHandler(event)
{
    this.withoutTrackAddress={...this.withoutTrackAddress,"city":event.target.value}
    console.log(this.withoutTrackAddress.city)
}

//getters
userName=["Ritesh","kiran","Binni"];
get getNames()
    {
        return this.userName[0];
    }
    get sum()
    {
        return this.num1+this.num2
    }
    conditionHandler(event)
    {
       if( this.check===false)
       {
        this.check=true
       }
       else
        this.check=false
    
        
    }
    num3=[0,1,2,3,4,5,6,7,8]

    num33=[
        {
            id:0,
            values:0
        },
        {
            id:1,
            values:1
        },
        {
            id:2,
            values:2
        },
        {
            id:3,
            values:3
        }
    ]

}