import { LightningElement, track } from 'lwc';
import getCase from '@salesforce/apex/CaseController.getCase';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class UpdateCase extends LightningElement {
    @track caseId = '';
    @track caseFound = false;
    @track errorMessage = '';
    @track isLoading = false;

    handleCaseIdChange(event) {
        this.caseId = event.target.value;
    }

    handleSearch() {
        this.isLoading = true;
        this.caseFound = false;
        this.errorMessage = '';

        getCase({ caseId: this.caseId })
            .then(result => {
                if (result) {
                    this.caseFound = true;
                } else {
                    this.errorMessage = 'Case not found.';
                }
                this.isLoading = false;
            })
            .catch(error => {
                this.errorMessage = 'Error retrieving case: ' + error.body.message;
                this.isLoading = false;
            });
    }


    handleUpdateSuccess(event) {
        this.isLoading = false;
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: 'Case updated successfully',
                variant: 'success'
            })
        );
    

}
}