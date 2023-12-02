<template>
<v-app class="bgcolor">
  <div class="d-flex flex-column min-vh-100 smart-size" @click="">
    <Message class="message" />
    <Header class="mb-2" />
{{ids}}
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

    <Footer />
  </div>
</v-app>
</template>

<script>
import Header from './components/Header.vue'
import Footer from './components/Footer.vue'
import TotalRecord from './components/TotalRecord.vue';
import Message from './components/FlashMessage.vue';
import { mapGetters, mapActions } from 'vuex';

export default {
  components: {
    Header,
    Footer,
    TotalRecord,
    Message,
  },
  computed: {
    ...mapGetters('users', ["authUser"]),
    no_total_record() {
      return this.$route.path.match(/\/$/) 
      || this.$route.path.match(/gachareco$/) 
      || this.$route.path.match(/mypage$/) 
      || this.$route.path.match(/passreset$/) 
      || this.$route.path.match(/mailchange$/) 
      || this.$route.path.match(/info$/)
      || this.$route.path.match(/terms$/)
      || this.$route.path.match(/policy$/)
    },
  },
  methods: {
    ...mapActions('transition', ["emptyMessage"]),
    deleteMessage() {
      this.emptyMessage()
    },
  },
}
</script>

<style scoped>
.bgcolor {
  background-color: snow;
  position: relative;
  z-index: 1;
}
.message {
  width: 100%;
  position: fixed;
  top: 0;
  z-index: 2;
}
</style>