import { LightningElement } from 'lwc';
import pubsub from 'c/pubsub'

export default class ChildLwcModal extends LightningElement {
    name=''
    number
    notes
    nameHandler(event)
    {
       this.name=event.target.value 
    }
     numberHandler(event)
    {
       this.number=event.target.value 
    }
    cancelHandler()
    {
        this.notes='cancel'
        const cancelEvent=new CustomEvent('cancel',{
            detail:
            {
                msg:this.notes,
                flag:false

            }
        }
        )
        pubsub.publish('cancel',this.notes)
        this.dispatchEvent(cancelEvent)
    }
    saveHandler()
    {
       const SaveEvent= new CustomEvent('save',{
        detail:
        {
            msg:'Saved successfully',
            flag:false
        }
       }) 
                pubsub.publish('save','Saved Successfully')   
               this.dispatchEvent(SaveEvent)

    }
}