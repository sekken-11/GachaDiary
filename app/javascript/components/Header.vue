<template>
  <header class="sticky-top">
    <nav class="navbar navbar-dark bg-dark">
      <span class="navbar-brand mb-0 h1">タスク管理アプリ</span>
        <ul class="navbar-nav">
          <li class="nav-item d-flex align-items-center" v-if="!authUser">
            <router-link :to="{ name: 'SignUp' }" class="btn btn-primary btn-sm me-2">新規登録</router-link>
            <router-link :to="{ name: 'SignIn' }" class="btn btn-primary btn-sm me-2">ログイン</router-link>
          </li>
          <li class="nav-item d-flex align-items-center" v-if="authUser">
            <router-link :to="{ name: 'GachaRecordCreate' }" class="btn btn-primary btn-sm me-2">ガチャ記録作成</router-link>
            <button class="btn-sm me-2" @click="handleSignOut">ログアウト</button>
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
</script>