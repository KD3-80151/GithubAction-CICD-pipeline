import { LightningElement, wire } from 'lwc';
import { getRecordUi } from 'lightning/uiRecordApi';
export default class LayoutExample extends LightningElement {

    uiRecordView;
    uiRecordEdit;

    @wire(getRecordUi, { recordIds: "$recordId", layoutTypes: "Full", modes: "View", })
    wiredRecordView({ error, data }) {
        debugger;
        if (data) {
            for (let layout of Object.values(data.layouts.User)) {
                this.uiRecordView = layout.Full.View;
                break;
            }
        }
        else {
            // TODO: Data handling
        }
    }

    @wire(getRecordUi, { recordIds: "$recordId", layoutTypes: "Full", modes: "Edit", })
    wiredRecordEdit({ error, data }) {
        debugger;
        if (data) {
            for (let layout of Object.values(data.layouts.User)) {
                this.uiRecordEdit = layout.Full.Edit;
                break;
            }
        }
        else {
            // TODO: Data handling
        }
    }

}