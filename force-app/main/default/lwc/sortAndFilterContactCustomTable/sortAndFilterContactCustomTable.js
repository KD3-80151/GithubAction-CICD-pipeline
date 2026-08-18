import { LightningElement, wire } from 'lwc';
import getSortedContact from '@salesforce/apex/ContactDetailsList.getSortedContact';

export default class SortAndFilterContactCustomTable extends LightningElement {
    data = [];
    allData = [];
    sortedBy;
    sortedDirection;
    searchKey = '';

    @wire(getSortedContact)
    wiredData({ error, data }) {
        if (data) {
            
            this.allData = data.map(contact => ({
                ...contact,
                AccountName: contact.Account ? contact.Account.Name : ''
            }));
            this.data = [...this.allData];
            console.log('Data:::::' + JSON.stringify(this.data));
        } else if (error) {
            console.log('Error:::::::::' + JSON.stringify(error));
        }
    }

    handleSearch(event) {
        this.searchKey = event.target.value.toLowerCase();
        this.filterData();
    }

    filterData() {
    if (this.searchKey) {
        this.data = this.allData.filter(contact =>
            contact.Name.toLowerCase().includes(this.searchKey)
        );
    } else {
        this.data = [...this.allData]; 
    }

    // Apply sorting to the filtered data if sorting has already been applied
    if (this.sortedBy && this.sortedDirection) {
        this.sortData(this.sortedBy, this.sortedDirection);
    }
}


    handleSort(event) {
        const fieldName = event.currentTarget.dataset.fieldName;
        const sortDirection = this.sortedBy === fieldName && this.sortedDirection === 'asc' ? 'desc' : 'asc';

        this.sortedBy = fieldName;
        this.sortedDirection = sortDirection;

        this.sortData(fieldName, sortDirection);
    }

    sortData(field, direction) {
        let sortResult = [...this.data];
        sortResult.sort((a, b) => {
            let valueA = a[field];
            let valueB = b[field];
            if (typeof valueA === 'string' && typeof valueB === 'string') {
                valueA = valueA.toLowerCase();
                valueB = valueB.toLowerCase();
            }
            if (valueA > valueB) {
                return direction === 'asc' ? 1 : -1; 
            } else if (valueA < valueB) {
                return direction === 'asc' ? -1 : 1;
            }
            return 0;
        });

        this.data = sortResult;
    }

    get isIdSortedDesc() {
        return this.sortedBy === 'Id' && this.sortedDirection === 'desc';
    }
    get isIdSortedAsc() {
        return this.sortedBy === 'Id' && this.sortedDirection === 'asc';
    }
    get isNameSortedDesc() {
        return this.sortedBy === 'Name' && this.sortedDirection === 'desc';
    }
    get isNameSortedAsc() {
        return this.sortedBy === 'Name' && this.sortedDirection === 'asc';
    }
    get isPhoneSortedDesc() {
        return this.sortedBy === 'Phone' && this.sortedDirection === 'desc';
    }
    get isPhoneSortedAsc() {
        return this.sortedBy === 'Phone' && this.sortedDirection === 'asc';
    }
    get isAccountNameSortedDesc() {
        return this.sortedBy === 'AccountName' && this.sortedDirection === 'desc';
    }
    get isAccountNameSortedAsc() {
        return this.sortedBy === 'AccountName' && this.sortedDirection === 'asc';
    }
}