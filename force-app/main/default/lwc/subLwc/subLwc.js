import { LightningElement, wire } from 'lwc';
import { subscribe, MessageContext } from 'lightning/messageService';
import COUNTING_UPDATED_CHANNEL from '@salesforce/messageChannel/Count_Update__c';


export default class SubLwc extends LightningElement {
    counter =0;
    subscription =null;

    @wire(MessageContext)
    messageContext;

    connectedCallback(){
        this.subscribeToMessageChannel();// check whether subscription is null or not
        //if null then call subscribe method and assign it to subscription


    }

    subscribeToMessageChannel(){
        this.subscription = subscribe(
            this.messageContext,
            COUNTING_UPDATED_CHANNEL, 
            //below messsage come from publish controller
            /* message is get here*/ (message)=> this.handleMessage(message) //the message is passed here
        );
    }

    handleMessage(message){ //message is recived here 
       // alert("message:::::"+ JSON.stringify(message));

       if(message.operator == 'add'){
        this.counter += message.constant;
       }

       else if(message.operator == 'sub'){
        this.counter -= message.constant;
       }
        else if(message.operator == 'mul'){
        this.counter *= message.constant;
       }

    }



}