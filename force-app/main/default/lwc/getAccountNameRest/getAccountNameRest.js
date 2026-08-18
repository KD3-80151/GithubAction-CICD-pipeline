import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import searchAccounts from '@salesforce/apex/SearchAccountsController.searchAccounts';

export default class GetAccountNameRest extends LightningElement {

    @track accounts;
    @track searchKey =''; 
    @track columns = [ 
        {label: 'Account Name', fieldName: 'Name' }
    ] 
    @track error;

    // handleSearchKeyChange(event){
    //     this.searchKey = event.target.value;
    // }

    handleSearch(event){
        this.searchKey = event.target.value;
            searchAccounts({searchKey : this.searchKey })
                .then( result => {
                    this.accounts = result;
                    this.error = undefined;
                })
                .catch(error=>{
                    this.error = error;
                    this.accounts = undefined;
                })
    }

}