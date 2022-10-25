//Last Modified By:Nitya(IRT) on 16th June 2022 : removed unwanted code, chnaged the flow, removed lc component, directly calling lwc from vf page
//Last Modified By: Nitya on 17th June 2022:Changed the alert UIs and made it client friendly, introduced spinner, worked on visibility of button wherever required.
//Last Modified By Nitya on 17th June 2022: Made field mandatory and displaying error if not valid.
import { LightningElement, track, api, wire } from 'lwc';
import createLead from '@salesforce/apex/PatientFormController.createLead';
import UpdatesaveFile from '@salesforce/apex/PatientFormController.UpdatesaveFile';
import logo from '@salesforce/resourceUrl/MaxLabLogo';
import LightningAlert from 'lightning/alert'
import SystemModstamp from '@salesforce/schema/Account.SystemModstamp';

export default class PatientForm extends LightningElement {
  @api recordId;
  @track scoreObName;
  @track scoreObjPhone;
  @track DocFileContentList;
  @track scoreObjSampleBookingLocation
  @track showSpinner = false;
  @track showNotification = false;
  @track contentVersionId;
  sourceOfLead='QR Code';
  maxlogo = logo;
  disabled = false;


  connectedCallback() {
    const param = 'id';
    this.recordId = this.getUrlParamValue(window.location.href, param);
}
getUrlParamValue(url, key) {
  return new URL(url).searchParams.get(key);
}
  scoreHandleChange(event) {
    if (event.target.name == 'scoreName') {
      this.scoreObName = event.target.value;
    }
    if (event.target.name == 'scorePhone') {
      this.scoreObjPhone = event.target.value;
    }
    if (event.target.name == 'SampleBookingLocation') {
      this.scoreObjSampleBookingLocation = event.target.value;
    }
  }

  submitAction() {
    this.disabled = true;
    this.spinnerShow();
    var isphonevalid = this.template.querySelector("lightning-input[data-my-id=phone]");
    var isnamevalid = this.template.querySelector("lightning-input[data-my-id=name]");
    var isbookingvalid = this.template.querySelector("lightning-input[data-my-id=bookingAdrress]");
    if (isphonevalid.checkValidity() && isnamevalid.checkValidity() && isbookingvalid.checkValidity()) {
      createLead({ Name: this.scoreObName, Phone: this.scoreObjPhone, SampleBookingLocation: this.scoreObjSampleBookingLocation, DoctorId: this.recordId, sourceOfLead:this.sourceOfLead})
      //JSON.stringify(this.newURL)
        .then(result => {
          this.scoreRecoreId = result.Id;
          if (this.contentVersionId!=null) {
            UpdatesaveFile({
              Parentid: this.scoreRecoreId,
              contentVersionId: this.contentVersionId
            }).then(result=>{
              this.spinnerHide();
            LightningAlert.open({
              message: "Thanks for filling in your details, Our Max Lab Call Centre Executive will connect for Home Collection Booking.",
              label: "Form Submitted",
              theme: "success"
            });
            })
            .catch(error=>{
              this.spinnerHide();
              LightningAlert.open({
                message: "There was an error Uploading your File. Please Try Again!!!",
                label: "File Not Uploaded",
                theme: "error"
              });
            })
            this.scoreObName = null;
            this.scoreObjPhone = null;
            this.scoreObjSampleBookingLocation = null;
            this.contentVersionId=null;
            this.disabled = false;
          }
          else {
            this.spinnerHide();
            LightningAlert.open({
              message: "Thanks for filling in your details, Our Max Lab Call Centre Executive will connect for Home Collection Booking.",
              label: "Form Submitted",
              theme: "success"
            });
            this.scoreObName = null;
            this.scoreObjPhone = null;
            this.scoreObjSampleBookingLocation = null;
            this.contentVersionId=null;
            this.disabled = false;
          }
        })
        .catch(error => {
          this.spinnerHide();
          LightningAlert.open({
            message: "There was an error submitting your Form. Please Try Again!!!",
            label: "Form not Submitted",
            theme: "error"
          });
          this.scoreObName = null;
          this.scoreObjPhone = null;
          this.scoreObjSampleBookingLocation = null;
          this.contentVersionId=null;
          this.disabled = false;
        });
    }
    else {
      this.spinnerHide();
      isphonevalid.reportValidity();
      isnamevalid.reportValidity();
      isbookingvalid.reportValidity();
      this.disabled = false;
    }
  }
  spinnerShow() {
    this.showSpinner = true;
  }
  spinnerHide() {
    this.showSpinner = false;
  }

  handleUploadFinished(event) {
    // Get the list of uploaded files
    const uploadedFiles = event.detail.files;
    this.contentVersionId=uploadedFiles[0].contentVersionId; 
    //console.log(this.contentVersionId);
}


}