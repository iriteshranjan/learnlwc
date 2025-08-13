import { LightningElement, wire, track } from 'lwc';
import getIndexes from '@salesforce/apex/IndexesController.getIndexes';
import { subscribe, onError } from 'lightning/empApi';
import { refreshApex } from '@salesforce/apex';

export default class IndexesLive extends LightningElement {
    @track indexes = [];
    subscription = {};
    channelName = '/data/Indexes__ChangeEvent';
    wiredIndexesResult; // store wire result for refresh

    @wire(getIndexes)
    wiredIndexes(result) {
                console.log('📢 wiredIndexes');

        this.wiredIndexesResult = result; // save wire result for refreshApex
        const { error, data } = result;
        if (data) {
            this.indexes = this.formatData(data);
        } else if (error) {
            console.error(error);
        }
    }

    connectedCallback() {
        console.log('📢 CconnectedCallback');
        this.subscribeToCdc();
    }

    subscribeToCdc() {
        subscribe(this.channelName, -1, () => {
            console.log('📢 CDC Event Received, refreshing...');
            this.refreshIndexes();
        }).then(response => {
            console.log('✅ Subscribed to CDC:', JSON.stringify(response));
            this.subscription = response;
        });

        onError(error => {
            console.error('❌ EMP API error', error);
        });
    }

    refreshIndexes() {
        // Force refresh of the wired method
        refreshApex(this.wiredIndexesResult)
            .then(() => console.log('✅ Indexes refreshed from server'))
            .catch(error => console.error('Error refreshing indexes:', error));
    }

    formatData(data) {
        return data.map(item => {
            let changeClass = '';
            let arrowIcon = '';

            if (item.change__c > 0) {
                changeClass = 'positive';
                arrowIcon = 'utility:arrowup';
            } else if (item.change__c < 0) {
                changeClass = 'negative';
                arrowIcon = 'utility:arrowdown';
            } else {
                changeClass = 'neutral';
                arrowIcon = 'utility:minus';
            }

            return {
                ...item,
                changeClass,
                arrowIcon
            };
        });
    }
}
