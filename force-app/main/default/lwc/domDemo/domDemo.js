import { LightningElement, track } from 'lwc';

export default class DomDemo extends LightningElement {
    @track logOutput;

    log(message) {
        this.logOutput = message;
        console.log(message);
    }

    showTextContent() {
        const box = this.template.querySelector('.box');
        this.log(`textContent: ${box.textContent}`);
        box.textContent = 'Changed using textContent!';
    }

    showInnerText() {
        const box = this.template.querySelector('.box');
        this.log(`innerText: ${box.innerText}`);
        box.innerText = 'Changed using innerText!';
    }

    showInnerHTML() {
        const box = this.template.querySelector('.box');
        this.log(`innerHTML: ${box.innerHTML}`);
        box.innerHTML = '<i>Changed with innerHTML (italic)</i>';
    }

    showOuterHTML() {
        const box = this.template.querySelector('.box');
        this.log(`outerHTML: ${box.outerHTML}`);
        box.outerHTML = '<p>This replaced the entire element!</p>';
    }

    showValue() {
        const input = this.template.querySelector('.input-box');
        this.log(`value: ${input.value}`);
        input.value = 'Changed using .value';
    }

    toggleClass() {
        const box = this.template.querySelector('.box');
        if (box) {
            box.className = box.className.includes('newClass') ? 'box' : 'box newClass';
            this.log(`className changed to: ${box.className}`);
        }
    }

    toggleColor() {
        const box = this.template.querySelector('.box');
        if (box) {
            box.style.color = box.style.color === 'red' ? 'blue' : 'red';
            this.log(`Current color: ${box.style.color}`);
        }
    }
}
