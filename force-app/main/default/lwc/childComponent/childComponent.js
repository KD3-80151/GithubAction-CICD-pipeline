import { api, LightningElement } from 'lwc';

export default class ChildComponent extends LightningElement {
   @api itemName = 'Sagar Kumar';
   
   
   @api handleChangeValue(){
    this.itemName = 'Salesforce Lwc'

   }
}