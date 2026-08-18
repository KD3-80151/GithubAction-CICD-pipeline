import getAccountLwc from '@salesforce/apex/AccountController.getAccountLwc';
import { LightningElement, wire } from 'lwc';

export default class AccountParentComp extends LightningElement {

    accountOptions=[];
    selectAccountId;

    @wire(getAccountLwc)
    wiredAccount({data,error}){
        if(data){
            this.accountOptions = data.map(account=> {
                return{ label: account.Name, value: account.Id }
            });
            this.error = undefined;
        }
        else{
            this.accounts = undefined;
            this.error = error;
        }
    }

    handleChange(event){
        this.selectAccountId = event.target.value;
    }
}