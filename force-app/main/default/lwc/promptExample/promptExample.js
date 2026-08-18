import { LightningElement } from 'lwc';
import LightningPrompt from 'lightning/prompt';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class PromptExample extends LightningElement {
//mpt is a modal-style popup that allows you to ask for user input — like text — before performing an action.
//It’s similar to window.prompt() in JavaScript but styled with Lightning Design System (SLDS) and built using 
// LightningPrompt from the lightning/prompt module.
    async handleShowPrompt() {
        try {
            const result = await LightningPrompt.open({
                message: 'Please enter a reason for updating this record:',
                theme: 'default', // 'default', 'shade', 'error', 'success'
                label: 'Update Confirmation', // Header text
                defaultValue: 'N/A' // Optional prefilled text
            });

            if (result !== null) {
                this.showToast('Reason Submitted', `Reason: ${result}`, 'success');
            } else {
                this.showToast('Cancelled', 'User cancelled the prompt', 'info');
            }

        } catch (error) {
            this.showToast('Error', error.message, 'error');
        }
    }

    showToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
    }
}