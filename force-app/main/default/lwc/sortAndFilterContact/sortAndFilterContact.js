import { LightningElement, wire } from 'lwc';
import getSortedContact from '@salesforce/apex/ContactDetailsList.getSortedContact';

const columns = [
    { label: 'Id', fieldName: 'Id', type: 'text', sortable: true },
    { label: 'Name', fieldName: 'Name', type: 'text', sortable: true },
    { label: 'Phone', fieldName: 'Phone', type: 'phone', sortable: true },
    { label: 'Account Name', fieldName: 'AccountName', type: 'text', sortable: true }
];

export default class SortAndFilterContact extends LightningElement {
    data = [];
    columns = columns;
    sortedBy;
    sortedDirection;

    @wire(getSortedContact)
    wiredData({ error, data }) {
        if (data) {
            this.data = data.map(contact => ({
                ...contact,
                AccountName: contact.Account ? contact.Account.Name : ''
            }));
            console.log('Data:::::' + JSON.stringify(this.data));
        } else if (error) {
            console.log('Error:::::::::' + JSON.stringify(error));
        }
    }

    handleSort(event) {
        const { fieldName, sortDirection } = event.detail;
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
}