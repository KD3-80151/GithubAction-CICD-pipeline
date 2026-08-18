import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import createContact from '@salesforce/apex/ContactCreationLwc.createContact';

export default class CreateContact extends LightningElement {
    @track firstName = '';
    @track lastName = '';
    @track email = '';
    @track phone = '';
    @track birthDate;

    handleInputChange(event) {
        const field = event.target.name;
        if (field === 'firstName') {
            this.firstName = event.target.value;
        } else if (field === 'lastName') {
            this.lastName = event.target.value;
        } else if (field === 'email') {
            this.email = event.target.value;
        } else if (field === 'phone') {
            this.phone = event.target.value;
        } else if (field === 'birthDate') {
            this.birthDate = event.target.value;
        }
    }

    handleCreateContact() {
        createContact({ 
            firstName: this.firstName, 
            lastName: this.lastName, 
            email: this.email, 
            phone: this.phone, 
            birthDate: this.birthDate 
        })
        .then(result => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: result,
                    variant: 'success',
                })
            );
            this.clearFields();
        })
        .catch(error => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: error.body.message,
                    variant: 'error',
                })
            );
        });
    }

    handleClearFields() {
        this.clearFields();
    }

    clearFields() {
        this.firstName = '';
        this.lastName = '';
        this.email = '';
        this.phone = '';
        this.birthDate = null;
    }
}