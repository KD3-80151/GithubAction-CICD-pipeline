import { LightningElement, track } from 'lwc';
import getAccountLwc from '@salesforce/apex/AccountController.getAccountLwc';

    const caches = new Map();
export default class CacheStorageForFewMinutes extends LightningElement {

    @track accounts;
    laoding = false;
    error;

    async load(){
        this.laoding = true;
        if(caches.has('accounts')){
            this.accounts = caches.get('accounts'); this.laoding = false; return;
        }

        try{
            this.accounts = await getAccountLwc();
            caches.set('accounts', this.accounts);
        }
        catch (e){
            this.error = e;
        }
            
        this.laoding = false;
    }



}