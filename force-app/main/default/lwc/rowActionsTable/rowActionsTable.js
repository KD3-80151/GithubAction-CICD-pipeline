import { LightningElement, wire, track } from 'lwc';
import getContacts from '@salesforce/apex/ContactController.getContact';
import deleteContact from '@salesforce/apex/ContactController.deleteContact';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const actions = [
    { label: 'Edit', name: 'edit' },
    { label: 'Delete', name: 'delete' }
];

const columns = [
    { label: 'First Name', fieldName: 'FirstName' },
    { label: 'Last Name', fieldName: 'LastName' },
    { label: 'Email', fieldName: 'Email' },
    {
        type: 'action',
        typeAttributes: { rowActions: actions }
    }
];

export default class ContactTable extends LightningElement {
    @track contacts = [];
    columns = columns;

    @wire(getContacts)
    wiredContacts({ data, error }) {
        if (data) {
            this.contacts = data;
        } else if (error) {
            this.showToast('Error', 'Error loading contacts', 'error');
        }
    }

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;

        switch (actionName) {
            case 'edit':
                this.editRow(row);
                break;
            case 'delete':
                this.deleteRow(row);
                break;
        }
    }

    editRow(row) {
        this.showToast('Edit', `Editing ${row.FirstName} ${row.LastName}`, 'info');
        // Add modal or navigation logic here
    }

    deleteRow(row) {
        deleteContact({ contactId: row.Id })
            .then(() => {
                this.contacts = this.contacts.filter(item => item.Id !== row.Id);
                this.showToast('Deleted', 'Contact deleted successfully', 'success');
            })
            .catch(error => {
                this.showToast('Error', 'Failed to delete contact', 'error');
                console.error(error);
            });
    }

    showToast(title, message, variant) {
        this.dispatchEvent(
            new ShowToastEvent({
                title,
                message,
                variant
            })
        );
    }
}