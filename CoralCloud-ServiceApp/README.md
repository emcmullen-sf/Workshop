# Data 360 BigQuery Base

Salesforce metadata package for Data 360 with BigQuery workshop (Base components).

## Deploy to Salesforce

Click the button below to deploy this package to your Salesforce org:

<a href="https://githubsfdeploy.herokuapp.com?owner=emcmullen-sf&repo=Workshop&ref=main&path=CoralCloud-ServiceApp">
  <img alt="Deploy to Salesforce" src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">
</a>

## Contents

This package contains:

### Custom Application
- **Coral_Cloud_Service** - Service application for Coral Cloud (includes the Workshop Setup tab)

### Apex Classes
- **WorkshopSetupController** - Runs the workshop setup steps (assign permission set, create demo records) from the UI instead of via Anonymous Apex
- **WorkshopSetupControllerTest** - Test coverage for the controller

### Lightning Web Components
- **workshopSetup** - Two-step "Workshop Setup" UI (assign permission set, create demo records) with completion indicators

### Custom Tabs
- **Workshop_Setup** - Tab surfacing the Workshop Setup page in the Coral Cloud Service app

### Lightning Pages (FlexiPages)
- **Coral_Cloud_Service_Case_Layout** - Case record page layout
- **Coral_Cloud_Service_UtilityBar** - Utility bar for the service app
- **Workshop_Setup** - App page hosting the workshopSetup component

### Permission Sets
- **Router_Workshop_Admin_Additional_Access** - Additional admin permissions for the router workshop

## Structure

```
src/
├── applications/
│   └── Coral_Cloud_Service.app-meta.xml
├── classes/
│   ├── WorkshopSetupController.cls
│   ├── WorkshopSetupController.cls-meta.xml
│   ├── WorkshopSetupControllerTest.cls
│   └── WorkshopSetupControllerTest.cls-meta.xml
├── flexipages/
│   ├── Coral_Cloud_Service_Case_Layout.flexipage-meta.xml
│   ├── Coral_Cloud_Service_UtilityBar.flexipage-meta.xml
│   └── Workshop_Setup.flexipage-meta.xml
├── lwc/
│   └── workshopSetup/
│       ├── workshopSetup.html
│       ├── workshopSetup.js
│       └── workshopSetup.js-meta.xml
├── permissionsets/
│   └── Router_Workshop_Admin_Additional_Access.permissionset-meta.xml
├── tabs/
│   └── Workshop_Setup.tab-meta.xml
└── package.xml
```
