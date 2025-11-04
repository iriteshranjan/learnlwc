import { LightningElement,track } from 'lwc';

export default class TrainRealTime extends LightningElement {
@track trains='';
@track error;
trainNumorStn='';
@track test='';
apiUrl='';
selectedTrainId = ''
trainSelected=false;
trainDataApiUrl='';
//selectedDate='';
trainSelectedTest='';
@track selectedValue = '';
    @track selectedDate = '';
    @track dateOptions = [];
    dateIndex=1
    apiUrl2='';
    trainFullId='';
    valueNumber='';




    connectedCallback()
    {
        const today =new Date();
        const yesterday = new Date(today);
        const dayBefore = new Date(today);
        yesterday.setDate(today.getDate() - 1);
        dayBefore.setDate(today.getDate() - 2);
            const format = (d) => d.toISOString().split('T')[0];

        this.dateOptions = [
            { label: `Today (${format(today)})`, value: '1' },
            { label: `Yesterday (${format(yesterday)})`, value: '2' },
            { label: `Day Before Yesterday (${format(dayBefore)})`, value:'3' }
        ];
    }
     handleChange(event) {
        this.selectedValue = event.detail.value;
        this.selectedDate = this.selectedValue;
        this.apiUrl2=`https://livestatus.railyatri.in/api/v3/train_eta_data/${this.trainFullId}/0.json?start_day=${this.selectedDate}` 


    }
    


     async handleSelect(event) {
        const trainId = event.currentTarget.dataset.id;
        this.trainFullId=trainId;
        const trainName=event.currentTarget.dataset.name;
        this.trainSelected=true;
        this.selectedTrainId=trainName
        this.start=event.currentTarget.dataset.src_stn_name
        this.end=event.currentTarget.dataset.dstn_stn_name
        console.log('Selected Train ID:', trainId);
        this.test=[]
        
       // if(this.trainSelected)
        {
             //this.trainSelectedTest=this.selectedValue 

             //this.apiUrl2=`https://livestatus.railyatri.in/api/v3/train_eta_data/${trainId}/0.json?start_day=${this.selectedDate}` 
             //const realResponse= await fetch(this.apiUrl2,{method:'GET'}) ;
            // const responseData=await realResponse.json();
             this.trainSelectedTest= apiUrl2;
        }
        

        // Call your next API using trainId
       
    }

    async trainHandler(event)
  {
    this.trainNumorStn=event.target.value;
    this.trains = null;
        this.error = null;
        try {
            this.apiUrl=`https://search.railyatri.in/v2/mobile/trainsearch.json?q=${this.trainNumorStn}`;
            this.trainSelected=false;
            const response=await fetch(this.apiUrl,{ method: 'GET' });
            const data = await response.json();
            console.log('Making callout to:', this.apiUrl);
             console.log('Making response to:', response);
             this.test = data.trains.map(item => ({
                       id: item.train_number,
                     name: `${item.train_number} - ${item.train_name}`,
                     src_stn_name:item.src_stn_name,
                     dstn_stn_name:item.dstn_stn_name
            }));

              //this.test = JSON.stringify(trains, null, 2);
        }
        catch
        {

        }
  }
  



}