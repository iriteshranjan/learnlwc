import { LightningElement, track } from 'lwc';
import getAllStocks from '@salesforce/apex/StockRealtimeController.getAllStocks';
import getStockById from '@salesforce/apex/StockRealtimeController.getStockById';
import fetchAndUpdateStockData from '@salesforce/apex/StockRealtimeController.fetchAndUpdateStockData';

export default class StockRealtimeLwc extends LightningElement {
    @track stockOptions = [];
    @track filteredStocks = [];
    @track searchKey = '';
    @track selectedStockId;
    @track localStock;
    @track stockData;
    @track error;
    @track atfHtml; // store ATF__c HTML here

    renderedOnce = false;

    connectedCallback() {
        getAllStocks()
            .then(data => {
                this.stockOptions = data.map(stock => ({
                    label: stock.Name,
                    value: stock.Id
                }));
                this.filteredStocks = this.stockOptions;
            })
            .catch(err => this.error = 'Error loading stocks: ' + err.body?.message);
    }

    renderedCallback() {
        if (this.localStock && !this.renderedOnce) {
            const descEl = this.template.querySelector('.today-highlight');
            if (descEl && this.atfHtml) {
                descEl.innerHTML = this.atfHtml;
            }
            this.renderedOnce = true;
        }
    }

    handleSearchChange(event) {
        this.searchKey = event.target.value.toLowerCase();
        this.filteredStocks = this.stockOptions.filter(opt =>
            opt.label.toLowerCase().includes(this.searchKey)
        );
    }

    handleSelectStock(event) {
        this.selectedStockId = event.currentTarget.dataset.id;
        this.stockData = null;

        getStockById({ stockId: this.selectedStockId })
            .then(stock => {
                this.localStock = stock;
                this.atfHtml = stock.ATF__c || '';
                this.filteredStocks = [];
                this.searchKey = stock.Name;
                this.error = null;
                this.renderedOnce = false; // allow renderedCallback to run
            })
            .catch(err => this.error = 'Error fetching stock: ' + err.body?.message);
    }

    handleSync() {
        fetchAndUpdateStockData({ stockId: this.selectedStockId })
            .then(data => {
                this.stockData = data;
                this.error = null;
                return getStockById({ stockId: this.selectedStockId });
            })
            .then(stock => {
                this.localStock = stock;
                this.atfHtml = stock.ATF__c || '';
                this.renderedOnce = false; // allow re-render
            })
            .catch(err => this.error = 'Sync failed: ' + err.body?.message);
    }

    get isSyncAllowed() {
        const now = new Date();
        const hoursIST = (now.getUTCHours() + 5 + Math.floor((now.getUTCMinutes() + 30) / 60)) % 24;
       // return hoursIST >= 9 && hoursIST < 24;
       return false
    }

    get exchangeFull() {
        return this.localStock?.Exchange__c === 'B' ? 'BSE' : 'NSE';
    }

        get arrowIcon() {
        return this.localStock?.pricepercentchange__c >= 0
        ? 'utility:triangle'
        : 'utility:triangle_down';
}

            get arrowClass() {
            return this.localStock?.pricepercentchange__c >= 0 ? 'arrow-up' : 'arrow-down';
        }

    get priceClass() {
        return this.localStock?.pricepercentchange__c >= 0 ? 'price-up' : 'price-down';
    }

    get formattedPrice() {
        return this.localStock?.pricecurrent__c ? `₹${this.localStock.pricecurrent__c}` : '';
    }

    get formattedHigh() {
        return this.localStock?.X52H__c ? `₹${this.localStock.X52H__c}` : '';
    }

    get formattedLow() {
        return this.localStock?.X52L__c ? `₹${this.localStock.X52L__c}` : '';
    }
}
