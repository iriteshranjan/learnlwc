import { LightningElement,track } from 'lwc';

export default class TrainRealTime extends LightningElement {
@track trains='';
@track error;
trainNumorStn='';
@track test='';
apiUrl='';
selectedTrainId = ''


      handleSelect(event) {
        const trainId = event.currentTarget.dataset.id;
        const trainName=event.currentTarget.dataset.name;
        this.selectedTrainId=trainName
        this.start=event.currentTarget.dataset.src_stn_name
        this.end=event.currentTarget.dataset.dstn_stn_name
        console.log('Selected Train ID:', trainId);
        this.test=[]
        

        // Call your next API using trainId
       
    }

    async trainHandler(event)
  {
    this.trainNumorStn=event.target.value;
    this.trains = null;
        this.error = null;
        try {
            this.apiUrl=`https://search.railyatri.in/v2/mobile/trainsearch.json?q=${this.trainNumorStn}`;
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