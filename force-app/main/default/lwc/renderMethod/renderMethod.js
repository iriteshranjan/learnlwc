import { LightningElement } from 'lwc';
import signIn from './signIn.html';
import signOut from './signOut.html';
import RenderMethodtemplate from './renderMethod.html';

export default class RenderMethod extends LightningElement {
    selected='';

        render()
        {
            return this.selected === 'signin' ? signIn :
                   this.selected === 'signup' ? signOut :
                   RenderMethodtemplate
        }
        submitHandler(event)
        {
            this.selected=event.target.label
        }

}