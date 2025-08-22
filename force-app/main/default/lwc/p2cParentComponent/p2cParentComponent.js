import { LightningElement } from 'lwc';

export default class P2cParentComponent extends LightningElement {
    childmessage
    carouselData
    flags=false;
    childHandler(event)
    {
            this.childmessage=event.target.value
    }
    flagHandler(event)
    {
        this.flags=!this.flags
    }
    get allData()
    {
        return this.flags;
        
    }
    carouselData=[
        {
            src :"https://v1.lightningdesignsystem.com/assets/images/carousel/carousel-01.jpg",
             header :"First Card",
            description : "First card description."
        }, 
        {
            src :"https://v1.lightningdesignsystem.com/assets/images/carousel/carousel-02.jpg",
             header :"Second Card",
            description : "Second card description."
        }, 
        {
            src :"https://v1.lightningdesignsystem.com/assets/images/carousel/carousel-03.jpg",
             header :"Third Card",
            description : "Third card description."
        }
    ]

    progress
progressHandler(event)
{
this.progress=event.target.value
}

}


