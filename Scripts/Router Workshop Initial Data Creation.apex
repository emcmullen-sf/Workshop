// ==============================================================================
// SECTION 1: ACCOUNT
// Retrieve "Ackwood Household - 11435616" or create it if missing.
// ==============================================================================
String accountName = 'Ackwood Household - 11435616';
Account targetAccount;

List<Account> existingAccounts = [SELECT Id FROM Account WHERE Name = :accountName LIMIT 1];

if (existingAccounts.isEmpty()) {
    targetAccount = new Account(Name = accountName);
    insert targetAccount;
    System.debug('Created new Account: ' + targetAccount.Id);
} else {
    targetAccount = existingAccounts[0];
    System.debug('Found existing Account: ' + targetAccount.Id);
}

// ==============================================================================
// SECTION 2: CONTACT
// Retrieve the most recent Contact on the Account, or create "Ferne Ackwood".
// ==============================================================================
Contact targetContact;

// Check for any contact on this specific account
List<Contact> existingContacts = [SELECT Id FROM Contact WHERE AccountId = :targetAccount.Id ORDER BY CreatedDate DESC LIMIT 1];

if (existingContacts.isEmpty()) {
    targetContact = new Contact(
        FirstName = 'Ferne',
        LastName = 'Ackwood',
        AccountId = targetAccount.Id
    );
    insert targetContact;
    System.debug('Created new Contact: ' + targetContact.Id);
} else {
    targetContact = existingContacts[0];
    System.debug('Found existing Contact: ' + targetContact.Id);
}

// ==============================================================================
// SECTION 3: PRODUCT
// Check for "HyperLink Gateway 5000" or create it.
// ==============================================================================
String productName = 'HyperLink Gateway 5000';
Product2 targetProduct;

List<Product2> existingProducts = [SELECT Id FROM Product2 WHERE Name = :productName LIMIT 1];

if (existingProducts.isEmpty()) {
    targetProduct = new Product2(
        Name = productName,
        ProductCode = 'HG5000',
        Description = 'An Internet Router, provided to end customers. Supports 3GB speeds.',
        IsActive = true
    );
    insert targetProduct;
    System.debug('Created new Product: ' + targetProduct.Id);
} else {
    targetProduct = existingProducts[0];
    System.debug('Found existing Product: ' + targetProduct.Id);
}

// ==============================================================================
// SECTION 4: ASSET
// Check for Asset by Name "HyperLink Gateway - A1:B2:C3:D4:E5" or create it.
// ==============================================================================
String assetName = 'HyperLink Gateway - A1:B2:C3:D4:E5';
Asset targetAsset;

List<Asset> existingAssets = [SELECT Id FROM Asset WHERE Name = :assetName LIMIT 1];

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
    System.debug('Created new Asset: ' + targetAsset.Id);
} else {
    targetAsset = existingAssets[0];
    System.debug('Found existing Asset: ' + targetAsset.Id);
}

// ==============================================================================
// SECTION 5: CASE
// Check for Case by Subject "Intermittent Connectivity / Slow Speeds" or create it.
// ==============================================================================
String caseSubject = 'Intermittent Connectivity / Slow Speeds';
Case targetCase;

// We check if a case with this subject already exists to prevent duplicates
List<Case> existingCases = [SELECT Id FROM Case WHERE Subject = :caseSubject LIMIT 1];

if (existingCases.isEmpty()) {
    targetCase = new Case(
        Status = 'New',
        Origin = 'Phone',
        Priority = 'Medium',
        Subject = caseSubject,
        Description = 'The customer is experiencing intermittent connectivity and slow speeds',
        AssetId = targetAsset.Id,
        AccountId = targetAccount.Id, // Optional: Best practice to link Case to Account as well
        ContactId = targetContact.Id  // Optional: Best practice to link Case to Contact as well
    );
    insert targetCase;
    System.debug('Created new Case: ' + targetCase.Id);
} else {
    targetCase = existingCases[0];
    System.debug('Found existing Case: ' + targetCase.Id);
}

