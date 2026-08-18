import { LightningElement, track, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi'; //here not getRecordUi
const FIELDS = [
   'Contact.Name',
   'Contact.Email',
   'Contact.Phone'
];
 
 
export default class LightningRecordPicker extends LightningElement {
   @track contactId;
 
 
   @wire(getRecord, { recordId: '$contactId', fields: FIELDS })
   contact;
 
 
   handleRecordChange(event) {
    debugger;
       this.contactId = event.detail.recordId;
   }
}