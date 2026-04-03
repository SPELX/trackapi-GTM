___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "TAG",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "TrackAPI Analytics",
  "categories": ["ANALYTICS", "CONVERSIONS"],
  "brand": {
    "id": "brand_trackapi",
    "displayName": "TrackAPI"
  },
  "description": "Loads the TrackAPI SDK and initializes server-side tracking (CAPI). Sends conversion events to Meta CAPI, TikTok Events API and GA4 Measurement Protocol, bypassing ad blockers via CNAME first-party tracking.",
  "containerContexts": [
    "WEB"
  ],
  "termsOfServiceVersion": "1"
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "projectId",
    "displayName": "Project ID",
    "simpleValueType": true,
    "help": "Find your Project ID in the TrackAPI dashboard under Project Settings. Format: proj_abc123",
    "notSetText": "e.g. proj_abc123",
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ]
  },
  {
    "type": "TEXT",
    "name": "endpoint",
    "displayName": "Endpoint (custom CNAME)",
    "simpleValueType": true,
    "help": "Your custom CNAME URL (e.g. https://analytics.yoursite.com). Leave blank to use the default endpoint. We recommend setting up a CNAME for better matching quality.",
    "notSetText": "https://analytics.yoursite.com (recommended)"
  },
  {
    "type": "CHECKBOX",
    "name": "autoPageView",
    "checkboxText": "Fire PageView automatically on init",
    "simpleValueType": true,
    "defaultValue": true,
    "help": "Sends a PageView event right after init(). Disable only if you control PageViews manually via dataLayer.push({ event: 'PageView' })."
  },
  {
    "type": "CHECKBOX",
    "name": "debug",
    "checkboxText": "Debug mode (browser console logs)",
    "simpleValueType": true,
    "defaultValue": false
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

var injectScript = require('injectScript');
var callInWindow = require('callInWindow');
var copyFromWindow = require('copyFromWindow');
var makeString = require('makeString');
var log = require('logToConsole');

var projectId = makeString(data.projectId || '');
var endpoint = makeString(data.endpoint || '').replace(/\/$/, '');
var autoPageView = data.autoPageView !== false;
var debugMode = !!data.debug;

if (!projectId) {
  log('TrackAPI: projectId is required. Set the Project ID in the GTM tag.');
  data.gtmOnFailure();
  return;
}

var sdkUrl = endpoint
  ? endpoint + '/sdk.js'
  : 'https://api.trackapi.app.br/sdk.js';

var existingSDK = copyFromWindow('TrackAPI');
if (existingSDK && existingSDK.init) {
  callInWindow('TrackAPI.init', {
    projectId: projectId,
    endpoint: endpoint || undefined,
    autoPageView: autoPageView,
    debug: debugMode
  });
  data.gtmOnSuccess();
  return;
}

injectScript(sdkUrl, function() {
  var sdk = copyFromWindow('TrackAPI');
  if (sdk && sdk.init) {
    callInWindow('TrackAPI.init', {
      projectId: projectId,
      endpoint: endpoint || undefined,
      autoPageView: autoPageView,
      debug: debugMode
    });
    data.gtmOnSuccess();
  } else {
    log('TrackAPI: SDK loaded but TrackAPI.init not found. Check the endpoint URL.');
    data.gtmOnFailure();
  }
}, function() {
  log('TrackAPI: failed to load SDK from ' + sdkUrl + '. Check the endpoint and CNAME.');
  data.gtmOnFailure();
}, 'trackapi-sdk');


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "inject_script",
        "versionId": "1"
      },
      "param": [
        {
          "key": "urls",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "https://api.trackapi.app.br/sdk.js"
              },
              {
                "type": 1,
                "string": "https://*.*/sdk.js"
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "access_globals",
        "versionId": "1"
      },
      "param": [
        {
          "key": "keys",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "TrackAPI"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": false
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "TrackAPI.init"
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "logging",
        "versionId": "1"
      },
      "param": [
        {
          "key": "environments",
          "value": {
            "type": 1,
            "string": "debug"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___NOTES___

TrackAPI Analytics - GTM Tag Template

Loads and initializes the TrackAPI SDK for server-side tracking via CAPI (Conversions API).

Setup:
1. Add this tag in GTM (type: TrackAPI Analytics)
2. Enter your Project ID (TrackAPI dashboard > Settings)
3. If you have a CNAME, enter the Endpoint (e.g. https://analytics.yoursite.com)
4. Trigger: All Pages
5. Publish

Deduplication with Facebook Pixel:
1. Also import the TrackAPI - Event ID variable template
2. In the Facebook Pixel tag, set Event ID to {{TrackAPI - Event ID}}

Documentation: https://trackapi.app.br/docs/sdk
