# Data 360 BigQuery Base

Salesforce metadata package for Data 360 with BigQuery workshop (Base components).

## Deploy to Salesforce

Click the button below to deploy this package to your Salesforce org:

<a href="https://githubsfdeploy.herokuapp.com?owner=emcmullen-sf&repo=Workshop&ref=main&path=Packages/Data-360-BigQuery-Base">
  <img alt="Deploy to Salesforce" src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">
</a>

## Contents

This package contains:

### Custom Application
- **Coral_Cloud_Service** - Service application for Coral Cloud

### Lightning Pages (FlexiPages)
- **Coral_Cloud_Service_Case_Layout** - Case record page layout
- **Coral_Cloud_Service_UtilityBar** - Utility bar for the service app

### Permission Sets
- **Router_Workshop_Admin_Additional_Access** - Additional admin permissions for the router workshop

## Structure

```
src/
├── applications/
│   └── Coral_Cloud_Service.app-meta.xml
├── flexipages/
│   ├── Coral_Cloud_Service_Case_Layout.flexipage-meta.xml
│   └── Coral_Cloud_Service_UtilityBar.flexipage-meta.xml
├── permissionsets/
│   └── Router_Workshop_Admin_Additional_Access.permissionset-meta.xml
└── package.xml
```
