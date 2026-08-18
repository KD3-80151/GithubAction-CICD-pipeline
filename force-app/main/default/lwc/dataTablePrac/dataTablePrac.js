import getContact from '@salesforce/apex/GetContactClass.getContact';
import { LightningElement, wire } from 'lwc';

export default class DataTablePrac extends LightningElement {

    contacts;
    columns =[
        {label: 'First Name', fieldName:'FirstName' },
        {label:'Last Name' , fieldName: 'LastName'},
        {label:'Phone' , fieldName: 'Phone', type: 'phone'}
    ];

    @wire(getContact)
    wiredContact({ data, error }) {
        if (data) {
            this.contacts = data;
        } else if (error) {
            console.error('Error fetching contacts: ', error);
        }
    }
}