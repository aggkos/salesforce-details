import {api, LightningElement, track} from 'lwc';
import getFieldsDetails from '@salesforce/apex/DetailsCntrl.getFieldsDetails';
import {ShowToastEvent} from "lightning/platformShowToastEvent";

export default class LotInfo extends LightningElement {
    @api objectName;
    @api recordId;
    @api allowEdit;
    @api layoutName;
    @track fields = [];
    @track columns = [];
    @track columns2 = [];
    editView = false;
    showLotInfoSpinner = false;
    connectedCallback() {
        this.fetchDetails();
    }

    fetchDetails() {
        getFieldsDetails({objectName: this.objectName, layoutName: this.layoutName})
            .then((result) => {
                result.forEach(item => {
                    if (item.Column === 1){
                        this.columns2.push(item);
                    }
                    else {
                        this.columns.push(item);
                    }
                })
                this.fields.push(this.columns);
                this.fields.push(this.columns2);
            })
            .catch((error) => {
                const event = new ShowToastEvent({
                    title: 'Error',
                    message: error.body.message,
                    variant: 'error',
                    mode: 'sticky'
                });
                this.dispatchEvent(event);
            });
    }

    handleEditClick(){
        this.editView = true;
    }

    handleEditCancel(){
        this.editView = false;
    }

    handleSuccess(){
        this.showLotInfoSpinner = false;
        this.editView = false;
    }
    handleSubmit(){
        this.showLotInfoSpinner = true;
    }

}