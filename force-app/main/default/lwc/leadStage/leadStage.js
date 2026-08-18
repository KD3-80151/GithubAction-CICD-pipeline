import { LightningElement, wire, track } from 'lwc';
import getLeads from '@salesforce/apex/LeadController.getLeads';

export default class LeadStage extends LightningElement {
    @track leads;
    @track error;

    @wire(getLeads)
    wiredLeads({ error, data }) {
        if (data) {
            this.leads = data.map((lead, index) => {
                return {
                    ...lead,
                    serialNumber: index + 1,
                    stageClass: this.getStageClass(lead.Status)
                };
            });
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.leads = undefined;
        }
    }

    getStageClass(stage) {
        switch (stage) {
            case 'New':
                return 'stage-new';
            case 'Active':
                return 'stage-active';
            case 'Working - Contacted':
                return 'stage-junk';
            case 'Closed - Converted':
                return 'stage-converted';
            default:
                return '';
        }
    }
}

//use lightning datatable and enable inline update using lightning record form
//loader - spinner
// inline