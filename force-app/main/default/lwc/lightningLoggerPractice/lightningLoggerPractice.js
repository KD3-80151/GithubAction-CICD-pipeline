import { LightningElement } from 'lwc';
import { log } from 'lightning/logger';
import lightningAlert from 'lightning/alert';

export default class LightningLoggerPractice extends LightningElement {

    //!implemented log function in two methods. 
    //!One is from the connected callback to track number of times of the page load and 
    //!other one is from handleSuccess() to track number of times submit button clicked. 
    connectedCallback(){
        let msg = {
            type: 'componentLoad',
            action: ':Load'
        }
        log(msg);
    }

    handleSuccess(){
        let msg = {
            type: 'click',
            action: 'Submit'
        }

        log(msg);

        lightningAlert({
            message: 'Success!!!',
            theme: 'success',
            label: 'Success'

        });


    }
}