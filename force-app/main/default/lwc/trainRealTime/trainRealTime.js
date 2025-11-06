import { LightningElement, track } from 'lwc';

export default class TrainRealTime extends LightningElement {

    @track trains = '';
    @track error;
    @track currentLocation = '';
@track currentTimeInfo = '';
@track nextStation = '';
@track nextStationEta = '';

    trainNumorStn = '';
    @track test = '';
    apiUrl = '';
    selectedTrainId = '';
    trainSelected = false;

    @track selectedValue = '';
    @track selectedDate = '';
    @track dateOptions = [];

    apiUrl2 = '';
    trainFullId = '';
    responseAPI = '';

    @track stationList = [];

    connectedCallback() {
        const today = new Date();
        const yesterday = new Date(today);
        const dayBefore = new Date(today);

        yesterday.setDate(today.getDate() - 1);
        dayBefore.setDate(today.getDate() - 2);

        const format = (d) => d.toISOString().split('T')[0];

        this.dateOptions = [
            { label: `Today (${format(today)})`, value: '1' },
            { label: `Yesterday (${format(yesterday)})`, value: '2' },
            { label: `Day Before Yesterday (${format(dayBefore)})`, value: '3' }
        ];
    }

    handleChange(event) {
        this.selectedValue = event.detail.value;
        this.selectedDate = this.selectedValue;
        this.apiUrl2 = `https://livestatus.railyatri.in/api/v3/train_eta_data/${this.trainFullId}/0.json?start_day=${this.selectedDate}`;
    }

    async latestHandler() {
        if (!this.apiUrl2) {
            this.error = "Please select a date before refreshing.";
            return;
        }

        try {
            const realResponse = await fetch(this.apiUrl2, { method: "GET" });
            const responseData = await realResponse.json();

            this.responseAPI = JSON.stringify(responseData, null, 2);

            this.processTrainData(responseData);

        } catch (error) {
            this.error = "Error fetching live data";
            console.error(error);
        }
    }

    processTrainData(data) {

            // ✅ CURRENT LOCATION
this.currentLocation = data.current_station_name 
    ? data.current_station_name.replace("'", "")
    : 'Not Available';

this.currentTimeInfo = data.bubble_message?.
 
    ? `Last updated ${data.bubble_message.station_time}`
    : '';

// ✅ NEXT STATION
if (data.next_stoppage_info?.next_stoppage) {
    this.nextStation = data.next_stoppage_info.next_stoppage;
    this.nextStationEta = 
        data.next_stoppage_info.next_stoppage_time_diff 
            ? `Arriving in ${data.next_stoppage_info.next_stoppage_time_diff}`
            : '';
} else {
    this.nextStation = '';
    this.nextStationEta = '';
}


        const prev = data.previous_stations || [];
        const upcoming = data.upcoming_stations || [];

        let finalList = [];

        // Previous stations
        prev.forEach((st, index) => {
            finalList.push({
                key: "p" + index,
                station_name: st.station_name,
                station_code: st.station_code,
                sta: st.sta || "-",
                eta: st.eta || "-",
                delay: st.arrival_delay || 0,
                statusClass: "completed",
                isCurrent: false
            });
        });

        // Current station
        finalList.push({
            key: "c",
            station_name: data.current_station_name,
            station_code: data.current_station_code,
            sta: data.cur_stn_sta || "-",
            eta: data.eta || "-",
            delay: data.delay || 0,
            statusClass: "current",
            isCurrent: true
        });

        // Upcoming stations
        upcoming.forEach((st, index) => {
            finalList.push({
                key: "u" + index,
                station_name: st.station_name,
                station_code: st.station_code,
                sta: st.sta || "-",
                eta: st.eta || "-",
                delay: 0,
                statusClass: "upcoming",
                isCurrent: false
            });
        });

        this.stationList = finalList;
    }

    async handleSelect(event) {

        const trainId = event.currentTarget.dataset.id;
        this.trainFullId = trainId;

        this.selectedTrainId = event.currentTarget.dataset.name;
        this.start = event.currentTarget.dataset.src_stn_name;
        this.end = event.currentTarget.dataset.dstn_stn_name;

        this.trainSelected = true;
        this.test = [];
    }

    async trainHandler(event) {
        this.trainNumorStn = event.target.value;
        this.trains = null;
        this.error = null;

        try {
            this.apiUrl = `https://search.railyatri.in/v2/mobile/trainsearch.json?q=${this.trainNumorStn}`;
            this.trainSelected = false;

            const response = await fetch(this.apiUrl, { method: 'GET' });
            const data = await response.json();

            this.test = data.trains.map(item => ({
                id: item.train_number,
                name: `${item.train_number} - ${item.train_name}`,
                src_stn_name: item.src_stn_name,
                dstn_stn_name: item.dstn_stn_name
            }));

        } catch (error) {
            this.error = "Failed to search trains";
        }
    }
}