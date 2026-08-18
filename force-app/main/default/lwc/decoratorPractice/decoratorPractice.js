import { LightningElement } from 'lwc';

export default class DecoratorPractice extends LightningElement {
        name;
        email;
        phone;
    handleClick(){
        
        var loop = this.template.querySelectorAll('lightning-input');
        loop.forEach(function(element) {
            //alert(element.name);
            //alert(element.value);
            if (element.name=='name') {
                this.name = element.value;
            } else if(element.name =='email'){
                this.email = element.value;
            }
            else if(element.name =='phone'){
                this.phone = element.value;
            }
        }, this)

        alert('Name is ' + this.name + 'Email is '+this.email +'Phone is '+ this.phone);
    }
}