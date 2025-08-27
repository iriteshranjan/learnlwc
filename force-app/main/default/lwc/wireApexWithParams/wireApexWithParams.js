import { LightningElement,wire,track } from 'lwc';
import filterAccountByType from '@salesforce/apex/AccountController.filterAccountByType'

export default class WireApexWithParams extends LightningElement {
    selectedType
    @track accounts
    input
    @wire(filterAccountByType,{type:'$selectedType'})
            filteredAcccounts({data,error})
            {
                if(data)
                {
                     this.accounts=data.map(item=>{
                        return {...item,Name:item.Name+'Ritesh'}
                    })
                }
            }



           // inputHandler(event)
           // {
               // this.input=event.target.value
           // }
            buttonHandler(event)
            {
                        console.log('Currently selected type:', this.selectedType);

            }

            get typeOptions()
            {
                return [
                   {label:"Analyst", value:"Analyst"},
                   {label:"Agriculture",value:"Agriculture"}
                ]
            }

            typeHandler(event)
            {
                this.selectedType=event.target.value
            }

            
}