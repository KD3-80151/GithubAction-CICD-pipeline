import { LightningElement, track, wire } from 'lwc';
import getCustomObject from '@salesforce/apex/GetCustomObject.getCustomObject';
import getFields from '@salesforce/apex/GetCustomObject.getFields';
import getRecords from '@salesforce/apex/GetCustomObject.getRecords';

export default class GetCustomObject extends LightningElement {
    @track objectList = [];
    @track fieldList = [];
    @track selectedObject = '';
    @track selectedFields = [];
    @track records = [];
    @track columns = [];
    
    @wire(getCustomObject)
    wiredCustomObjects({ error, data }) {
        debugger;
        if (data) {
            this.objectList = data.map(obj => ({
                label: obj.label,
                value: obj.apiName
            }));
        } else if (error) {
            console.error('Error fetching custom objects:', error);
        }
    }

    handleObjectChange(event) {
        debugger;
        this.selectedObject = event.detail.value;
        this.selectedFields = [];
        this.fieldList = [];
        this.records = [];
        this.columns = [];
        this.fetchFields(this.selectedObject);
    }

    handleFieldChange(event) {
        debugger;
        this.selectedFields = event.detail.value;
    }

    handleGetDetails() {
        debugger;
        if (this.selectedObject && this.selectedFields.length > 0) {
            console.log('Fetching records for:', this.selectedObject, this.selectedFields);
            this.fetchRecords(this.selectedObject, this.selectedFields);
            this.selectedFields = [];
        }
    }

    fetchFields(objectName) {
        debugger;
        getFields({ objectName })
            .then(result => {
                this.fieldList = result.map(field => ({
                    label: `${field.label} (${field.type})`,
                    value: field.apiName
                }));
            })
            .catch(error => {
                console.error('Error fetching fields:', error);
            });
    }

    fetchRecords(objectName, fieldNames) {
        debugger;
        getRecords({ objectName, fieldNames })
            .then(result => {
                this.records = result;
                this.columns = fieldNames.map(field => {
                    const fieldInfo = this.fieldList.find(f => f.value === field);
                    return {
                        label: fieldInfo.label,
                        fieldName: field,
                        type: 'text'
                    };
                });
            })
            .catch(error => {
                console.error('Error fetching records:', error);
            });
    }
}