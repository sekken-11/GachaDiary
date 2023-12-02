<template>
  <header>
    <nav class="firstbar navbar border-bottom">
      <div @click="toInfo">
        <span class="navbar-brand mb-0 ms-3 app-name">Gacha Diary</span>
      </div>
        <ul class="navbar-nav">
          <li class="nav-item d-flex align-items-center" v-if="!authUser">
            <router-link :to="{ name: 'SignUp' }"><v-btn class="header-btn me-2" color="info">新規登録</v-btn></router-link>
            <router-link :to="{ name: 'SignIn' }"><v-btn class="header-btn me-2" color="info">ログイン</v-btn></router-link>
            <v-app-bar-nav-icon id="sidebar" variant="text" @click.stop="drawer = !drawer" class="me-2"></v-app-bar-nav-icon>
          </li>
          <li class="nav-item d-flex align-items-center" v-if="authUser">
            <router-link :to="{ name: 'GachaRecordCreate' }"><v-btn class="header-btn me-2" color="info">ガチャ記録作成</v-btn></router-link>
            <v-app-bar-nav-icon id="sidebar" variant="text" @click.stop="drawer = !drawer" class="me-2"></v-app-bar-nav-icon>
          </li>
        </ul>
    </nav>
    <nav class="secondbar navbar mx-5 p-0">
      <div v-for="menu in menus" 
        :key="menu" 
        :id="menu.link + '-link'"
        class="secondbar-block flex-fill py-3" 
        :class="{ 'here': menu.path == $route.path,
                  'another': menu.path != $route.path }"
        @click="toPages(menu.link)">
        <router-link :to="{ name: menu.link }" class="secondbar-link">{{ menu.name }}</router-link>
      </div>
    </nav>
  </header>

<SideBar v-model="drawer" v-if="drawer" />
  
</template>

<script>
import { mapGetters, mapActions } from 'vuex'
import SideBar from './SideBar.vue'


export default {
  name: "Header",
  components: {
    SideBar
  },
  data() {
    return {
      drawer: false,
      menus: [
        { name: "現金換算", link: "Top", path: "/" },
        { name: "ガチャ記録", link: "Gacha", path: "/gachas" },
        { name: "所持ガチャ石", link: "Posses", path: "/posses" },
        { name: "換算用データ", link: "Conversion", path: "/conversions" },
        { name: "カレンダー", link: "Calendar", path: "/calendars" },
      ]
    }
  },
  computed: {
    ...mapGetters('users', ["authUser"])
  },
  methods: {
    ...mapActions('users', ["logoutUser"]),
    toMypage() {
      this.$router.push({ name: 'MyPage' })
    },
    toPages(link) {
      this.$router.push({ name: link })
    },
    toInfo() {
      this.$router.push({ name: 'Information' })
    }
  }
}
</script>

<style scoped>
.app-name{
  font-family: Courier;
  font-size: 30px;
  color: steelblue;
}
.firstbar{
  background-color: white;
  color: black;
}
.secondbar{
  background-color: snow;
}
.secondbar-block{
  text-align: center;
}
.secondbar-block:hover{
  text-align: center;
  background: linear-gradient(snow, lavender);
}
.secondbar-link{
  color: gray;
  text-decoration: none;
}
.here{
  border-bottom: 4px solid mediumslateblue;
  background: linear-gradient(snow, lavender);
}
.another{
  border-bottom: 4px solid #efefef;
}
@media (min-width:768px) {
  .secondbar-link {
    font-size: 140%;
  }
  .header-btn {
    font-size: 110%;
  }
  header {
    zoom: 110%;
  }
}
</style>