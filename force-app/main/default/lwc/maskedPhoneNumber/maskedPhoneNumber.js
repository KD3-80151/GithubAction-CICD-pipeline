import { api, LightningElement, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';

const FIELDS = ['Lead.Phone'];

export default class MaskedPhoneNumber extends LightningElement {
    @api recordId; // Record ID passed from the lead record page
    phone; // Holds the phone number from the Lead record

    // Fetch the phone number from the record
    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    wiredRecord({ error, data }) {
        if (data) {
            this.phone = data.fields.Phone.value;
        } else if (error) {
            console.error(error);
        }
    }

    // Getter for displaying the masked phone number
    get displayPhone() {
        if (this.phone && this.phone.length === 10) {
            return 'xxxx-xxxx' + this.phone.slice(-4);
        }
        return this.phone;
    }

    handleMouseOver(event) {
        event.target.value = this.phone; // Show full phone number on hover
    }

    handleMouseOut(event) {
        event.target.value = this.displayPhone; // Revert to masked format on mouse out
    }

    handleClick(event) {
        event.target.value = this.phone; // Show full phone number on click
    }
}