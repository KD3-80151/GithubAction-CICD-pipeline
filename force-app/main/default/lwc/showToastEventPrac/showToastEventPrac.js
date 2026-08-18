import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class ShowToastEventPrac extends LightningElement {
    myTitle = "Toast";
    handleClick(){
        //
    }

    showToast(){
        const event = new ShowToastEvent({
            title: 'show toast dev',
            message: 'display toast example',
            variant: 'success'
        })

        this.dispatchEvent(event);
        
    }
}