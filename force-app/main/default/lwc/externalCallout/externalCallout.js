import { LightningElement, track } from 'lwc';
import getExternalData from '@salesforce/apex/ExternalAPIController.getExternalData';

export default class ExternalCallout extends LightningElement {
    @track responseData;

    handleFetch() {
        getExternalData()
            .then(result => {
                this.responseData = result;
            })
            .catch(error => {
                this.responseData = 'Error: ' + JSON.stringify(error);
            });
    }
}