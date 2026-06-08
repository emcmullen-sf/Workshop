/**
 * Tests for WorkshopSetupController.
 * Covers status checks, permission set assignment, demo data creation,
 * and idempotent re-runs.
 */
@IsTest
private class WorkshopSetupControllerTest {

    @IsTest
    static void getSetupStatus_returnsFalseWhenNothingDone() {
        Test.startTest();
        WorkshopSetupController.SetupStatus status = WorkshopSetupController.getSetupStatus();
        Test.stopTest();

        // Permission set may or may not exist in the test org; data should not.
        System.assertEquals(false, status.dataCreated, 'No demo case should exist yet.');
        System.assertEquals(null, status.demoCaseId, 'No demo case id expected.');
    }

    @IsTest
    static void assignPermissionSet_handlesMissingPermSet() {
        // The permission set lives in the CoralCloud-ServiceApp package, which is
        // not present in a bare test context, so we expect a friendly error.
        Boolean threwOrSucceeded = false;
        Test.startTest();
        try {
            String result = WorkshopSetupController.assignPermissionSet();
            // If the perm set happens to exist, we get a success string instead.
            threwOrSucceeded = result != null;
        } catch (AuraHandledException e) {
            threwOrSucceeded = true;
        }
        Test.stopTest();
        System.assert(threwOrSucceeded, 'Method should either succeed or raise a handled exception.');
    }

    @IsTest
    static void createWorkshopData_createsThenIsIdempotent() {
        Test.startTest();
        String firstRun = WorkshopSetupController.createWorkshopData();
        String secondRun = WorkshopSetupController.createWorkshopData();
        Test.stopTest();

        System.assert(firstRun.contains('Created'), 'First run should create records.');
        System.assert(
            secondRun.contains('already existed') || secondRun.contains('Already present'),
            'Second run should be idempotent.'
        );

        System.assertEquals(1, [SELECT COUNT() FROM Account WHERE Name = 'Ackwood Household - 11435616']);
        System.assertEquals(1, [SELECT COUNT() FROM Case WHERE Subject = 'Intermittent Connectivity / Slow Speeds']);

        WorkshopSetupController.SetupStatus status = WorkshopSetupController.getSetupStatus();
        System.assertEquals(true, status.dataCreated, 'Status should report data created.');
        System.assertNotEquals(null, status.demoCaseId, 'Status should include the demo case id.');
    }
}
