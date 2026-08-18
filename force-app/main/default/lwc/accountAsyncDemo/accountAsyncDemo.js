//difference between then and catch and async await
import { LightningElement, track, } from 'lwc';
import getAccountLwc from '@salesforce/apex/AccountController.getAccountLwc';

export default class AccountAsyncDemo extends LightningElement {
    @track lastCount = 0;

    fetchWithThen() {
        debugger;
        console.log('Fetch with .then() started');
        console.log('before calling getAccountLwc');

        getAccountLwc()
            .then((result) => {
                console.log('Inside .then() callback');
                this.lastCount = result?.length ?? 0 ; // optional chaining and nullish coalescing
                console.log(`Fetched ${this.lastCount} accounts`);
            })
            .catch((error) => {
                console.error('Error fetching accounts:', error);
            });

            console.log('after calling getAccountLwc (sync continuation)');
            console.log('Fetch with .then() ended' + 'end of method (synchronous part finishes before then)');
    }

    async fetchWithAsyncAwait() {
        debugger;
        console.log('Fetch with async/await started');
        console.log('before calling getAccountLwc');
        try{
            const result = await getAccountLwc();
            console.log('After await - got result');
            this.lastCount = result?.length ?? 0 ;
            console.log(`Fetched ${this.lastCount} accounts`);
            console.log('Fetch with async/await ended');
        }
        catch(error){
            console.error('Error fetching accounts:', error);
        }
    }
}