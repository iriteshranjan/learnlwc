import { LightningElement } from 'lwc';
import { subscribe, onError } from 'lightning/empApi';

export default class CdcTest extends LightningElement {
    channelName = '/data/Indexes__ChangeEvent';
    subscription = null;

    connectedCallback() {
        this.subscribeToChannel();
        this.registerErrorListener();
    }

    subscribeToChannel() {
        subscribe(this.channelName, -1, (message) => {
            console.log('📢 CDC Event Received:', JSON.stringify(message, null, 2));
        }).then(response => {
            console.log('✅ Subscribed to:', JSON.stringify(response.channel));
            this.subscription = response;
        });
    }

    registerErrorListener() {
        onError(error => {
            console.error('❌ EMP API Error:', JSON.stringify(error, null, 2));
        });
    }
}
