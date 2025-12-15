// ==============================================================================
// SECTION: PERMISSION SET ASSIGNMENT
// Assign "Router_Workshop_Admin_Additional_Access" to the current running user.
// ==============================================================================

String permSetDevName = 'Router_Workshop_Admin_Additional_Access';
Id currentUserId = UserInfo.getUserId();

// 1. Retrieve the Permission Set ID
List<PermissionSet> targetPermSet = [SELECT Id, Label FROM PermissionSet WHERE Name = :permSetDevName LIMIT 1];

if (!targetPermSet.isEmpty()) {
    // 2. Prepare the assignment
    PermissionSetAssignment psa = new PermissionSetAssignment(
        PermissionSetId = targetPermSet[0].Id,
        AssigneeId = currentUserId
    );

    // 3. Insert with Error Handling
    try {
        insert psa;
        System.debug('Success: Permission Set assigned to ' + currentUserId);
    } catch (DmlException e) {
        // Salesforce throws a DUPLICATE_VALUE exception if the user already has the permission set.
        // We catch this to ensure the script completes successfully.
        if (e.getMessage().contains('DUPLICATE_VALUE')) {
            System.debug('Info: User already has this Permission Set assigned.');
        } else {
            System.debug('Error: ' + e.getMessage());
        }
    }
} else {
    System.debug('Error: Permission Set "' + permSetDevName + '" could not be found. Check the API Name.');
}
