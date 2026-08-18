import { LightningElement, wire, track } from 'lwc';
import search from '@salesforce/apex/AccountController.searchAccounts';
import getOpportunitiesByAccountId from '@salesforce/apex/AccountController.getOpportunitiesByAccountId';
import getTaskByAccountId from '@salesforce/apex/AccountController.getTaskByAccountId';
import updateTask from '@salesforce/apex/AccountController.updateTask';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class AccountRelatedTasks extends LightningElement {
    @track accountOpt = [];
    @track selectedAccountId;
    @track opportunities;
    @track searchKey = '';
    @track showingOpportunities = true;
    @track showingTasks = false;
    @track tasks;

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

    handleAccountChange(event, fetchType) {
        this.selectedAccountId = event.detail.value;
        if (fetchType === 'opportunities') {
            this.fetchOpportunities();
        } else if (fetchType === 'tasks') {
            this.fetchTasks();
        }
    }

    handleAccountChangeForOpportunities(event) {
        this.handleAccountChange(event, 'opportunities');
    }

    handleAccountChangeForTasks(event) {
        this.handleAccountChange(event, 'tasks');
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

    fetchTasks() {
        debugger;
        getTaskByAccountId({ accountId: this.selectedAccountId })
            .then(result => {
                this.tasks = result.map(task => ({
                    ...task
                }),console.log(task));
            })
            
            .catch(error => {
                console.error('Error fetching tasks:', error);
            });
            console.log(result);
    }

    handleEditClick(event) {
        const opportunityId = event.target.dataset.opportunityId;
        this.opportunities = this.opportunities.map(opportunity => ({
            ...opportunity,
            editMode: opportunity.Id === opportunityId  
        }));
    }

    handleEditTaskClick(event) {
        const taskId = event.target.dataset.taskId;
        this.tasks = this.tasks.map(task => ({
            ...task,
            editMode: task.Id === taskId  
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

    handleUpdateTaskSuccess(event) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: 'Task updated successfully',
                variant: 'success'
            })
        );
        this.fetchTasks(); 
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

    handleUpdateTaskError(event) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error',
                message: 'Error updating task',
                variant: 'error'
            })
        );
    }

    handleMarkComplete(event){
        const taskId = event.target.dataset.taskId;
        updateTask({ taskId, fields: { Status: 'Completed' } })
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Task marked as complete',
                        variant: 'success'
                    }) 
                );
                this.fetchTasks();
            })
            .catch(error => {
                console.error('Error marking task as complete:', error);
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: 'Error marking task as complete',
                        variant: 'error'
                    })
                );
            });
    }

    showOpportunities(){
        this.showingOpportunities = true;
        this.showingTasks = false;
    }

    showTasks() {
        this.showingOpportunities = false;
        this.showingTasks = true;
    }
}