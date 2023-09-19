<template>
  <div class="d-flex flex-column min-vh-100">
    <Header class="mb-auto" />
    <router-view />
    <Footer class="mb-auto" />
  </div>
</template>

<script>
import Header from "./components/Header.vue"
import Footer from "./components/Footer.vue"

export default {
  components: {
    Header,
    Footer,
  }
}
</script>

<style scoped>
</style>