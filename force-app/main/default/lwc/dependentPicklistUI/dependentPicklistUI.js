import { LightningElement, track, wire } from 'lwc';
import { getObjectInfo, getPicklistValuesByRecordType } from 'lightning/uiObjectInfoApi';
import ACCOUNT_OBJECT from '@salesforce/schema/Account'; 

export default class DependentPicklistUI extends LightningElement {
    @track ratingOption = [];
    @track slaOption = [];

    selectedRating = '';
    selectedSla = '';

    allSlaValues = {};

    @wire(getObjectInfo, { objectApiName: ACCOUNT_OBJECT })
    objectInfo;

    @wire(getPicklistValuesByRecordType, {
        objectApiName: ACCOUNT_OBJECT,
        recordTypeId: '$objectInfo.data.defaultRecordTypeId'
    })
    picklistValues({ data, error }) {
        if (data) {
            this.ratingOption = data.picklistFieldValues.Rating.values;

            this.allSlaValues = data.picklistFieldValues.SLA__c.controllerValues;
            this.allSlaRaw = data.picklistFieldValues.SLA__c.values;
        } else if (error) {
            console.error('Error fetching picklist values: ', error);
        }
    }

    handleRatingChange(event) {
        this.selectedRating = event.detail.value;
        this.selectedSla = '';

        const key = this.ratingOption.find(c => c.value === this.selectedRating)?.value;
        const controllingKey = this.allSlaValues[key];

        this.slaOption = this.allSlaRaw
            .filter(sla => sla.validFor.includes(controllingKey))
            .map(option => ({ label: option.label, value: option.value }));
    }

    handleSlaChange(event) {
        this.selectedSla = event.detail.value;
    }

    get isSlaDisabled() {
        return !this.slaOption || this.slaOption.length === 0;
    }
    

}