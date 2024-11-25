<template>
  <div>
    <NuxtLayout>
      <NuxtPage />
    </NuxtLayout>
  </div>
</template>

<script setup>
onMounted(() => {
  // Log saat app dimount di client-side
  if (process.client) {
    console.log('App mounted on client-side')
  }
})
</script>

<style>
/* Tambahkan styling global jika diperlukan */
body {
  margin: 0;
  font-family: 'Inter', sans-serif;
}
</style>
