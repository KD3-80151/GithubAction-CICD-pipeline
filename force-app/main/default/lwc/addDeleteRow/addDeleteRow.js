import { LightningElement, track } from 'lwc';

export default class AddDeleteRow extends LightningElement {
    @track rows = [
        { id: 1, name: '' }
    ];
    rowCount = 1;

    addRow() {
        this.rowCount++;
        this.rows = [...this.rows, { id: this.rowCount, name: '' }];
    }

    removeRow(event) {
        const index = event.target.dataset.index;
        this.rows = this.rows.filter((_, i) => i !== parseInt(index));
    }

    handleInputChange(event) {
        const index = event.target.dataset.index;
        const value = event.target.value;
        this.rows[index].name = value;
    }
}