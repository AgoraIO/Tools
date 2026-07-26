export const profileArray = [
  {resolution: '120p_1', width: 160, height: 120},
  {resolution: '180p_1', width: 320, height: 180},
  {resolution: '240p_1', width: 320, height: 240},
  {resolution: '360p_1', width: 640, height: 360},
  {resolution: '480p_1', width: 640, height: 480},
  {resolution: '720p_1', width: 1280, height: 720},
  {resolution: '1080p_1', width: 1920, height: 1080}
]

export const APP_ID = process.env.VUE_APP_AGORA_APP_ID || ''
export const APP_CERTIFICATE = process.env.VUE_APP_AGORA_APP_CERTIFICATE || ''
export const TOKEN_ENDPOINT = 'https://service.agora.io/toolbox-global/v2/token/generate'
export const TOKEN_EXPIRE = Number(process.env.VUE_APP_TOKEN_EXPIRE || 3600)
export const TOKEN_SRC = process.env.VUE_APP_TOKEN_SRC || 'web'
