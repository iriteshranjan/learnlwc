import { LightningElement, track } from 'lwc';

export default class IndexesLiveTest extends LightningElement {
    @track indexes = [];
    @track nifty50;
    @track filteredIndexes = [];
    @track sensex;
    refreshInterval;

    connectedCallback() {
        this.fetchIndexes();
        this.refreshInterval = setInterval(() => this.fetchIndexes(), 5000);
    }

    disconnectedCallback() {
        clearInterval(this.refreshInterval);
    }

    async fetchIndexes() {
        try {
            // 🔹 First API Call - Existing
            const response = await fetch('https://api-en.cnbctv18.com/nodeapi/v1/markets/other-indices?type=all');
            if (!response.ok) {
                throw new Error(`API Error: ${response.status}`);
            }

            const jsonResponse = await response.json();
            console.log('✅ Indexes updated', jsonResponse);
            const indices = jsonResponse?.list?.indices || [];

            const formatted = this.formatData(indices);
            this.filteredIndexes = formatted.filter(item => !item.Name.toLowerCase().startsWith('bse'));
            this.indexes = formatted;

            // ✅ Pick Nifty50 and Sensex explicitly
            this.nifty50 = formatted.find(item => item.Name.toLowerCase().includes('nifty 50'));
            this.sensex = formatted.find(item => item.Name.toLowerCase().includes('sensex'));

            // 🔹 Second API Call - Update only lastprice__c for Nifty50
            if (this.nifty50) {
                this.updateNifty50Price(this.nifty50);
            }

        } catch (error) {
            console.error('❌ Error fetching indexes:', error);
        }
    }

    async updateNifty50Price(niftyIndex) {
        try {
            const response = await fetch('https://priceapi.moneycontrol.com/pricefeed/notapplicable/inidicesindia/in%3BNSX');
            if (!response.ok) {
                throw new Error(`API Error: ${response.status}`);
            }

            const jsonResponse = await response.json();
            const latestPrice = jsonResponse?.data?.pricecurrent;
             const change = jsonResponse?.data?.pricechange;
             //change = parseFloat(change).toFixed(2);

            if (latestPrice) {
                niftyIndex.lastprice__c = latestPrice;
                niftyIndex.change__c = change;

                // 🔄 Also update in indexes array so UI re-renders properly
                this.indexes = [...this.indexes.map(item =>
                    item.Id === niftyIndex.Id ? { ...item, lastprice__c: latestPrice,change__c: change } : item
                )];
            }
        } catch (error) {
            console.error('❌ Error updating Nifty50 price:', error);
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
