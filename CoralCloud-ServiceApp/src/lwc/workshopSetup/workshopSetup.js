import { LightningElement, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getSetupStatus from '@salesforce/apex/WorkshopSetupController.getSetupStatus';
import assignPermissionSet from '@salesforce/apex/WorkshopSetupController.assignPermissionSet';
import createWorkshopData from '@salesforce/apex/WorkshopSetupController.createWorkshopData';

export default class WorkshopSetup extends NavigationMixin(LightningElement) {
    @track permSetAssigned = false;
    @track dataCreated = false;
    demoCaseId;

    loadingStatus = true;
    step1Running = false;
    step2Running = false;

    step1Message;
    step2Message;

    connectedCallback() {
        this.refreshStatus();
    }

    async refreshStatus() {
        this.loadingStatus = true;
        try {
            const status = await getSetupStatus();
            this.permSetAssigned = status.permSetAssigned;
            this.dataCreated = status.dataCreated;
            this.demoCaseId = status.demoCaseId;
        } catch (error) {
            this.showError('Could not load setup status', error);
        } finally {
            this.loadingStatus = false;
        }
    }

    async handleStep1() {
        this.step1Running = true;
        this.step1Message = undefined;
        try {
            this.step1Message = await assignPermissionSet();
            this.permSetAssigned = true;
            this.showSuccess('Step 1 complete', this.step1Message);
        } catch (error) {
            this.showError('Step 1 failed', error);
        } finally {
            this.step1Running = false;
        }
    }

    async handleStep2() {
        this.step2Running = true;
        this.step2Message = undefined;
        try {
            this.step2Message = await createWorkshopData();
            await this.refreshStatus();
            this.showSuccess('Step 2 complete', this.step2Message);
        } catch (error) {
            this.showError('Step 2 failed', error);
        } finally {
            this.step2Running = false;
        }
    }

    openCase() {
        if (!this.demoCaseId) {
            return;
        }
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.demoCaseId,
                objectApiName: 'Case',
                actionName: 'view'
            }
        });
    }

    // ---- getters for template state ----

    get step1ButtonLabel() {
        return this.permSetAssigned ? 'Permission Set Assigned' : 'Assign Permission Set';
    }

    get step2ButtonLabel() {
        return this.dataCreated ? 'Records Created' : 'Create Demo Records';
    }

    get step1Disabled() {
        return this.permSetAssigned || this.step1Running || this.loadingStatus;
    }

    get step2Disabled() {
        return this.dataCreated || this.step2Running || this.loadingStatus;
    }

    get step1IconName() {
        return this.permSetAssigned ? 'utility:success' : 'utility:key';
    }

    get step2IconName() {
        return this.dataCreated ? 'utility:success' : 'utility:add';
    }

    get step1IconVariant() {
        return this.permSetAssigned ? 'success' : '';
    }

    get step2IconVariant() {
        return this.dataCreated ? 'success' : '';
    }

    get showOpenCase() {
        return this.dataCreated && this.demoCaseId;
    }

    get allComplete() {
        return this.permSetAssigned && this.dataCreated;
    }

    // ---- helpers ----

    showSuccess(title, message) {
        this.dispatchEvent(
            new ShowToastEvent({ title, message, variant: 'success' })
        );
    }

    showError(title, error) {
        const message =
            error && error.body && error.body.message
                ? error.body.message
                : error && error.message
                ? error.message
                : 'An unexpected error occurred.';
        this.dispatchEvent(
            new ShowToastEvent({ title, message, variant: 'error', mode: 'sticky' })
        );
    }
}
