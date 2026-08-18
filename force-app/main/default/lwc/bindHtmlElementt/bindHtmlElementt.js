import { LightningElement } from 'lwc';

export default class BindHtmlElementt extends LightningElement {
   // myValue = "Salesforce Practice";
   firstName = '';
//   lastName = ''; 
   handleChange(event){
    const field = event.target.name; 
    //this.myValue = event.target.value;

   // if (field === 'firstName') {
        this.firstName = event.target.value;
    //}
    // else{
    //     this.lastName = event.target.value;
    // }
    // 
    } 
    get upperCase(){
        return `${this.firstName}`.toUpperCase();
    }

}