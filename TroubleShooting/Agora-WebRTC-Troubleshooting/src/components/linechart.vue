<template>
  <div>
    <ve-line :data="data" :settings="settings" :grid="grid"></ve-line>
  </div>
</template>

<script>
export default {
  props: ['data', 'settings', 'grid']
}
</script>


