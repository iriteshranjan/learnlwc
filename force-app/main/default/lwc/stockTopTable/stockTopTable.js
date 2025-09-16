import { LightningElement, track } from 'lwc';
import getTopMarketData from '@salesforce/apex/StockTopWrapper.getTopMarketData';
import IpoModal from 'c/ipoUi';


export default class StockTopTable extends LightningElement {
    @track marketData;
    dividentCalled=false
    marketType = 'gainers'; // default

        connectedCallback() {
        // Load default Top Gainers when component loads
        this.fetchMarketData('gainers', 10);
    }

    async openIpoModal() {
        await IpoModal.open({
            size: 'large',
            description: 'View IPO details'
        });
    }


    handleGainers() {
        this.dividentCalled=false;
        this.fetchMarketData('gainers', 10);
    }

    dividendController(event)
    {
        this.dividentCalled=!this.dividentCalled
    }

    handleLosers() {
         this.dividentCalled=false;
        this.fetchMarketData('losers', 10);
    }
    handleClose() {
         this.dividentCalled=false;
    this.marketData = null;
}


    fetchMarketData(type, limit) {
    this.marketType = type;
    getTopMarketData({ marketType: type, fetchCount: limit })
        .then(result => {
            // Ensure reactive assignment
            let nseData = result.nse.data.map(item => ({
                ...item,
                percentChange: type === 'gainers' ? item.gain : item.loss
            }));
            let bseData = result.bse.data.map(item => ({
                ...item,
                percentChange: type === 'gainers' ? item.gain : item.loss
            }));

            // Assign back so LWC can see updates
            result.nse.data = nseData;
            result.bse.data = bseData;

            this.marketData = result;
        })
        .catch(error => {
            console.error('Error fetching market data:', error);
        });
}

}
