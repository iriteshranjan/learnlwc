import { LightningElement } from 'lwc';

export default class ChatPanelLwc extends LightningElement {
    isOpen = false;

    openChat() {
        this.isOpen = true;
        // Load the Embedded Messaging SDK if not already loaded
        if (!window.embeddedservice_bootstrap) {
            console.error('Embedded Service not loaded!');
            return;
        }

        // Prevent loading multiple times
        if (!this.initialized) {
            this.initialized = true;
            window.embeddedservice_bootstrap.settings = {
                // Optional: Set your configuration here
            };

            window.embeddedservice_bootstrap.init(
                'YOUR_ORG_NAME', // Replace with your org name
                'YOUR_DEPLOYMENT_NAME',
                'https://YOUR_DOMAIN.lightning.force.com',
                {
                    baseLiveAgentContentURL: 'https://c.la1-c1cs-phx.salesforceliveagent.com/content',
                    deploymentId: '572XXXXXXXXXXXX', // Your deploymentId
                    buttonId: '573XXXXXXXXXXXX', // Your buttonId
                    baseLiveAgentURL: 'https://d.la1-c1cs-phx.salesforceliveagent.com/chat',
                    eswLiveAgentDevName: 'EmbeddedServiceLiveAgent_DevName',
                    isOfflineSupportEnabled: false
                }
            );
        }
    }

    closeChat() {
        this.isOpen = false;
        // Optionally, close the chat session if needed
        if (window.embeddedservice_bootstrap && window.embeddedservice_bootstrap.endChat) {
            window.embeddedservice_bootstrap.endChat();
        }
    }
}
