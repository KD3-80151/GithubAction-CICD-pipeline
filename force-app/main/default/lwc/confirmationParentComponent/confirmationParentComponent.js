import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ConfirmationParentComponent extends LightningElement {
    @track showDialog = false;

    promptDelete() {
        this.showDialog = true;
    }

    handleCancel() {
        this.showDialog = false;
    }

    handleDelete() {
        this.showDialog = false;

        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Deleted',
                message: 'The record was deleted successfully.',
                variant: 'success'
            })
        );
    }
}