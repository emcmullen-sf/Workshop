# Test Deploy to Salesforce

A minimal Salesforce metadata package to test the [GitHub Deploy to Salesforce](https://github.com/afawcett/githubsfdeploy) button.

## Deploy to Salesforce

Click the button below to deploy this package to your Salesforce org:

<a href="https://githubsfdeploy.herokuapp.com?owner=emcmullen-sf&repo=Workshop&ref=main&path=Packages/test%20deploy%20to%20salesforce">
  <img alt="Deploy to Salesforce" src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">
</a>

## Contents

This package contains a single Apex class:

- **HelloWorldDeployTest** - A simple class with two methods:
  - `sayHello()` - Returns a greeting message
  - `sayHelloTo(String name)` - Returns a personalized greeting

## Testing the Deployment

After deployment, you can test the class in the Developer Console:

```apex
System.debug(HelloWorldDeployTest.sayHello());
System.debug(HelloWorldDeployTest.sayHelloTo('World'));
```

## Structure

```
src/
├── classes/
│   ├── HelloWorldDeployTest.cls
│   └── HelloWorldDeployTest.cls-meta.xml
└── package.xml
```

