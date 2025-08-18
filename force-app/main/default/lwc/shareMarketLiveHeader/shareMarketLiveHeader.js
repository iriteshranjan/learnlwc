import { LightningElement, track } from 'lwc';

export default class MarketHeader extends LightningElement {
    @track marketStatus = '';
    @track currentTime = '';
    @track statusStyle = '';
    @track dotStyle = '';

    connectedCallback() {
        this.updateMarketStatus();
        this.updateTime();
        setInterval(() => {
            this.updateMarketStatus();
            this.updateTime();
        }, 1000);
    }

        updateMarketStatus() {
            const now = new Date();

            // Convert to IST using Asia/Kolkata
            const istString = now.toLocaleString('en-US', { timeZone: 'Asia/Kolkata' });
            const istDate = new Date(istString);

            const day = istDate.getDay();     // 0=Sun, 6=Sat
            const hour = istDate.getHours();  // IST hours
            const minute = istDate.getMinutes(); // IST minutes

            // NSE/BSE hours: Mon–Fri, 9:00 AM to 3:30 PM IST
            const isOpen =
                day >= 1 && day <= 5 &&
                (hour > 9 || (hour === 9 && minute >= 0)) &&
                (hour < 15 || (hour === 15 && minute <= 30));

            if (isOpen) {
                this.marketStatus = 'Market Open';
                this.statusStyle = 'color:#00ff88; text-shadow:0 0 8px #00ff88;';
                this.dotStyle = 'background-color:#00ff88; box-shadow:0 0 15px #00ff88;';
            } else {
                this.marketStatus = 'Market Closed';
                this.statusStyle = 'color:#ff4d4d; text-shadow:0 0 8px #ff4d4d;';
                this.dotStyle = 'background-color:#ff4d4d; box-shadow:0 0 15px #ff4d4d;';
            }
        }


        updateTime() {
    const now = new Date();
    this.currentTime = now.toLocaleString('en-IN', {
        timeZone: 'Asia/Kolkata',   // ✅ force IST
        weekday: 'long',            // full name: Monday, Tuesday...
        day: '2-digit',
        month: 'short',
        year: 'numeric',
        hour: '2-digit',
        minute: '2-digit',
        second: '2-digit',
        hour12: true                 // ensures AM/PM format
    }).replace(/\b(am|pm)\b/g, match => match.toUpperCase()); // make AM/PM uppercase
}


}
