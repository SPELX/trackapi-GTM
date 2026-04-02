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
    "id": "brand_dummy",
    "displayName": "TrackAPI"
  },
  "description": "Carrega o SDK do TrackAPI e inicializa o tracking server-side (CAPI). Envia eventos para Meta CAPI, TikTok Events API e GA4 Measurement Protocol bypassando ad blockers via CNAME first-party.",
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
    "help": "Encontre o Project ID no dashboard TrackAPI em Configurações do Projeto. Formato: proj_abc123",
    "notSetText": "ex: proj_abc123",
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ]
  },
  {
    "type": "TEXT",
    "name": "endpoint",
    "displayName": "Endpoint (CNAME próprio)",
    "simpleValueType": true,
    "help": "URL do CNAME configurado no seu domínio (ex: https://analytics.seusite.com.br). Deixe em branco para usar o endpoint padrão — recomendamos configurar o CNAME para melhor qualidade de matching.",
    "notSetText": "https://analytics.seusite.com.br (recomendado)"
  },
  {
    "type": "CHECKBOX",
    "name": "autoPageView",
    "checkboxText": "Disparar PageView automaticamente no init",
    "simpleValueType": true,
    "defaultValue": true,
    "help": "Envia um evento PageView logo após o init(). Desative apenas se você controlar PageViews manualmente via dataLayer.push({ event: 'PageView' })."
  },
  {
    "type": "CHECKBOX",
    "name": "debug",
    "checkboxText": "Modo debug (logs no console do browser)",
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
  log('TrackAPI: projectId é obrigatório. Configure o Project ID na tag GTM.');
  data.gtmOnFailure();
  return;
}

// URL do SDK: CNAME próprio tem prioridade, fallback para endpoint padrão
var sdkUrl = endpoint
  ? endpoint + '/sdk.js'
  : 'https://api.trackapi.app.br/sdk.js';

// Se o SDK já foi carregado por outra tag, apenas chama init novamente
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

// Carrega SDK de forma assíncrona — não bloqueia renderização
// O cache token 'trackapi-sdk' garante que o script não seja injetado duas vezes
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
    log('TrackAPI: SDK carregado mas TrackAPI.init não encontrado. Verifique a URL do endpoint.');
    data.gtmOnFailure();
  }
}, function() {
  log('TrackAPI: falha ao carregar SDK de ' + sdkUrl + '. Verifique o endpoint e o CNAME.');
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
            "type": 1,
            "listItem": [
              {
                "type": 2,
                "mapKey": ["url"],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "https://api.trackapi.app.br/sdk.js"
                  }
                ]
              },
              {
                "type": 2,
                "mapKey": ["url"],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "https://*.*/sdk.js"
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByTemplateCreator": true
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
            "type": 1,
            "listItem": [
              {
                "type": 2,
                "mapKey": ["key", "read", "write", "execute"],
                "mapValue": [
                  {"type": 1, "string": "TrackAPI"},
                  {"type": 8, "boolean": true},
                  {"type": 8, "boolean": false},
                  {"type": 8, "boolean": false}
                ]
              },
              {
                "type": 2,
                "mapKey": ["key", "read", "write", "execute"],
                "mapValue": [
                  {"type": 1, "string": "TrackAPI.init"},
                  {"type": 8, "boolean": false},
                  {"type": 8, "boolean": false},
                  {"type": 8, "boolean": true}
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByTemplateCreator": true
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
            "listItem": [
              {
                "type": 1,
                "string": "debug"
              }
            ]
          }
        }
      ]
    },
    "isRequired": true
  }
]


___TESTS___

scenarios: []


___NOTES___

## TrackAPI Analytics — GTM Tag Template

Carrega e inicializa o TrackAPI SDK para tracking server-side via CAPI (Conversions API).

### Setup rápido

1. Adicione esta tag no GTM (tipo: TrackAPI Analytics)
2. Preencha o **Project ID** (dashboard TrackAPI → Configurações)
3. Se tiver CNAME, preencha o **Endpoint** (ex: https://analytics.seusite.com.br)
4. Trigger: **All Pages**
5. Publique

### Deduplicação com Facebook Pixel (recomendado)

Para deduplicar PageView e conversões entre browser Pixel e CAPI:

1. Importe também o template **TrackAPI - Event ID** (variável)
2. Na tag do Facebook Pixel, configure o campo **Event ID** com a variável {{TrackAPI - Event ID}}

Isso garante que browser Pixel e CAPI enviem o mesmo event_id → Meta contabiliza uma única conversão.

### Eventos via dataLayer

Após o init, o SDK escuta o dataLayer automaticamente. Para disparar eventos:

  dataLayer.push({ event: 'Lead', email: 'user@email.com' });
  dataLayer.push({ event: 'Purchase', value: 297, currency: 'BRL', transaction_id: 'ORDER_123' });

O SDK intercepta, envia via CAPI server-side e aplica SHA-256 em email/phone automaticamente.

### Documentação completa

https://trackapi.app.br/docs/sdk
