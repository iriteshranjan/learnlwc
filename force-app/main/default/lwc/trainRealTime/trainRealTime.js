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
            this.apiUrl=`https://search.railyatri.in/mobile/trainsearch?q=${this.trainNumorStn}`;
            const response=await fetch(this.apiUrl,{ method: 'GET' });
            const data = await response.json();
            console.log('Making callout to:', this.apiUrl);
             console.log('Making response to:', response);
             this.test = data.map(item => ({
                id: item[0],
                name: `${item[0]} - ${item[1]}`
            }));

              //this.test = JSON.stringify(trains, null, 2);
        }
        catch
        {

        }
  }



}