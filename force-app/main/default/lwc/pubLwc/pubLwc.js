import { LightningElement, wire } from 'lwc';
import { publish, MessageContext } from 'lightning/messageService';
import COUNTING_UPDATED_CHANNEL from '@salesforce/messageChannel/Count_Update__c';

export default class PubLwc extends LightningElement {
    @wire(MessageContext)
    messageContext; // any value come from MessageContext pass here

    handleIncrement(){
        const payload= {
            operator:'add', 
            constant: 1,
            testFieldName : 'test'
        };
        
        publish(this.messageContext, COUNTING_UPDATED_CHANNEL, payload);
    }

    handleDecrement(){
        const payload= {
            operator:'sub', 
            constant: 1
        };

        publish(this.messageContext, COUNTING_UPDATED_CHANNEL, payload);
    }

    handleMultiply(){
        const payload= {
            operator:'mul', 
            constant: 2
        };

        publish(this.messageContext, COUNTING_UPDATED_CHANNEL, payload);
    }
}