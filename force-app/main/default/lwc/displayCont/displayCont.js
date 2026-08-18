import getContactSearch from '@salesforce/apex/GetContactClass.getContactSearch';
import { LightningElement, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class DisplayCont extends LightningElement {

    @track contacts;
    @track searchKey='';

    @track columns = [
        {label:'First Name', fieldName:'FirstName' },
        {label:'Last Name', fieldName:'LastName' },
        {label:'Phone', fieldName:'Phone', type: 'phone' },
        {label:'Account Name', fieldName:'AccountName'}
    ];

    handleSearchInput(event){
        this.searchKey= event.target.value;
        if(this.searchKey){
            getContactSearch({searchName: this.searchKey})
            .then(data => {
                this.contacts = data.map(contact =>({
                    
                        ...contact,
                        AccountName: contact.Account ? contact.Account.Name : ''
                    

                }));
                if (data.length === 0) {
                    this.showToast('No Results', 'No contacts found for the search query.', 'info');
                }
            })
            .catch(error => {
                    this.contacts = undefined;
                    this.showToast('Error', `Failed to fetch contacts: ${error.body.message}`, 'error');
                });
        }
        else{
            this.contacts=[];
        }
    }


    showToast(title, message, variant){
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });

        this.dispatchEvent(event);
    }
}