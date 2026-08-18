import { LightningElement, track } from 'lwc';

export default class CopyToClipboard extends LightningElement {
    @track copyText = 'Hello, Salesforce!';
    @track copied = false;

    handleInputChange(event) {
        this.copyText = event.target.value;
        this.copied = false;
    }

    copyTextToClipboard() {
        navigator.clipboard.writeText(this.copyText).then(() => {
            this.copied = true;
        }).catch(err => {
            console.error('Failed to copy: ', err);
        });
    }
}