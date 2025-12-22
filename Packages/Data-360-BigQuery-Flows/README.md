# Data 360 BigQuery Flows

Salesforce metadata package for Data 360 with BigQuery workshop (Flows and Apex).

## Deploy to Salesforce

Click the button below to deploy this package to your Salesforce org:

<a href="https://githubsfdeploy.herokuapp.com?owner=emcmullen-sf&repo=Workshop&ref=main&path=Packages/Data-360-BigQuery-Flows">
  <img alt="Deploy to Salesforce" src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">
</a>

## Contents

This package contains:

### Apex Classes
- **GetRouterCriticalEvents** - Retrieves router critical events
- **GetRouterCriticalEventsTest** - Test class for GetRouterCriticalEvents
- **InsightRow** - Data wrapper class for insight rows

### Lightning Pages (FlexiPages)
- **Coral_Cloud_Service_Case_Layout** - Case record page layout

### Flows
- **Router_Critical_Instability_Events_Agent** - Agent flow for critical instability events
- **Router_Critical_Instability_Events_Data_Table** - Data table flow for critical events
- **Router_Diagnostic_Logs_Data_Table** - Data table flow for diagnostic logs
- **Router_Remote_Firmware_Reset** - Flow for remote firmware reset

## Structure

```
src/
├── classes/
│   ├── GetRouterCriticalEvents.cls
│   ├── GetRouterCriticalEvents.cls-meta.xml
│   ├── GetRouterCriticalEventsTest.cls
│   ├── GetRouterCriticalEventsTest.cls-meta.xml
│   ├── InsightRow.cls
│   └── InsightRow.cls-meta.xml
├── flexipages/
│   └── Coral_Cloud_Service_Case_Layout.flexipage-meta.xml
├── flows/
│   ├── Router_Critical_Instability_Events_Agent.flow-meta.xml
│   ├── Router_Critical_Instability_Events_Data_Table.flow-meta.xml
│   ├── Router_Diagnostic_Logs_Data_Table.flow-meta.xml
│   └── Router_Remote_Firmware_Reset.flow-meta.xml
└── package.xml
```
