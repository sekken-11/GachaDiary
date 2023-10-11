<template>
<v-app class="bg-light">
  <div class="d-flex flex-column min-vh-100">
    <Header class="mb-2" />

    <div v-if="this.$route.path.match(/\/$/) && authUser">
      <router-view />
    </div>

    <div v-if="this.$route.path.match(/gachareco$/) && authUser">
      <router-view />
    </div>

    <div v-if="!authUser">
      <router-view />
    </div>
    
    <div class="py-3" v-if="!this.$route.path.match(/\/$/) && !this.$route.path.match(/gachareco$/) && authUser">
      <div class="container">
        <div class="row">
          <div class="col-12 col-lg-8">
            <router-view />
          </div>
          <div class="col-12 col-lg-4">
            <TotalRecord />
          </div>
        </div>
      </div>
    </div>

    <Footer class="mb-3" />
  </div>
</v-app>
</template>

<script>
import Header from './components/Header.vue'
import Footer from './components/Footer.vue'
import TotalRecord from './components/TotalRecord.vue';
import { mapGetters} from 'vuex';

export default {
  components: {
    Header,
    Footer,
    TotalRecord,
  },
  computed: {
    ...mapGetters('users', ["authUser"])
  },
}
</script>

<style scoped>
</style>