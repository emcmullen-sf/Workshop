/**
 * WorkshopSetupController
 *
 * Backs the "Workshop Setup" Lightning page used in the Zero Copy workshop.
 * Replaces the two manual Anonymous Apex steps in the attendee guide:
 *   Step 1 - Assign the "Router_Workshop_Admin_Additional_Access" permission set
 *            to the running user.
 *   Step 2 - Create the demo records (Account, Contact, Product, Asset, Case).
 *
 * Step 1 and Step 2 are exposed as separate @AuraEnabled methods on purpose:
 * inserting a PermissionSetAssignment (a setup object) in the same transaction
 * as the standard objects in Step 2 would raise MIXED_DML_OPERATION. Keeping
 * them in separate transactions (separate button clicks) avoids that.
 *
 * Every method is defensive / idempotent so re-running is harmless.
 */
public with sharing class WorkshopSetupController {

    private static final String PERM_SET_DEV_NAME = 'Router_Workshop_Admin_Additional_Access';
    private static final String DEMO_CASE_SUBJECT = 'Intermittent Connectivity / Slow Speeds';

    /**
     * Lightweight status wrapper returned to the LWC so it can render
     * completion state on load (and disable buttons that are already done).
     */
    public class SetupStatus {
        @AuraEnabled public Boolean permSetAssigned { get; set; }
        @AuraEnabled public Boolean dataCreated { get; set; }
        @AuraEnabled public Id demoCaseId { get; set; }
    }

    /**
     * Returns the current setup state for the running user / org.
     */
    @AuraEnabled(cacheable=false)
    public static SetupStatus getSetupStatus() {
        SetupStatus status = new SetupStatus();
        Id currentUserId = UserInfo.getUserId();

        status.permSetAssigned = ![
            SELECT Id FROM PermissionSetAssignment
            WHERE AssigneeId = :currentUserId
            AND PermissionSet.Name = :PERM_SET_DEV_NAME
            LIMIT 1
        ].isEmpty();

        List<Case> demoCases = [
            SELECT Id FROM Case WHERE Subject = :DEMO_CASE_SUBJECT LIMIT 1
        ];
        status.dataCreated = !demoCases.isEmpty();
        if (status.dataCreated) {
            status.demoCaseId = demoCases[0].Id;
        }

        return status;
    }

    /**
     * STEP 1 - Assign the workshop permission set to the running user.
     * Mirrors the "Assign Permission Set via Anonymous Apex" script.
     */
    @AuraEnabled
    public static String assignPermissionSet() {
        Id currentUserId = UserInfo.getUserId();

        List<PermissionSet> targetPermSet = [
            SELECT Id, Label FROM PermissionSet
            WHERE Name = :PERM_SET_DEV_NAME LIMIT 1
        ];

        if (targetPermSet.isEmpty()) {
            throw new AuraHandledException(
                'Permission Set "' + PERM_SET_DEV_NAME +
                '" could not be found. Ensure the CoralCloud-ServiceApp package is installed.'
            );
        }

        // Skip if already assigned (idempotent).
        Boolean alreadyAssigned = ![
            SELECT Id FROM PermissionSetAssignment
            WHERE AssigneeId = :currentUserId
            AND PermissionSetId = :targetPermSet[0].Id
            LIMIT 1
        ].isEmpty();

        if (alreadyAssigned) {
            return 'Permission set was already assigned. Nothing to do.';
        }

        try {
            insert new PermissionSetAssignment(
                PermissionSetId = targetPermSet[0].Id,
                AssigneeId = currentUserId
            );
            return 'Permission set "' + targetPermSet[0].Label + '" assigned successfully.';
        } catch (DmlException e) {
            if (e.getMessage().contains('DUPLICATE_VALUE')) {
                return 'Permission set was already assigned. Nothing to do.';
            }
            throw new AuraHandledException('Error assigning permission set: ' + e.getMessage());
        }
    }

    /**
     * STEP 2 - Create the workshop demo records.
     * Mirrors the "Create Salesforce Records via Anonymous Apex" script.
     * Each record is created only if it does not already exist.
     */
    @AuraEnabled
    public static String createWorkshopData() {
        List<String> created = new List<String>();
        List<String> existing = new List<String>();

        // ---- Account: "Ackwood Household - 11435616" ----
        String accountName = 'Ackwood Household - 11435616';
        Account targetAccount;
        List<Account> existingAccounts = [
            SELECT Id FROM Account WHERE Name = :accountName LIMIT 1
        ];
        if (existingAccounts.isEmpty()) {
            targetAccount = new Account(Name = accountName);
            insert targetAccount;
            created.add('Account');
        } else {
            targetAccount = existingAccounts[0];
            existing.add('Account');
        }

        // ---- Contact: most recent on the account, else "Ferne Ackwood" ----
        Contact targetContact;
        List<Contact> existingContacts = [
            SELECT Id FROM Contact WHERE AccountId = :targetAccount.Id
            ORDER BY CreatedDate DESC LIMIT 1
        ];
        if (existingContacts.isEmpty()) {
            targetContact = new Contact(
                FirstName = 'Ferne',
                LastName = 'Ackwood',
                AccountId = targetAccount.Id
            );
            insert targetContact;
            created.add('Contact');
        } else {
            targetContact = existingContacts[0];
            existing.add('Contact');
        }

        // ---- Product: "HyperLink Gateway 5000" ----
        String productName = 'HyperLink Gateway 5000';
        Product2 targetProduct;
        List<Product2> existingProducts = [
            SELECT Id FROM Product2 WHERE Name = :productName LIMIT 1
        ];
        if (existingProducts.isEmpty()) {
            targetProduct = new Product2(
                Name = productName,
                ProductCode = 'HG5000',
                Description = 'An Internet Router, provided to end customers. Supports 3GB speeds.',
                IsActive = true
            );
            insert targetProduct;
            created.add('Product');
        } else {
            targetProduct = existingProducts[0];
            existing.add('Product');
        }

        // ---- Asset: "HyperLink Gateway - A1:B2:C3:D4:E5" ----
        String assetName = 'HyperLink Gateway - A1:B2:C3:D4:E5';
        Asset targetAsset;
        List<Asset> existingAssets = [
            SELECT Id FROM Asset WHERE Name = :assetName LIMIT 1
        ];
        if (existingAssets.isEmpty()) {
            targetAsset = new Asset(
                Name = assetName,
                Product2Id = targetProduct.Id,
                AccountId = targetAccount.Id,
                ContactId = targetContact.Id,
                SerialNumber = 'A1:B2:C3:D4:E5',
                Status = 'Installed',
                InstallDate = Date.newInstance(2013, 7, 2)
            );
            insert targetAsset;
            created.add('Asset');
        } else {
            targetAsset = existingAssets[0];
            existing.add('Asset');
        }

        // ---- Case: "Intermittent Connectivity / Slow Speeds" ----
        Case targetCase;
        List<Case> existingCases = [
            SELECT Id FROM Case WHERE Subject = :DEMO_CASE_SUBJECT LIMIT 1
        ];
        if (existingCases.isEmpty()) {
            targetCase = new Case(
                Status = 'New',
                Origin = 'Phone',
                Priority = 'Medium',
                Subject = DEMO_CASE_SUBJECT,
                Description = 'The customer is experiencing intermittent connectivity and slow speeds',
                AssetId = targetAsset.Id,
                AccountId = targetAccount.Id,
                ContactId = targetContact.Id
            );
            insert targetCase;
            created.add('Case');
        } else {
            targetCase = existingCases[0];
            existing.add('Case');
        }

        if (created.isEmpty()) {
            return 'All demo records already existed. Nothing to create.';
        }
        String msg = 'Created: ' + String.join(created, ', ') + '.';
        if (!existing.isEmpty()) {
            msg += ' Already present: ' + String.join(existing, ', ') + '.';
        }
        return msg;
    }
}
