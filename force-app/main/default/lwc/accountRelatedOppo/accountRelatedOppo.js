import { LightningElement, track, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import { getListUi } from 'lightning/uiListApi';

const ACCOUNT_FIELDS = ['Account.Name'];
const OPPORTUNITY_FIELDS = ['Opportunity.Name', 'Opportunity.StageName', 'Opportunity.Amount'];
const OPPORTUNITY_RELATIONSHIP = 'Opportunities';

export default class AccountRelatedOppo extends LightningElement {
    @track accountOptions = [];
    @track selectedAccountId;
    @track opportunities;

    @wire(getListUi, { objectApiName: 'Account', listViewApiName: 'AllAccounts' })
    wiredAccounts({ error, data }) {
        if (data) {
            this.accountOptions = data.records.records.map(account => {
                return { label: getFieldValue(account, ACCOUNT_FIELDS[0]), value: account.id };
            });
        } else if (error) {
            console.error(error);
        }
    }

    @wire(getRecord, { recordId: '$selectedAccountId', fields: ACCOUNT_FIELDS, optionalFields: OPPORTUNITY_FIELDS, relationshipFields: [OPPORTUNITY_RELATIONSHIP] })
    wiredOpportunities({ error, data }) {
        if (data) {
            this.opportunities = data.fields.Opportunities ? data.fields.Opportunities.records : [];
        } else if (error) {
            console.error(error);
        }
    }

    handleAccountChange(event) {
        this.selectedAccountId = event.detail.value;
    }
}