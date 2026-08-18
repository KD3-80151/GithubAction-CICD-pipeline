import { LightningElement } from 'lwc';
import { getBarcodeScanner } from 'lightning/mobileCapabilities';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class Barcode_api_demo extends LightningElement {

    scannedBarcode = ''; 

    /**
     * When component is initialized, detect whether to enable Scan button
     */
    connectedCallback() {
        this.myScanner = getBarcodeScanner(); 
    }

    /**
     * Method executed on click of Barcode scan button
     * @param event 
     */
    handleBarcodeClick(event){ 
        if(this.myScanner.isAvailable()) {
            
            const scanningOptions = {
                barcodeTypes: [this.myScanner.barcodeTypes.QR, 
                                this.myScanner.barcodeTypes.UPC_E,
                                this.myScanner.barcodeTypes.EAN_13,
                                this.myScanner.barcodeTypes.CODE_39 ],
                instructionText: 'Scan a QR , UPC , EAN 13, Code 39',
                successText: 'Scanning complete.'
            }; 
            this.myScanner.beginCapture(scanningOptions)
            .then((result) => { 
                this.scannedBarcode = result.value;  
            })
            .catch((error) => { 
                this.showError('error',error);
            })
            .finally(() => {
                this.myScanner.endCapture();
            }); 
        }
        else {
            this.showError('Error','Scanner not supported on this device');
        }
    }

    showError(title,msg) {
        const event = new ShowToastEvent({
            title: title,
            message: msg,
            error : 'error'
        });
        this.dispatchEvent(event);
    }
}