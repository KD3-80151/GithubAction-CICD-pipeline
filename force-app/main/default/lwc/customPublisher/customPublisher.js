import { LightningElement, track } from 'lwc';
import profileImg from '@salesforce/resourceUrl/ProfileImage';

export default class CustomPublisher extends LightningElement {
    @track commentText = ''; // to store the user comment
    @track showComment= false; // control visibility of the display area
    profileImage = profileImg;

    handleTextChange(event) {
        debugger;
        this.commentText = event.target.value;
    }

    handleComment(){
        debugger;
        if (this.commentText) {
            this.showComment = true;
            
        }
    }
}