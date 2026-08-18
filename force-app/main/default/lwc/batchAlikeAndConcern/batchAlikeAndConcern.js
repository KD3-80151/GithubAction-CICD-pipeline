import { LightningElement, track, wire } from 'lwc';
import fetchClaims from '@salesforce/apex/BatchAlike.fetchClaims';
import { getObjectInfo, getPicklistValues } from 'lightning/uiObjectInfoApi';
import BATCH_OBJECT from '@salesforce/schema/Batch__c';
import { refreshApex } from '@salesforce/apex';
import PICKLIST_AOC from '@salesforce/schema/Batch__c.A__c';
import PICKLIST_MOT from '@salesforce/schema/Batch__c.Mode_of_transport__c';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

// use of platform event 
//use of address of consignee more picklist used 
//check do we need to create batch date 
//use custom lookup 
export default class BatchAlikeAndConcern extends LightningElement {

    closeModal() {
        this.close('close');
    }
    @track batchAmount = 0;
    
    @track today = new Date().toISOString().split('T')[0];

    TOD =''; AOC =''; RN =''; VN =''; HPS =''; Phone =''; POS =''; TN =''; TID =''; Eway =''; MOT ='';
    picklistValuesAOC = [];
    picklistValuesMOT = [];

    @track selectedClaims = []; // to manage selected claim records
    @track preSelectedRowIds = []; // to check which id is selected in claims table
    @track showModal = false;
    @track claims =[];

    columns = [
        { label: 'Claim Name' , fieldName: 'Name'},
        { label: 'Claim Amount', fieldName: 'Total_Claim_Amount__c', type: 'currency' , cellAttributes: { alignment: 'left'}}
    ];

    selectedClaimsColumns = [
        { label: 'Claim Name', fieldName: 'Name' },
        { label: 'Total Claim Amount', fieldName: 'Total_Claim_Amount__c', type: 'currency', cellAttributes: { alignment: 'left'} },
        { 
            type: 'button',
            typeAttributes: {
                label: 'Remove',
                name: 'remove',
                variant: 'destruvtive'
            }
        }
    ];

    @wire(fetchClaims)
    wiredClaims(result){
        debugger;
        if(result.data){
            this.claims = result.data;
            console.log('claims' ,this.claims);
        }
        else if (result.error){
            this.showToast('Error' + `Error fetching claims: ${result.error.body.message}`, 'error');
        }
    }


    @wire(getObjectInfo, { objectApiName: BATCH_OBJECT})
    objectInfo;

   @wire(getPicklistValues, {
        recordTypeId: '$objectInfo.data.defaultRecordTypeId',
        fieldApiName: PICKLIST_AOC
    })
    getPicklistValuesforAOC({ data, error }) {
        if (data) {
            this.picklistValuesAOC = data.values;
        } else if (error) {
            console.error('Error fetching AOC picklist:', error);
        }
    }

    @wire(getPicklistValues, {
        recordTypeId: '$objectInfo.data.defaultRecordTypeId',
        fieldApiName: PICKLIST_MOT
    })
    getPicklistforMOT({data, error}){
        if(data){
            this.picklistValuesMOT = data.values;
        }
        else if(error){
            console.log('error fetching mot picklist' , error);
        }
    }

    handleAddWarrantyClaims(){
        this.preSelectedRowIds = this.selectedClaims.map(row => row.Id);
        this.showModal = true;
    }

    handleHPS(event){
        this.HPS = event.target.value;
    }

    handlePicklistTransport(event){
        this.MOT = event.target.value;
    }

    handleRequestorName(event){
        this.RN = event.target.value;
    }

    handlePicklistChangeAOC(event){
        this.AOC = event.target.value;
        if(this.Phone.length!==10){
            this.Phone ='';
        }
    }

    handlePhone(event){
        this.Phone = event.target.value.replace(/\D/g,'');
    }

    restrictNonNumeric(event) {
        const allowedKeys = ['Backspace', 'ArrowLeft', 'ArrowRight', 'Delete', 'Tab'];
        const key = event.key;

        if (!/^\d$/.test(key) && !allowedKeys.includes(key)) {
            event.preventDefault();
        }
    }


    handleRowSelection(){
        debugger;
        const selectedRows = event.detail.selectedRows;
        this.preSelectedRowIds = selectedRows.map(row => row.Id);
    }

    handleRowAction(event){
        const actionName = event.detail.action.name;
    }

    handleSelect(){
        debugger;
        const selectedRows = this.preSelectedRowIds;
        this.selectedClaims = this.claims.filter(claim => selectedRows.includes(claim.Id)); // check what this line is doing 
        this.showModal = false;
    }

    handleModalClose(){
        this.showModal = false;
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title,
            message,
            variant
        });
        this.dispatchEvent(event);
    }

}