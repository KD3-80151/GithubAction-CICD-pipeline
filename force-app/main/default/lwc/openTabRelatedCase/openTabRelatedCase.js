import { LightningElement, api, wire } from 'lwc';
import { getRelatedListRecords } from 'lightning/uiRelatedListApi';
import { NavigationMixin } from 'lightning/navigation';
import { EnclosingTabId, openSubtab, openTab } from 'lightning/platformWorkspaceApi';
const actions = [
    { label: 'New Tab', name: 'Newtab' },
    { label: 'Subtab', name: 'Subtab' }
];
const columns =  [   
    { label: 'Case Number', fieldName: 'CaseNumber' },
    { label: 'Subject', fieldName: 'Subject' },
    { label: 'Status', fieldName: 'Status' },
    {
        type: 'action',
        typeAttributes: { rowActions: actions }
    }
];

export default class OpenTabRelatedCase extends NavigationMixin( LightningElement ) {
    
    columns = columns;

    @api recordId;
    records;    

    @wire(EnclosingTabId) 
    enclosingTabId;

    @wire( getRelatedListRecords, {

        parentRecordId: '$recordId',
        relatedListId: 'Cases',
        fields: [ 
            'Case.Id', 
            'Case.CaseNumber', 
            'Case.Subject' , 
            'Case.Status' 
        ]

    } )listInfo( { error, data } ) {

        if ( data ) {

            console.log( 
                'Data is', 
                JSON.stringify( data ) 
            );
            let tempRecords = [];

            data.records.forEach( obj => {

                let tempRecord = {};
                tempRecord.Id = obj.fields.Id.value;
                tempRecord.CaseNumber = obj.fields.CaseNumber.value;
                tempRecord.Subject = obj.fields.Subject.value;
                tempRecord.Status = obj.fields.Status.value;
                tempRecords.push( tempRecord );

            } );

            this.records = tempRecords;
            
        } else if (error) {
            
            this.records = undefined;

        }
    }
    
    handleRowAction( event ) {

        const row = event.detail.row;
        const actionName = event.detail.action.name;             
        
        switch ( actionName ) {

            case 'Newtab': 
                openTab( {
                    pageReference: {
                        type: "standard__recordPage",
                        attributes: {
                            recordId: row.Id,
                            actionName: 'view'
                        }
                    }
                } );
                break;
            case 'Subtab':                
                if ( !this.enclosingTabId ) {
                    return;
                } 
                openSubtab( this.enclosingTabId, {
                    pageReference: {
                        type: "standard__recordPage",
                        attributes: {
                            recordId: row.Id,
                            actionName: 'view'
                        }
                    }
                } );
                break;
            default:

        }        

    }

}