<template>
<v-app class="bgcolor">
  <div class="d-flex flex-column min-vh-100">
    <Header class="mb-2" />

    <div class="py-3" v-if="no_total_record && authUser">
      <router-view />
    </div>

    <div v-if="!authUser">
      <router-view />
    </div>
    
    <div class="py-3" v-if="!no_total_record && authUser">
      <v-container>
        <v-row>
          <v-col cols="12" md="8">
            <router-view />
          </v-col>
          <v-col cols="12" md="4">
            <TotalRecord />
          </v-col>
        </v-row>
      </v-container>
    </div>

    <Footer class="mb-3" />
  </div>
</v-app>
</template>

<script>
import Header from './components/Header.vue'
import Footer from './components/Footer.vue'
import TotalRecord from './components/TotalRecord.vue';
import { mapGetters } from 'vuex';

export default {
  components: {
    Header,
    Footer,
    TotalRecord,
  },
  data() {
    return {
    }
  },
  computed: {
    ...mapGetters('users', ["authUser"]),
    no_total_record() {
      return this.$route.path.match(/\/$/) || this.$route.path.match(/gachareco$/) || this.$route.path.match(/mypage$/) || this.$route.path.match(/passreset$/) || this.$route.path.match(/mailchange$/) || this.$route.path.match(/info$/)
    }
  },
}
</script>

<style scoped>
.bgcolor {
  background-color: snow;
}
</style>