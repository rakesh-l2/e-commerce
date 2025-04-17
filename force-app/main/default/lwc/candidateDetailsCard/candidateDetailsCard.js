import { LightningElement, api } from 'lwc';
import EMAIL from '@salesforce/schema/Candidate__c.Email__c';
import SOURCE from '@salesforce/schema/Candidate__c.Source__c';
import APP_DATE from '@salesforce/schema/Candidate__c.Application_Date__c';
import STATUS from '@salesforce/schema/Candidate__c.Status__c';
import syncCandidate from '@salesforce/apex/CandidateSyncController.syncCandidate';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CandidateDetailsCard extends LightningElement {
  @api recordId;
  fields = [EMAIL, SOURCE, APP_DATE, STATUS];

  async handleSync() {
    try {
      await syncCandidate({ candidateId: this.recordId });
      this.dispatchEvent(
        new ShowToastEvent({
          title: 'Success',
          message: 'Candidate synced successfully with external sources',
          variant: 'success'
        })
      );
    } catch (error) {
      this.dispatchEvent(
        new ShowToastEvent({
          title: 'Error',
          message: error?.body?.message || 'Sync failed',
          variant: 'error'
        })
      );
    }
  }
}
