import { LightningElement, track } from 'lwc';

export default class CustomValidation extends LightningElement {
    @track name = '';
    @track email = '';
    @track nameError = '';
    @track emailError = '';

    handleInputChange(event) {
        const { name, value } = event.target;
        this[name] = value;
        if (name === 'name') {
            this.nameError = '';
        } else if (name === 'email') {
            this.emailError = '';
        }
    }

    validateName() {
        const regex = /^[a-zA-Z\s]*$/;
        if (!regex.test(this.name)) {
            this.nameError = 'Name must contain only letters and spaces.';
        }
    }

    validateEmail() {
        const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!regex.test(this.email)) {
            this.emailError = 'Please enter a valid email address.';
        }
    }
}