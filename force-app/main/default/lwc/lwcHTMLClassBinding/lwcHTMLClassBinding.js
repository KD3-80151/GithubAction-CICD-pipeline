import { LightningElement, wire } from 'lwc';
import getAccountLwc from '@salesforce/apex/AccountController.getAccountLwc';

export default class LwcHTMLClassBinding extends LightningElement {
    accountList = [];
    error;

    @wire(getAccountLwc)
    accounts({ data, error }) {
        if (data) {
            // Add a UI-only property to each record
            this.accountList = data.map(acc => {
                return {
                    ...acc,
                    rowClass:
                        acc.Type === 'Customer - Direct' &&
                        acc.Number_Of_Employees__c > 10000
                            ? 'slds-cell-wrap highlighttext'
                            : 'slds-cell-wrap'
                };
            });
        } else if (error) {
            this.accountList = [];
            this.error = error;
        }
    }
}