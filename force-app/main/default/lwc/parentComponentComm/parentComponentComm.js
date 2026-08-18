import { LightningElement } from 'lwc';

export default class ParentComponentComm extends LightningElement {
    childOneValue;

    handleChildOneEvent(event){
        this.childOneValue = event.detail;
    }
}