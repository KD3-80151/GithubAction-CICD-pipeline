import { LightningElement, track } from 'lwc';

export default class TestTrackProperties extends LightningElement {
    @track obj = {
        name : 'sagar',
    };
    obj1 = {
        name1 : 'Sagar1'
    }

    changeName(){
        this.obj.name = 'Sagar2';
        this.obj1.name1 = 'Sagar21';
    }

}