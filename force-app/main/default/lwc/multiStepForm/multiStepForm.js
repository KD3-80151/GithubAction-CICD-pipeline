import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class MultiStepForm extends LightningElement {
    @track step = 1;

    @track firstName = '';
    @track lastName = '';
    @track email = '';
    @track phone = '';

    get isStep1() {
        return this.step === 1;
    }

    get isStep2() {
        return this.step === 2;
    }

    get isStep3() {
        return this.step === 3;
    }

    get nextLabel() {
        return this.step === 3 ? 'Submit' : 'Next';
    }

    get step1Class() {
        return `slds-progress__item ${this.step >= 1 ? 'slds-is-active' : ''}`;
    }

    get step2Class() {
        return `slds-progress__item ${this.step >= 2 ? 'slds-is-active' : ''}`;
    }

    get step3Class() {
        return `slds-progress__item ${this.step >= 3 ? 'slds-is-active' : ''}`;
    }

    handleChange(event) {
        const field = event.target.dataset.id;
        this[field] = event.target.value;
    }

    handleNext() {
        if (this.step < 3) {
            if (this.validateInputs()) {
                this.step++;
            }
        } else {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success!',
                    message: 'Form submitted successfully.',
                    variant: 'success'
                })
            );
            this.resetForm();
        }
    }

    handlePrevious() {
        if (this.step > 1) {
            this.step--;
        }
    }

    validateInputs() {
        let valid = true;
        this.template.querySelectorAll('lightning-input').forEach(input => {
            if (!input.checkValidity()) {
                input.reportValidity();
                valid = false;
            }
        });
        return valid;
    }

    resetForm() {
        this.step = 1;
        this.firstName = '';
        this.lastName = '';
        this.email = '';
        this.phone = '';
    }
}