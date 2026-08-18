import { LightningElement, wire, track } from 'lwc';
import getOpportunitiesWithLineItemsForTab from '@salesforce/apex/DynamicRelatedListInlineEditing.getOpportunitiesWithLineItemsForTab';
import updateOppLi from '@salesforce/apex/DynamicRelatedListInlineEditing.updateOppLi';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class DynamicRelatedListInlineEditing extends LightningElement {

    @track opportunities = [];         
    @track visibleOpportunities = []; 

    wiredResult;
    globalSaving = false;
    currentPage = 1;
    pageSize = 3;       
    totalOppRecords = 0;

    columns = [
        { label: 'Product Name', fieldName: 'productName', type: 'text' },
        { label: 'Quantity', fieldName: 'Quantity', type: 'number', editable: true },
        { label: 'Unit Price', fieldName: 'UnitPrice', type: 'currency', editable: true },
        { label: 'Total Price', fieldName: 'TotalPrice', type: 'currency' }
    ];

    @wire(getOpportunitiesWithLineItemsForTab)
    wiredOpps(result) {
        this.wiredResult = result;
        const { data, error } = result; //is just JavaScript destructuring 
        //result is an object with data and error properties
        if (data) { //data may be an array or an object depending on Apex. Always check (Array.isArray(data) or check for data && data.length).
            
            
            const oppArray = Array.isArray(data) ? data : [data]; //if data is an object, convert it to an array
            
            this.opportunities = oppArray.map(opp => {

                const lineItems = Array.isArray(opp.lineItems ? opp.lineItems : []);
                console.log('lineItems::>>>', lineItems);

                const lineItemsToDisplay = lineItems.map(li => {
                    return {
                        ...li,
                        productName: li.PricebookEntry ? li.PricebookEntry.Name : ''
                    };
                    });

                return {
                    oppId: opp.oppId,
                    name: opp.name,
                    stageName: opp.stageName,
                    amount: opp.amount,
                    closeDate: opp.closeDate,
                    lineItems: lineItemsToDisplay,
                    draftValues: [],
                    isLoading: false
                };
            });

            this.totalOppRecords = this.opportunities.length;
            this.currentPage = 1;
            this.setVisibleOpportunities();
        } else if (error) {
            console.error('Error loading opportunities', error);
            this.showToast('Error', 'Error loading opportunities', 'error');
        }
    }

    setVisibleOpportunities() {
        const startIndex = (this.currentPage - 1) * this.pageSize;
        const endIndex = startIndex + this.pageSize;
        this.visibleOpportunities = this.opportunities.slice(startIndex, endIndex);
    }

    handleNextPage() {
        const totalPages = Math.ceil((this.totalOppRecords || 0) / this.pageSize) || 1;
        if (this.currentPage < totalPages) {
            this.currentPage++;
            this.setVisibleOpportunities();
        }
    }

    handlePreviousPage() {
        if (this.currentPage > 1) {
            this.currentPage--;
            this.setVisibleOpportunities();
        }
    }

    get isPrevDisabled() {
        return this.currentPage === 1;
    }

    get isNextDisabled() {
        const totalPages = Math.ceil((this.totalOppRecords || 0) / this.pageSize) || 1;
        return this.currentPage >= totalPages;
    }

    getOppIndexById(oppId) {
        return this.opportunities.findIndex(o => o.oppId === oppId);
    }

    updateOppInArrays(updatedOpp) {
        const idx = this.getOppIndexById(updatedOpp.oppId);
        if (idx !== -1) {
            const all = [...this.opportunities];
            all[idx] = { ...updatedOpp };
            this.opportunities = all;
        }

        this.setVisibleOpportunities();
    }

    async handleSave(event) {
        const oppId = event.target.dataset.id;
        const idx = this.getOppIndexById(oppId);
        if (idx === -1) return;

        const opp = { ...this.opportunities[idx] };
        const draft = event.detail.draftValues || [];

        if (!draft.length) {
            return;
        }

        this.globalSaving = true;
        opp.isLoading = true;
        this.updateOppInArrays(opp);

        const updatedFields = draft.map(d => {
            return {
                Id: d.Id,
                Quantity: d.Quantity,
                UnitPrice: d.UnitPrice
            };
        });

        try {
            await updateOppLi({ updateProducts: updatedFields });

            this.showToast('Success', 'Products updated successfully', 'success');

            opp.draftValues = [];
            this.updateOppInArrays(opp);

            await refreshApex(this.wiredResult);

        } catch (error) {
            console.error('Error updating products', error);
            this.showToast(
                'Error updating products',
                error?.body?.message || 'Unknown error',
                'error'
            );
        } finally {
            this.globalSaving = false;
            opp.isLoading = false;
            this.updateOppInArrays(opp);
        }
    }

    showToast(title, message, variant) {
        this.dispatchEvent(
            new ShowToastEvent({
                title,
                message,
                variant
            })
        );
    }

    get hasOpportunities() {
        return this.visibleOpportunities && this.visibleOpportunities.length > 0;
    }
}