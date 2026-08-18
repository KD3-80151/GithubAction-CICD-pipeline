import { LightningElement, api, wire } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecord } from 'lightning/uiRecordApi';
import updateAccountName from '@salesforce/apex/UpdateAccount.updateAccountName';
import ACCOUNT_ID_FIELD from '@salesforce/schema/Contact.AccountId';

const FIELDS = [ACCOUNT_ID_FIELD];

export default class UpdateContactAccountName extends LightningElement {
    @api recordId;
    userInput = '';
    accountId;

    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    wiredContact({ error, data }) {
        if (data) {
            this.accountId = data.fields.AccountId.value;
        } else if (error) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error retrieving contact record',
                    message: error.body.message,
                    variant: 'error'
                })
            );
        }
    }

    handleChange(event) {
        this.userInput = event.target.value;
    }

    handleClick() {
        updateAccountName({ accountId: this.accountId, newName: this.userInput })
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Account Name updated successfully',
                        variant: 'success'
                    })
                );
                this.dispatchEvent(new CloseActionScreenEvent());
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error updating record',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
            });
    }
}