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

    connectedCallback() {
        getAllStocks()
            .then(data => {
                this.stockOptions = data.map(stock => ({
                    label: stock.Name,
                    value: stock.Id
                }));
                this.filteredStocks = this.stockOptions;
                this.error = null;
            })
            .catch(err => {
                this.error = 'Error loading stocks: ' + err.body?.message;
            });
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
                this.filteredStocks = []; // collapse dropdown after selection
                this.searchKey = stock.Name;
                this.error = null;
            })
            .catch(err => {
                this.error = 'Error fetching stock: ' + err.body?.message;
            });
    }

    handleSync() {
        if (!this.selectedStockId) return;

        fetchAndUpdateStockData({ stockId: this.selectedStockId })
            .then(data => {
                this.stockData = data;
                this.error = null;
            })
            .catch(err => {
                this.error = 'Sync failed: ' + err.body?.message;
            });
    }
}
