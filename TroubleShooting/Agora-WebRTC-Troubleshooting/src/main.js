import '@babel/polyfill'
import Vue from 'vue'
import VeLine from "v-charts/lib/line.common";
import './plugins/vuetify'
import App from './App.vue'
import './registerServiceWorker'

Vue.config.productionTip = false
Vue.component(VeLine.name, VeLine);

new Vue({
  render: h => h(App)
}).$mount('#app')
