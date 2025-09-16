import { LightningElement, track } from 'lwc';
import LightningModal from 'lightning/modal';
import ipoOpen from '@salesforce/apex/IpoAll.ipoOpen';
import ipoClosed from '@salesforce/apex/IpoAll.ipoClosed';
import ipoUpcoming from '@salesforce/apex/IpoAll.ipoUpcoming';

export default class IpoUi extends LightningModal {
    @track ipoData = [];
    @track isLoading = false;

    // Convert UNIX timestamp to readable IST
    convertUnixToIST(timestamp) {
        if (!timestamp) return '';
        // Convert to milliseconds if API returns seconds
        let date = new Date(timestamp.toString().length === 10 ? timestamp * 1000 : timestamp);
        return date.toLocaleString('en-IN', { timeZone: 'Asia/Kolkata' });
    }

    loadOpenIpos() {
        this.isLoading = true;
        ipoOpen()
            .then(res => {
                let data = JSON.parse(res).ipoList || [];
                // convert timestamps for open IPOs
                data = data.map(item => ({
                    ...item,
                    bidStartTimestamp: this.convertUnixToIST(item.bidStartTimestamp),
                    bidEndTimestamp: this.convertUnixToIST(item.bidEndTimestamp)
                }));
                this.ipoData = data;
            })
            .catch(err => console.error(err))
            .finally(() => (this.isLoading = false));
    }

    loadClosedIpos() {
        this.isLoading = true;
        ipoClosed()
            .then(res => {
                let data = JSON.parse(res).ipoList || [];
                data = data.map(item => ({
                    ...item,
                    bidStartTimestamp: this.convertUnixToIST(item.listingTimestamp)
                    //closingDate: this.convertUnixToIST(item.closingDate)
                }));
                this.ipoData = data;
            })
            .catch(err => console.error(err))
            .finally(() => (this.isLoading = false));
    }

  loadUpcomingIpos() {
    this.isLoading = true;
    ipoUpcoming()
        .then(res => {
            let data = JSON.parse(res).ipoList || [];
            data = data.map(item => ({
                ...item,
                bidStartTimestamp: this.convertUnixToIST(item.bidStartTimestamp)
               // closingDate: item.closingDate ? this.convertUnixToIST(item.closingDate) : null
            }));
            this.ipoData = data;
        })
        .catch(err => console.error('Error loading upcoming IPOs:', err))
        .finally(() => (this.isLoading = false));
}

    handleClose() {
        this.close();
    }
}
