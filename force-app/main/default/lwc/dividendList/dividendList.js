import { LightningElement, wire, track } from 'lwc';
import dividendData from '@salesforce/apex/dividendController.dividendLwcController';

export default class DividendList extends LightningElement {
    @track allDividends = [];   // full dataset (~200)
    @track displayedDividends = []; // current page data
    @track pageNumber = 1;
    pageSize = 10;
    totalPages = 0;

        columns = [
            { label: 'Name', fieldName: 'Name'   },
            { 
                label: 'Dividend', 
                fieldName: 'dividend__c', 
                type: 'currency',
                
                typeAttributes: { currencyCode: 'INR' }
            },
           { 
                label: 'Stock Current Price', 
                fieldName: 'lastValue__c', 
                type: 'currency',
               
              typeAttributes: { currencyCode: 'INR' }
            },
            { label: 'Ex Date', fieldName: 'exDate__c', type: 'date' }
        ];


    @wire(dividendData)
    wiredDividends({ data, error }) {
        if (data) {
            this.allDividends = data;
            this.totalPages = Math.ceil(this.allDividends.length / this.pageSize);
            console.log('ritesh',this.totalPages);
            this.setPageData();
        } else if (error) {
            console.error('Error loading dividends', error);
        }
    }

    setPageData() {
        const start = (this.pageNumber - 1) * this.pageSize;
        const end = this.pageNumber * this.pageSize;
        this.displayedDividends = this.allDividends.slice(start, end);
    }

    handleNext() {
        if (this.pageNumber < this.totalPages) {
            this.pageNumber++;
            this.setPageData();
        }
    }

    handlePrev() {
        if (this.pageNumber > 1) {
            this.pageNumber--;
            this.setPageData();
        }
    }

    get disablePrev() {
        return this.pageNumber === 1;
    }

    get disableNext() {
        return this.pageNumber === this.totalPages;
    }

    get pageInfo() {
        return `Page ${this.pageNumber} of ${this.totalPages}`;
    }

    
}
