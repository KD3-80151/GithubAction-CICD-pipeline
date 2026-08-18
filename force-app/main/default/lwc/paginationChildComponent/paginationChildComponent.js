import { LightningElement, api } from 'lwc';

export default class PaginationChildComponent extends LightningElement {
    totalRecords
    visibleRecords
    recordSize = 5;
    currentPage=1
    totalPage
    get records(){
        return this.visibleRecords;
    }

    @api 
    set records(data){
        //debugger;
        if(data){
          //  console.log(data);
            this.totalRecords= data;
            
            //console.log(visibleRecords);
            
            this.totalPage = Math.ceil(data.length/this.recordSize);
            this.passRecord();
        }
    }

    // to communicate from child to parent - need custom event
    passRecord(){
        const start = (this.currentPage - 1) * this.recordSize;
        const end = this.currentPage * this.recordSize;
        this.visibleRecords = this.totalRecords.slice(start, end);
        //debugger;
        this.dispatchEvent(new CustomEvent('sliced', {
            detail:{
                records: this.visibleRecords
            }
        }));
    }

    nextHandler(){
        if(this.currentPage < this.totalPage){
            this.currentPage= this.currentPage + 1;
            this.passRecord();
        }


    }

    previousHandler(){
        if(this.currentPage>1){
            this.currentPage = this.currentPage -1;
            this.passRecord();
        }
    }


    get nextDisabled(){
        return this.currentPage >=this.totalPage;
    }

    get previosDisabled(){
        return this.currentPage <= 1;
    }
}