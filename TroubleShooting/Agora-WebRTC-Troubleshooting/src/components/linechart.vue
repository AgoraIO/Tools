<template>
  <div>
    <ve-line :data="data" :settings="settings" :grid="grid"></ve-line>
  </div>
</template>

<script>
export default {
  name: 'LineChart',
  props: ['data', 'settings', 'grid']
}
</script>

