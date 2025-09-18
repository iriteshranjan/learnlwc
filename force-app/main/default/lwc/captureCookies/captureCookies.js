import { LightningElement } from 'lwc';
import createCookieRecord from '@salesforce/apex/CookieController.createCookieRecord';

export default class CaptureCookies extends LightningElement {
    async connectedCallback() {
        try {
            // 1. Fetch IP + location info from browser side
            const ipResponse = await fetch('https://ipwho.is/');
            const ipData = await ipResponse.json();

            // 2. Capture cookies from browser
            const cookieData = document.cookie || 'NO_COOKIES_FOUND';

            // 3. Combine both into a single payload
            const combinedData = {
                ipInfo: ipData,
                cookies: cookieData
            };

            // 4. Send to Apex for storing
            createCookieRecord({ cookieData: JSON.stringify(combinedData) })
                .then(result => {
                    //console.log('✅ Cookie__c record created with Id:', result);
                })
                .catch(error => {
                    //console.error('❌ Error creating Cookie__c record:', error);
                });

        } catch (err) {
            console.error('❌ Failed to fetch IP or send data to Apex:', err);
        }
    }
}
