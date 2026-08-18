import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class RecordNavigator extends NavigationMixin(LightningElement) {
    @api recordId;
    @api objectApiName;
    @api mode = 'view'; 

    navigateToRecord() {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.recordId,
                objectApiName: this.objectApiName,
                actionName: this.mode
            }
        });
    }

    handleClick() {
        this.navigateToRecord();
    }
}