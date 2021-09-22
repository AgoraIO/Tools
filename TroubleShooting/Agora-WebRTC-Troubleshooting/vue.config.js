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
  },

  configureWebpack: (config) => {
      config.output.filename = '[name].[hash:8].js';
      config.output.chunkFilename = '[name].[hash:8].js';
  }
}
