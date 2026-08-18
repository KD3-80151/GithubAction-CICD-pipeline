import displayAccount from '@salesforce/apex/DisplayAccountRecords.displayAccount';
import { LightningElement, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class DisplayAccountRecords extends LightningElement {


    isLoading=true;
    contacts;
    
    columns = [
        {label:'FirstName' , fieldName:'FirstName'},
        {label:'LastName', fieldName:'LastName'},
        {label:'Email', fieldName:'Email', type:'email'},
        {label:'Phone', fieldName:'Phone', type:'phone'},
        {label:'Account Name', fieldName:'AccountName', type:'phone'}

    ];

    @wire(displayAccount)
    wiredContacts({error,data}){
        this.isLoading = false;
        if (data) {
            this.contacts = data.map(contact =>{
                return{
                    ...contact,
                    AccountName: contact.Account ? contact.Account.Name : ''
                };
            })
            this.error = undefined;
            this.showToast('Succes: Contacts loaded successfully');
        }
        else if(error){
            this.contacts = undefined;
            this.error = error;
            this.showToast('Failed: Contacts not loaded successfully');
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