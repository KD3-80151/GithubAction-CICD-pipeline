import { LightningElement, api, track } from 'lwc';
import searchRecords from '@salesforce/apex/LookupController.searchRecords';

export default class LookUpComponent extends LightningElement {
    @api label = 'Search';
    @api placeholder = 'Search...';
    @api objectApiName = 'Account';
    @api fieldApiName = 'Name';

    @track records = [];
    @track searchKey = '';
    @track selectedRecord = null;
    @track isDropdownOpen = false;

    get comboboxClass() {
        return 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click ' +
               (this.isDropdownOpen ? 'slds-is-open' : '');
    }

    openDropdown() {
        this.isDropdownOpen = true;
    }

    handleSearchChange(event) {
        this.searchKey = event.target.value;
        if (this.searchKey.length >= 2) {
            searchRecords({ searchKey: this.searchKey, objectApiName: this.objectApiName, fieldApiName: this.fieldApiName })
                .then(result => {
                    this.records = result.map(rec => {
                        return { Id: rec.Id, Name: rec[this.fieldApiName] };
                    });
                    this.isDropdownOpen = true;
                })
                .catch(error => {
                    console.error('Error fetching records', error);
                });
        } else {
            this.records = [];
        }
    }

    handleSelect(event) {
        const recordId = event.currentTarget.dataset.id;
        const recordName = event.currentTarget.dataset.name;

        this.selectedRecord = { Id: recordId, Name: recordName };
        this.searchKey = '';
        this.records = [];
        this.isDropdownOpen = false;

        this.dispatchEvent(new CustomEvent('lookupselect', {
            detail: this.selectedRecord
        }));
    }

    clearSelection() {
        this.selectedRecord = null;
        this.dispatchEvent(new CustomEvent('lookupclear'));
    }

    handleBlur() {
        setTimeout(() => {
            this.isDropdownOpen = false;
        }, 200);
    }
}