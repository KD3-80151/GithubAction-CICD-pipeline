import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ToastNotifications extends LightningElement {

    handleSuccessToast() {
        this.showToast('Success', 'The operation was successful!', 'success');
    }

    handleErrorToast() {
        this.showToast('Error', 'Something went wrong!', 'error');
    }

    handleWarningToast() {
        this.showToast('Warning', 'This is a warning message.', 'warning');
    }

    handleInfoToast() {
        this.showToast('Info', 'This is an informational message.', 'info');
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant, // success, error, warning, info
            mode: 'dismissable' // can be 'pester', 'sticky', or 'dismissable'
        });
        this.dispatchEvent(event);
    }
}