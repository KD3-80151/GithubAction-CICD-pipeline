import { LightningElement, track } from 'lwc';
import autoSuggest from '@salesforce/apex/AccountController.autoSuggest';

export default class AutoSuggestSearch extends LightningElement {
    @track suggestions = [];
    @track searchTerm = '';
    debounceTimeout;

    handleInputChange(event) {
        debugger;
        const value = event.target.value;
        this.searchTerm = value;

        // Debounce to avoid firing on each keystroke
        window.clearTimeout(this.debounceTimeout);
        this.debounceTimeout = setTimeout(() => {
            if (value.length >= 2) {
                this.searchRecords(value);
            } else {
                this.suggestions = [];
            }
        }, 300);
    }

    searchRecords(keyword) {
        debugger;
        autoSuggest({ keyword })
            .then(result => {
                this.suggestions = result;
            })
            .catch(error => {
                console.error('Error:', error);
            });
    }
}