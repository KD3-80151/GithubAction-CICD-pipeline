import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ParentComponent extends LightningElement {
    // handleCLick(){
    //     this.template.querySelector("c-child-component").handleChangeValue();
    // }

     @track showModal = false;

    openModal() {
        this.showModal = true;
    }

    closeModal() {
        this.showModal = false;
    }

    handleConfirm() {
        this.showModal = false;

        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Confirmed',
                message: 'The action has been successfully confirmed.',
                variant: 'success',
                mode: 'dismissable'
            })
        );
    }
}