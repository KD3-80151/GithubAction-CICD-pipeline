import { LightningElement } from 'lwc';
import styles from './style.css';

export default class BasicCalc extends LightningElement {
    number1 = 0;
    number2 = 0;
    result = 0;

    handleNumber1Change(event) {
        this.number1 = parseFloat(event.target.value);
    }

    handleNumber2Change(event) {
        this.number2 = parseFloat(event.target.value);
    }

    debugger;
    handleSum() {
        this.result = `Sum: ${this.number1 + this.number2}`;
        console.log(result);
    }
    handleSubtract() {
        this.result = `Sub: ${this.number1 - this.number2}`;
        
    }

    handleMultiply() {
        this.result = `Multiply: ${this.number1 * this.number2}`;
        
    }

    handleDivide() {
        if (this.number2 !== 0) {
            this.result = `Divide: ${this.number1 / this.number2}`;
            
        } else {
            this.result = 'Division by zero is not allowed';
        }
    }
}