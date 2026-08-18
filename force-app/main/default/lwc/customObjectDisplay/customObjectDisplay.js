import { LightningElement, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getCustomObjects from '@salesforce/apex/SchemaObject.getCustomObjects';

const COLUMNS = [
    { 
        label: 'Custom Object Label', 
        fieldName: 'label', 
        type: 'button', 
        typeAttributes: { 
            label: { fieldName: 'label' }, 
            name: 'view', 
            variant: 'base',
            data: { value: 'view' }
        } 
    },
    { 
        label: 'View Fields and Relationships', 
        type: 'button', 
        typeAttributes: { 
            label: 'View', 
            name: 'view_fields', 
            variant: 'base',
            data: { value: 'view_fields' }
        } 
    }
];

export default class CustomObjectDisplay extends NavigationMixin(LightningElement) {
    
    columns = COLUMNS;
    customObjects;

    @wire(getCustomObjects)
    wiredCustomObjects({ error, data }) {
        if (data) {
            this.customObjects = data;
        } else if (error) {
            console.error('Error fetching custom objects:', error);
        }
    }

    handleRowAction(event) {
        const apiName = event.detail.row.apiName;
        const action = event.detail.action.data.value;

        if (action === 'view') {
            this[NavigationMixin.Navigate]({
                type: 'standard__objectPage',
                attributes: {
                    objectApiName: apiName,
                    actionName: 'home'
                }
            });
        } else if (action === 'view_fields') {
            this.navigateToObjectManager(apiName);
        }
    }

    navigateToObjectManager(apiName) {
        const objectManagerUrl = `/lightning/setup/ObjectManager/home?objectApiName=${apiName}`;

        window.open(objectManagerUrl, '_blank');
    }
}