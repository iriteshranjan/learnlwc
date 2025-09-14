import { LightningElement,track,api } from 'lwc';

export default class IpoList extends LightningElement {
     
    @track open =[];
    @track closed =[]
    @track upcoming =[]

            connectedCallback()
                {
                    this.fetchOpen();
                    this.refreshInterval= setInterval(() => this.fetchOpen(), 10000);
                }

    
    async fetchOpen()
    {
        try {
            const response =await fetch('https://groww.in/v1/api/primaries/v1/ipo/closed');
            if(!response.ok)
            {
                throw new Error(`API Error: ${response.status}`);
            }
            const jsonResponse= await response.json();
            this.open=jsonResponse;
            console.log('Groww Response=>',jsonResponse);
        }
        catch 
        {
             console.error('❌ Error fetching IPOs:', error);
        }
    }


    
}