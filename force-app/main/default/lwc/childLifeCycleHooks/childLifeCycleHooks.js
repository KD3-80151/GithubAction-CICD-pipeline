import { LightningElement } from 'lwc';

export default class ChildLifeCycleHooks extends LightningElement {
    constructor(){
        super();
        debugger;
        console.log('Child Constructor');
    }

    connectedCallback(){
        debugger;
        console.log('Child Connected Callback');
    }

    renderedCallback(){
        debugger;
        console.log('Child Rendered Callback');
    }

    disconnectedCallback(){
        debugger;
        console.log('Child Disconnected Callback');
    }


}