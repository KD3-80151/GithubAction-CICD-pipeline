import { LightningElement, api } from 'lwc';

export default class LifecycleDemo extends LightningElement {
    
    constructor(){
        super();
        debugger;
        console.log('Constructor');
    }

    connectedCallback(){
        debugger;
        console.log('Connected Callback');
    }

    renderedCallback(){
        debugger;
        console.log('Rendered Callback');
    }

    disconnectedCallback(){
        debugger;
        console.log('Disconnected Callback');
    }

    @api
    doSomething(){
        debugger;
        console.log('Do Something');
    }

    //error callcback is always written on the parent side 
    errorCallback(error){
        debugger;
        console.log('Error Callback');
    }

    isVisible = true;

    handleClick(){
        if(this.isVisible == true){
            this.isVisible = false;
        }
        else{
            this.isVisible = true;
        }
    }

}