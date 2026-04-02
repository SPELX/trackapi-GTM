# TrackAPI - GTM Templates

Dois templates para Google Tag Manager que simplificam a instalação do TrackAPI e garantem deduplicação correta entre Facebook browser Pixel e CAPI.

## Templates

| Arquivo | Tipo | Função |
|---|---|---|
| `trackapi-tag.tpl` | Tag | Carrega o SDK e inicializa o TrackAPI |
| `trackapi-event-id.tpl` | Variável | Gera event_id com cache para deduplicação |

## Instalação manual (sem galeria)

1. No GTM, vá em **Modelos → Novo → ⋮ → Importar**
2. Importe `trackapi-tag.tpl` → salve como **"TrackAPI Analytics"**
3. Importe `trackapi-event-id.tpl` → salve como **"TrackAPI - Event ID"**

## Setup

### Tag TrackAPI Analytics
- Trigger: **All Pages**
- Project ID: `proj_xxx` (dashboard TrackAPI → Configurações)
- Endpoint: `https://analytics.seusite.com.br` (se tiver CNAME — recomendado)

### Deduplicação Facebook Pixel
Na tag do Facebook Pixel (nativa GTM):
- **Event ID** → `{{TrackAPI - Event ID}}`

## Fluxo de deduplicação

```
Usuário acessa a página
    ↓
GTM carrega
    ├─ Tag TrackAPI: carrega SDK → TrackAPI.init() → autoPageView → CAPI (event_id: evt_123)
    └─ Tag Facebook Pixel: fbq('track', 'PageView', {}, { eventID: {{TrackAPI - Event ID}} })
         └─ {{TrackAPI - Event ID}} retorna o mesmo evt_123 (cache 8s, mesma rota)
    ↓
Meta Events Manager: event_id idêntico nos dois canais → 1 conversão contabilizada ✅
```

## Publicação na galeria GTM (pendente)

Para submeter à galeria oficial do Google Tag Manager Community Templates:
1. Criar repositório público no GitHub com os arquivos `.tpl`
2. Submeter em: https://github.com/google/tagmanager-templates
