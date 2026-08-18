import { LightningElement } from 'lwc';

export default class DisplayFullName extends LightningElement {

    firstName = 'Sagar';
    lastName = 'Kumar';
    priority = 9;
    hours;

    get fullName() {
        return `${this.firstName} ${this.lastName}`;
    }

    get priorityLabel() {
        return this.priority > 8 ? 'Critical' : 'High';
    }

    get hoursDisplay() {
        return this.hours ?? 'No hours logged';
    }

    get badgeClass() {
        return this.priority > 8 ? 'badge-critical' : 'badge-normal';
    }
}