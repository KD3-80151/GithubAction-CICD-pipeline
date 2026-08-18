import getContact from '@salesforce/apex/FetchContact.getContact';
import { LightningElement, wire } from 'lwc';


export default class FetchContactList extends LightningElement {

    contacts;
    columns=[
        {label:'First Name', fieldName:'FirstName'},
        {label:'Last Name', fieldName:'LastName'},
        {label:'Phone', fieldName:'Phone', type:'phone'},
        {label:'Email', fieldName:'Email', type:'email'}
    ];

    @wire(getContact)
    wiredContact({error,data}){
        if(data){
            this.contacts = data;
            this.error = undefined;
        }
        else{
            this.contacts = undefined;
            this.error = error;
        }

    }
}