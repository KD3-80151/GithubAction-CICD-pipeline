import { LightningElement, track} from 'lwc';
import getContact from '@salesforce/apex/ContactDetailsList.getContacts';
import deleteContacts from '@salesforce/apex/ContactDetailsList.deleteContacts';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ContactDetailsList extends LightningElement {
    @track contacts;
    @track selectedRows = [];
    selectedContacts = [];
    @track columns = [
        { label: 'Name', fieldName: 'Name' },
        { label: 'Email', fieldName: 'Email', type: 'email' },
        { label: 'Phone', fieldName: 'Phone', type: 'phone' },
        { label: 'Account Name', fieldName: 'AccountName' }
    ];

    handleSearch(event) {
        debugger;
        const searchKey = event.target.value;
        console.log(searchKey);
        if (searchKey) {
            getContact({ searchKey })
                .then(result => {
                    console.log('result:::::::', result);
                     this.contacts = result.map(contact => ({
                        ...contact,
                        AccountName: contact.Account?.Name,
                        
                    }));

                    console.log('Mapped contacts:', this.contacts);
                    
                    if (result.length === 0) {
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'No Contacts Found',
                                message: 'No contacts found matching your search criteria.',
                                variant: 'info'
                            })
                        );
                    }
                })
                .catch(error => {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error',
                            message: error.body.message,
                            variant: 'error'
                        })
                    );
                });
        } else {
            this.contacts = [];
        }
    }


    

  getSelectedRows(event) {
    const rows = event.detail.selectedRows;
        this.selectedRows = rows.map(row => row.Id);
        this.selectedContacts = rows;
    }

    handleDelete() {
        if (this.selectedRows.length > 0) {
            deleteContacts({ contactIds: this.selectedRows })
                .then(() => {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: 'Selected contacts deleted successfully.',
                            variant: 'success'
                        })
                    );
                    this.contacts = this.contacts.filter(contact => !this.selectedRows.includes(contact.Id));
                    this.selectedRows = [];
                    this.selectedContacts = rows;
                })
                .catch(error => {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error',
                            message: error.body.message,
                            variant: 'error'
                        })
                    );
                });
        } 

    
    }
    
}



//passing the string and from the list of string whether it has duplicate or not or have to return just true or false