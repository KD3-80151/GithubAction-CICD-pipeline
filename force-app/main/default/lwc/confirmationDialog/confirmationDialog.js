import { LightningElement, api, track } from 'lwc';

export default class ConfirmationDialog extends LightningElement {
    @api title = 'Confirm Action';
    @api message = 'Are you sure you want to proceed?';
    @api visible = false;

    @track isSecondConfirm = false;

    handleCancel() {
        this.isSecondConfirm = false;
        this.dispatchEvent(new CustomEvent('cancel'));
    }

    handleFirstConfirm() {
        this.isSecondConfirm = true;
    }

    handleFinalDelete() {
        this.isSecondConfirm = false;
        this.dispatchEvent(new CustomEvent('confirm'));
    }
}