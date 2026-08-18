import getContactPage from '@salesforce/apex/ContactDetailsList.getContactPage';
import { LightningElement, track, wire } from 'lwc';

export default class CustomPagination extends LightningElement {
    @track visibleConatcts;
    @track totalContactList;
    @wire(getContactPage)
    wiredContacts({data, error}){
        debugger;
        if(data){            
            this.totalContactList = data;
            console.log(data);
        }
        else{
            console.log(error);
        }
    }
    slicedHandler(event){
        debugger;
        this.visibleConatcts = [...event.detail.records];
        console.log(this.visibleConatcts);
    }


}