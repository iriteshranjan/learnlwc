import { LightningElement } from 'lwc';

export default class C2pModalComponent extends LightningElement {

    closeHandler()
    {
        const myEvent= new CustomEvent('close',{
            bubbles:true,
            detail:{
                msg:"Hello from Modal and model is closed successfully",
                testmsg:"Hello from testmsg and model is closed testmsg"
            }
        })
        this.dispatchEvent(myEvent);
    }

    footerHandler()
    {
        alert('its Bubbles');
    }
}