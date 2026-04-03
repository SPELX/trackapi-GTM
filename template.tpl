___INFO___

{
  "displayName": "TrackAPI Analytics",
  "description": "Loads the TrackAPI SDK for server-side conversion tracking via Meta CAPI, TikTok Events API and GA4 Measurement Protocol.",
  "categories": ["ANALYTICS"],
  "securityGroups": [],
  "id": "cvt_temp_public_id",
  "type": "TAG",
  "version": 1,
  "brand": {
    "thumbnail": "",
    "displayName": "",
    "id": "brand_dummy"
  },
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "help": "Your TrackAPI Project ID. Find it in the dashboard under Project Settings.",
    "displayName": "Project ID",
    "defaultValue": "",
    "name": "projectId",
    "type": "TEXT"
  }
]


___WEB_PERMISSIONS___

[
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
    "isRequired": true
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

var log = require('logToConsole');
log('data =', data);
data.gtmOnSuccess();


___NOTES___

TrackAPI Analytics - GTM Tag Template
