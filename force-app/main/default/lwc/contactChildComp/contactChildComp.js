import getContactsByAccountId from '@salesforce/apex/AccountController.getContactsByAccountId';
import { api, LightningElement, wire } from 'lwc';

export default class ContactChildComp extends LightningElement {

    @api accountId;
    contacts = [];

    @wire(getContactsByAccountId, { accountId: '$accountId' })
    wiredContact({data, error}){
        if (data) {
            this.contacts = data;

        }
        else if(error){
            console.log("error in fetching data:"+ error);
        }
    }

}