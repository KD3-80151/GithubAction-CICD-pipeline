import { LightningElement, track } from 'lwc';
import getAccounts from '@salesforce/apex/GetAccountRest.getAccounts';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class AccountData extends LightningElement {
    @track accounts;
    @track isLoading = false;

    columns = [
        { label: 'Account ID', fieldName: 'Id' },
        { label: 'Account Name', fieldName: 'Name' }
    ];

    handleFetchAccounts() {
        this.isLoading = true;
        getAccounts()
            .then(result => {
                this.accounts = result;
                this.isLoading = false;
                this.showToast('Success', 'Accounts fetched successfully', 'success');
            })
            .catch(error => {
                this.isLoading = false;
                this.showToast('Error', 'Failed to fetch accounts: ' + error.body.message, 'error');
            });
    }

    showToast(title, message, variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(evt);
    }
}