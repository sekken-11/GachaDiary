<template>
  <header class="sticky-top">
    <nav class="navbar navbar-dark bg-dark">
      <span class="navbar-brand mb-0 h1">ガチャ日記</span>
        <ul class="navbar-nav">
          <li class="nav-item d-flex align-items-center" v-if="!authUser">
            <router-link :to="{ name: 'SignUp' }"><v-btn class="me-2" color="info">新規登録</v-btn></router-link>
            <router-link :to="{ name: 'SignIn' }"><v-btn class="me-2" color="info">ログイン</v-btn></router-link>
          </li>
          <li class="nav-item d-flex align-items-center" v-if="authUser">
            <router-link :to="{ name: 'GachaRecordCreate' }"><v-btn class="me-2" color="info">ガチャ記録作成</v-btn></router-link>
            <router-link :to="{ name: 'MyPage' }"><v-btn class="me-2" color="success">マイページ</v-btn></router-link>
            <v-btn class="text-white me-2" color="danger" @click="handleSignOut">ログアウト</v-btn>
          </li>
        </ul>
    </nav>
    <nav class="navbar bg-white border-bottom">
      <div v-for="menu in menus" :key="menu" class="flex-fill bd-highlight text-center">
        <router-link :to="{ name: menu.link }">{{ menu.name }}</router-link>
      </div>
    </nav>
  </header>
</template>

<script>
import { mapGetters, mapActions } from 'vuex'

export default {
  name: "Header",
  computed: {
    ...mapGetters('users', ["authUser"])
  },
  data() {
    return {
      menus: [
        { name: "現金換算", link: "Top" },
        { name: "ガチャ記録", link: "Gacha" },
        { name: "ゲーム記録", link: "Game" },
        { name: "換算用データ", link: "Conversion" },
        { name: "カレンダー", link: "Calendar" },
      ]
    }
  },
  methods: {
    ...mapActions('users', ["logoutUser"]),
    async handleSignOut() {
      var result = confirm('ログアウトしますか？');
      if (result) {
        try {
          await this.logoutUser()
          this.$router.push({ name: 'Top' })
          alert("ログアウトしました。")
        } catch (error) {
          console.log(error)
          alert("ログアウトできませんでした。")
        }
      }
    }
  }
}
</script>

<style scoped>
</style>