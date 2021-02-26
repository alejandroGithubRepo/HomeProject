import { LightningElement, track, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getProductsList from '@salesforce/apex/OpportunityHelper.getProductsList';
import removeProductsList from '@salesforce/apex/OpportunityHelper.removeProductsList';


const columns = [
    { label: 'Name', fieldName: 'Name', type: 'Text', sortable: false},
    { label: 'Product Code', fieldName: 'ProductCode', type: 'Text', sortable: true, initialWidth: 150 },
    { label: 'Sales Price', fieldName: 'UnitPrice', type: 'Currency', typeAttributes: { currencyCode: 'USD'}, initialWidth: 150 }
];

export default class ModalQuestionPopUpLWC extends LightningElement {
    @api recordId;
    @track columns = columns;
    @track lineItemList;
    @track haveData = true;

    connectedCallback() {
        getProductsList({ opportunityId: this.recordId })
        .then((result) => {
            this.lineItemList = result;
            if (this.lineItemList.length === 0) {
                this.haveData = false;
            }
        })
    }

    async deleteRecords() {
        // Remove the records via Apex.
        await removeProductsList({ opportunityId: this.recordId })
        .then(() => {
            this.dispatchEvent(new ShowToastEvent({
                title: 'Success',
                message: 'All Products related to this Opportunity were successfully removed',
                variant: 'success',
            }));
        })
        this.closeModal();
    }

    closeModal() {
        this.dispatchEvent(new CustomEvent('Close'));
    }
}