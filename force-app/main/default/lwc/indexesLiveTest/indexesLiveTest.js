import { LightningElement, track } from 'lwc';

export default class IndexesLiveTest extends LightningElement {
    @track indexes = [];
    refreshInterval;

    connectedCallback() {
        this.fetchIndexes(); // Initial load
        this.refreshInterval = setInterval(() => this.fetchIndexes(), 10000); // Auto-refresh
    }

    disconnectedCallback() {
        clearInterval(this.refreshInterval);
    }

    async fetchIndexes() {
        try {
            const response = await fetch('https://api-en.cnbctv18.com/nodeapi/v1/markets/other-indices?type=all');
            if (!response.ok) {
                throw new Error(`API Error: ${response.status}`);
            }

            const jsonResponse = await response.json();
            console.log('✅ Indexes updated', jsonResponse);

            // ✅ Correctly extract the indices array
            const indices = jsonResponse?.list?.indices || [];
            this.indexes = this.formatData(indices);
        } catch (error) {
            console.error('❌ Error fetching indexes:', error);
        }
    }

    formatData(data) {
        return data.map(item => {
            const changeValue = parseFloat(item.change);
            let changeClass = '';
            let arrowIcon = '';

            if (changeValue > 0) {
                changeClass = 'positive';
                arrowIcon = 'utility:arrowup';
            } else if (changeValue < 0) {
                changeClass = 'negative';
                arrowIcon = 'utility:arrowdown';
            } else {
                changeClass = 'neutral';
                arrowIcon = 'utility:minus';
            }

            return {
                Id: item.id,
                Name: item.stkexchg,
                lastprice__c: item.lastprice,
                change__c: item.change,
                changeClass,
                arrowIcon
            };
        });
    }
}
