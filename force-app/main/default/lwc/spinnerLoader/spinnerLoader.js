import { LightningElement, track } from 'lwc';

export default class SpinnerLoader extends LightningElement {
    @track isLoading = false;
    @track isCompleted = false;

    handleProcess() {
        this.isLoading = true;
        this.isCompleted = false;

        setTimeout(() => {
            this.isLoading = false;
            this.isCompleted = true;
        }, 2000); 
    }
}