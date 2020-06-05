module.exports = {
  publicPath: process.env.NODE_ENV === 'production'
    ? '/agora_webrtc_troubleshooting'
    : '/',

  // If you need local debugging on the phone
  // devServer: {
  //   https: true
  // }
  chainWebpack: config => {
    config.module.rules.delete('eslint');
  }
}
