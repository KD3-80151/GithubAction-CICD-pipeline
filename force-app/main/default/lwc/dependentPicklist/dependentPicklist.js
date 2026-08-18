import getAllObjects from '@salesforce/apex/CommonMethods.getAllObjects';
import getPicklistTypeFields from '@salesforce/apex/PicklistController.getPicklistTypeFields';
import getPickListvaluesByFieldName from '@salesforce/apex/PicklistController.getPickListvaluesByFieldName';
import { LightningElement, track } from 'lwc';

export default class DependentPicklist extends LightningElement {
    @track objectList = [];
    objectName = '';
    @track lstOfPicklistFields = [];
    @track objectFieldOptionsList = [];
    @track picklistFieldsLabel = '';
    fieldSelectedToGetPicklistTypeField = '';

    connectedCallback() {
        this.loadObjects();
    }

    loadObjects() {
        debugger;
        getAllObjects()
            .then((result) => {
                if (result) {
                    this.objectList = [];
                    for (let key in result) {
                        this.objectList.push({ label: result[key], value: key });
                    }
                } else {
                    console.error('Error in getting object');
                }
            })
            .catch((error) => {
                console.error('Catch error in getting object', error);
            });
    }

    onObjectChange(event) {
        debugger;
        this.objectName = event.detail.value;
        console.log('Selected object:', this.objectName);
        
        this.picklistFieldsLabel = this.objectName + ' Picklist Fields';
        this.handleGetPicklistFields();
    }

    handleGetPicklistFields() {
        debugger;
        getPicklistTypeFields({ strObjectName: this.objectName })
            .then((result) => {
                this.lstOfPicklistFields = [];
                for (let key in result) {
                    this.lstOfPicklistFields.push({ label: key, value: key });
                }
            })
            .catch((error) => {
                console.error('Error in getting picklist fields', error);
            });
    }

    getPicklistFieldsOptions(event) {
        debugger;
        this.fieldSelectedToGetPicklistTypeField = event.detail.value;
        console.log('Selected field:', this.fieldSelectedToGetPicklistTypeField);

        this.getPicklistValuesForSelectedPicklistField();
    }

    getPicklistValuesForSelectedPicklistField() {
        debugger;
        getPickListvaluesByFieldName({ selectedObjectName: this.objectName, selectedField: this.fieldSelectedToGetPicklistTypeField })
            .then((result) => {
                if (result) {
                    this.objectFieldOptionsList = [];
                    for (let key in result) {
                        this.objectFieldOptionsList.push({ label: result[key], value: result[key] });
                    }
                    console.log('Picklist values:', this.objectFieldOptionsList); // Debugging statement
                } else {
                    console.error('No result from getPickListvaluesByFieldName');
                }
            })
            .catch((error) => {
                console.error('Error in getting picklist values', error);
            });
    }
}