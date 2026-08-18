import { LightningElement, track } from 'lwc';

export default class DragDropList extends LightningElement {
    @track items = [
        { id: '1', name: 'Item One' },
        { id: '2', name: 'Item Two' },
        { id: '3', name: 'Item Three' }
    ];

    draggedItemId;

    handleDragStart(event) {
        this.draggedItemId = event.target.dataset.id;
    }

    handleDragOver(event) {
        event.preventDefault(); // Required to allow drop
    }

    handleDrop(event) {
        event.preventDefault();

        const droppedId = event.target.dataset.id;

        if (this.draggedItemId === droppedId) return;

        const draggedIndex = this.items.findIndex(item => item.id === this.draggedItemId);
        const droppedIndex = this.items.findIndex(item => item.id === droppedId);

        const reordered = [...this.items];
        const [movedItem] = reordered.splice(draggedIndex, 1);
        reordered.splice(droppedIndex, 0, movedItem);

        this.items = reordered;
    }
}