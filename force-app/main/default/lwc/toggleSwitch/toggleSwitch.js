import { LightningElement, track } from 'lwc';

export default class ToggleSwitch extends LightningElement {
    @track isToggled = false;

    get toggleLabel() {
        return this.isToggled ? 'ON' : 'OFF';
    }

    handleToggle(event) {
        this.isToggled = event.target.checked;
    }
}