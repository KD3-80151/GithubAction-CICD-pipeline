import { LightningElement, api, track } from 'lwc';

export default class FileUpload extends LightningElement {
    @api recordId;
    @track uploadedFiles = [];

    handleUploadFinished(event) {
        const uploaded = event.detail.files;
        this.uploadedFiles = uploaded.map(file => ({
            title: file.name,
            contentVersionId: file.contentVersionId,
            downloadUrl: '/sfc/servlet.shepherd/version/download/' + file.contentVersionId
        }));
    }
}