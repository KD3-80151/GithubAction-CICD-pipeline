import { LightningElement, wire, track } from 'lwc';
import { getPicklistValues, getObjectInfo } from 'lightning/uiObjectInfoApi';
import LEAD_OBJECT from '@salesforce/schema/Lead';
import LEAD_SOURCE_FIELD from '@salesforce/schema/Lead.LeadSource';

export default class PicklistDynamic extends LightningElement {
    @track picklistValues = [];
    @track selectedValue;
    @track error;

    @wire(getObjectInfo, { objectApiName: LEAD_OBJECT })
    objectInfo;

    @wire(getPicklistValues, {
        recordTypeId: '$objectInfo.data.defaultRecordTypeId',
        fieldApiName: LEAD_SOURCE_FIELD
    })
    wiredPicklist({ error, data }) {
        if (data) {
            this.picklistValues = data.values.map(option => ({
                label: option.label,
                value: option.value
            }));
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.picklistValues = [];
        }
    }

    handleChange(event) {
        this.selectedValue = event.detail.value;
    }
}