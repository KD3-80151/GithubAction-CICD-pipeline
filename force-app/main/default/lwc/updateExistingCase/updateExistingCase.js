import { LightningElement, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import updateCase from '@salesforce/apex/CaseController.updateCase';
import getCase from '@salesforce/apex/CaseController.getCase';
import getStatusPicklistValues from '@salesforce/apex/CaseController.getStatusPicklistValues';

export default class UpdateExistingCase extends LightningElement {
    @track caseId;
    @track subject;
    @track description;
    @track status;
    @track caseLoaded = false;
    @track statusOptions = [];

    // Initialize toast variables
    toastVariant = 'success';
    toastTitle = 'Success';
    toastMessage = 'Case updated successfully';

    handleCaseIdChange(event) {
        this.caseId = event.target.value;
    }

    connectedCallback() {
        // Fetch picklist values for Status field from Apex controller on component initialization
        this.loadStatusOptions();
    }

    loadStatusOptions() {
        getStatusPicklistValues()
            .then(result => {
                // Map picklist values to format accepted by lightning-combobox
                this.statusOptions = result.map(opt => ({ label: opt, value: opt }));
            })
            .catch(error => {
                console.error('Error fetching status picklist values', error);
                // Optionally, handle error or display error message
            });
    }

    loadCase() {
        getCase({ caseId: this.caseId })
            .then(result => {
                this.subject = result.Subject;
                this.description = result.Description;
                this.status = result.Status;
                this.caseLoaded = true;
            })
            .catch(error => {
                console.error('Error fetching case', error);
                // Optionally, handle error or display error message
            });
    }

    handleSubjectChange(event) {
        this.subject = event.target.value;
    }

    handleDescriptionChange(event) {
        this.description = event.target.value;
    }

    handleStatusChange(event) {
        this.status = event.detail.value;
    }

    updateCase() {
        updateCase({ caseId: this.caseId, subject: this.subject, description: this.description, status: this.status })
            .then(result => {
                console.log('Result:', result);
                this.showToast(this.toastVariant, this.toastTitle, this.toastMessage);
                // Optionally, handle success or update UI
            })
            .catch(error => {
                console.error('Error updating case:', error);
                // Optionally, handle error or display error message
            });
    }

    showToast(variant, title, message) {
        const toastEvent = new ShowToastEvent({
            variant: variant,
            title: title,
            message: message,
        });
        this.dispatchEvent(toastEvent);
    }
}