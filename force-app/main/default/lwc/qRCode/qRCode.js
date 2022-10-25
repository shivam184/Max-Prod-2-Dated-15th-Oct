import { LightningElement,track } from 'lwc';
import getAccountList from '@salesforce/apex/QRController.getAccountList';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
export default class QRCode extends LightningElement {
    @track contactsRecord =[];
    @track contactsRecord1 =[];
    searchValue = '';
 
    // update searchValue var when input field value change
    searchKeyword(event) {
        this.searchValue = event.target.value;
    }
    handleSearchKeyword() {
        console.log('this.searchValue'+this.searchValue.length);
        if ((this.searchValue.length == 10)){
            getAccountList({
                    searchKey: this.searchValue
                })
                .then(result => {
                    // set @track contacts variable with return contact list from server  
                    //this.contactsRecord = result;
                    for(let i = 0; i < result.length; i++){
                        console.log('result[i].Name'+result[i].Name);
                        const option = {
                            label : result[i].Name,
                            value : result[i].Name
                        };
                        this.contactsRecord.push(option);
                    }
                  
                    this.contactsRecord= JSON.parse(JSON.stringify(this.contactsRecord));
                })
                .catch(error => {
                   
                    const event = new ShowToastEvent({
                        title: 'Error',
                        variant: 'error',
                        message: error.body.message,
                    });
                    this.dispatchEvent(event);
                    // reset contacts var with null   
                    this.contactsRecord = null;
                });
        } else {
            alert('Please enter 10 digit mobile number');
            // fire toast event if input field is blank
            const event = new ShowToastEvent({
                variant: 'error',
                message: 'Please enter 10 digit mobile number',
            });
            this.dispatchEvent(event);
        }
    }
}