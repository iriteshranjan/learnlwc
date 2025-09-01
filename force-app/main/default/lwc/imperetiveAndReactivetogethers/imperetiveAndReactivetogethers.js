import { LightningElement,wire } from 'lwc';
import imperetiveAndReactivetogether from '@salesforce/apex/imperetiveAndReactivetogether.imperetiveAndReactivetogetherss';

export default class ImperetiveAndReactivetogethers extends LightningElement {
    updateString=[];
    updateData=[];
    @wire(imperetiveAndReactivetogether)
    value({data,error})
    {
        if(data)
        {
            console.log('Wire Data => ', data);
            this.updateString=data.map(item=>{
                return { ...item,
                    newValue:item.Name+'Ritesh'
                   
                };
            });
        }
        else if(error)
        {
            console.log('Some Error Occured');
        }
    }

    // Now doing the same with Imperetive
    imperetiveController()
    {
       imperetiveAndReactivetogether().then(result=>{
        console.log('imperetiveController Data => ', result);
        this.updateData=result.map(item=>{
            return {
                ...item, newValue:item.Name+'Ritesh'
            }
        })
       }).catch(error)
       {
        console.log('Some error occured');
       }
    }


}