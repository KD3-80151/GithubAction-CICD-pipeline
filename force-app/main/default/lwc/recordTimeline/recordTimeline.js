import { LightningElement, api, wire, track } from 'lwc';
import getCaseHistory from '@salesforce/apex/CaseTimelineController.getCaseHistory';

export default class RecordTimeline extends LightningElement {
    @api recordId;
    @track timeline;
    error;

    @wire(getCaseHistory, { caseId: '$recordId' })
    wiredTimeline({ data, error }) {
        if (data) {
            this.timeline = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.timeline = undefined;
        }
    }
}