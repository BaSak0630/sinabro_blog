<template>
  <div class="header">
    <div class="title" @click="click()">Dailelog</div>
  </div>
</template>

<script setup lang="ts">
function click() {
  location.href = '/'
}
</script>

<style scoped lang="scss">
.header {
  height: 60px;
  margin: 1rem 2rem;
  display: flex;
  justify-content: left;
  align-items: center;
}

.logo {
  width: 52px;
  object-fit: cover;
}

.title {
  font-size: 2rem;
  font-weight: 300;
  margin-left: 5px;
}
</style>
