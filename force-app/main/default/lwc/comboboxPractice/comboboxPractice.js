import getAccountLwc from '@salesforce/apex/AccountController.getAccountLwc';
import { LightningElement, track } from 'lwc';

export default class ComboboxPractice extends LightningElement {
    
    value='';
    accOptions=[];
    
    get options(){
        return this.accOptions;
    }

    connectedCallback(){
        getAccountLwc()
        .then(data=>{
            let arr=[];
            for(var i=0; i<data.length; i++){
                arr.push({label: data[i].Name, value: data[i].Id })
            }
            this.accOptions= arr;
        });

    }

    handleOnchange(event){
        this.value = event.detail.value;
    }


}