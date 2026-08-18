import { LightningElement } from 'lwc';

export default class ChildComponentOne extends LightningElement {
    sendDataToParent(){
        const event = new CustomEvent('childoneevent',{
            detail: 'Some data from child one'
        });

        this.dispatchEvent(event);
    }
}