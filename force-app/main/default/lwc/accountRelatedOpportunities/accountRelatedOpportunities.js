import { LightningElement, wire, track } from 'lwc';
import search from '@salesforce/apex/AccountController.searchAccounts';
import getOpportunitiesByAccountId from '@salesforce/apex/AccountController.getOpportunitiesByAccountId';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class AccountRelatedOpportunities extends LightningElement {
    @track accountOpt = [];
    @track selectedAccountId;
    @track opportunities;
    @track searchKey = '';

    @wire(search, { searchKey: '' })
    wiredAccounts({ error, data }) {
        if (data) {
            this.accountOpt = data.map(account => ({
                label: account.Name, 
                value: account.Id 
            }));
        } else if (error) {
            console.error('Error fetching accounts:', error);
        }
    }

    handleAccountChange(event) {
        this.selectedAccountId = event.detail.value;
        this.fetchOpportunities();
    }

    fetchOpportunities() {
        getOpportunitiesByAccountId({ accountId: this.selectedAccountId })
            .then(result => {
                this.opportunities = result.map(opportunity => ({
                    ...opportunity,
                    Amount: opportunity.Amount ? opportunity.Amount : 0
                }));
            })
            .catch(error => {
                console.error('Error fetching opportunities:', error);
            });
    }

    handleEditClick(event) {
        const opportunityId = event.target.dataset.opportunityId;
        this.opportunities = this.opportunities.map(opportunity => ({
            ...opportunity,
            editMode: opportunity.Id === opportunityId  
        }));
    }

    handleCancelClick(event) {
        const opportunityId = event.target.dataset.opportunityId;
        this.opportunities = this.opportunities.map(opportunity => ({
            ...opportunity,
            editMode: opportunity.Id === opportunityId ? false : opportunity.editMode
        }));
    }

    handleUpdateSuccess(event) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: 'Opportunity updated successfully',
                variant: 'success'
            })
        );
        this.fetchOpportunities(); 
    }

    handleUpdateError(event) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error',
                message: 'Error updating opportunity',
                variant: 'error'
            })
        );
    }
}