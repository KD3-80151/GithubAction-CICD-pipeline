import { LightningElement, api } from 'lwc';

export default class ModalPopup extends LightningElement {
    @api isOpen = false; 
    @api header = 'Confirmation'; 

    handleCancel() {
        this.dispatchEvent(new CustomEvent('cancel'));
    }

    handleConfirm() {
        this.dispatchEvent(new CustomEvent('confirm'));
    }
}