import { api, LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { createRecord } from 'lightning/uiRecordApi';

import CONTACT_OBJECT from '@salesforce/schema/Contact';
import FIRSTNAME_FIELD from '@salesforce/schema/Contact.FirstName';
import LASTNAME_FIELD from '@salesforce/schema/Contact.LastName';
import EMAIL_FIELD from '@salesforce/schema/Contact.Email';
import PHONE_FIELD from '@salesforce/schema/Contact.Phone';
import { CloseActionScreenEvent } from 'lightning/actions';

export default class ContactCreation extends LightningElement {
    
    @api recordId;
    @track contact={
        firstName:'',
        lastName: '',
        email: '',
        phone: ''
    }

    handleChange(event){
        const {name , value} = event.target;
        this.contact = {...this.contact, [name]: value }
    }

    createContact(){
        debugger;
        const fields = {};
        console.log('Creating contact...');
        console.log('RecordId:', this.recordId);
        fields[FIRSTNAME_FIELD.fieldApiName] = this.contact.firstName;
        fields[LASTNAME_FIELD.fieldApiName] = this.contact.lastName;
        fields[EMAIL_FIELD.fieldApiName] = this.contact.email;
        fields[PHONE_FIELD.fieldApiName] = this.contact.phone;
        fields['AccountId'] = this.recordId;


        const input = {apiName: CONTACT_OBJECT.objectApiName, fields };
        console.log('Inputs:::::::::' + input);
        console.log('Fields:::::::::' + fields);
        createRecord(input)
        .then(() => {
            this.showToast('Success', 'Contact created', 'success');
            this.resetForm();
            this.dispatchEvent(new CloseActionScreenEvent());
        })
            .catch(error => {
                console.error('Error while creating contact:', error);
                this.showToast('Error', 'Contact not created', 'error');
            });
    }
    
    showToast(title, message, variant){
        const event = new ShowToastEvent({
            title,
            message,
            variant,
        });
        this.dispatchEvent(event);
    }

    resetForm(){
        this.contact = {
            firstName: '',
            lastName: '',
            email: '',
            phone: ''

        }
    }
}