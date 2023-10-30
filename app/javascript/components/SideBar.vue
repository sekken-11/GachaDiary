<template>
<v-navigation-drawer temporary location="end" theme="dark">
  <v-list>
    <v-list-item @click="toInfo" class="border-bottom border-top">
      <v-list-item-title>このサイトについて</v-list-item-title>
    </v-list-item>
    <v-list-item @click="toMypage" class="border-bottom border-top" v-if="authUser">
      <v-list-item-title>マイページ</v-list-item-title>
    </v-list-item>
    <v-list-item class="border-bottom border-top" @click="isVisiblePages = !isVisiblePages" id="page-choice">
      <v-list-item-title>
        ページ選択
        <i v-if="isVisiblePages" class="bi bi-chevron-down ms-2"></i>
        <i v-if="!isVisiblePages" class="bi bi-chevron-right ms-2"></i>
      </v-list-item-title>
    </v-list-item>
      <v-list 
        v-for="(menu, index) in menus" 
        :key="menu" :id="'page-' + (index + 1)" 
        class="ms-3 py-0 border-start"
        :class="{ 'here': menu.path == $route.path }"
        v-if="isVisiblePages && authUser"
      >
        <v-list-item class="border-bottom" @click="toPages(menu.link)">
          <v-list-item-title>{{ menu.name }}</v-list-item-title>
        </v-list-item>
      </v-list>
      <v-list v-if="isVisiblePages && !authUser" class="ms-3 py-0 border-start">
        <v-list-item class="border-bottom">
          <v-list-item-title>ログイン後に利用できます</v-list-item-title>
        </v-list-item>
      </v-list>
    <v-list-item class="border-bottom border-top" @click="isVisibleGames = !isVisibleGames" id="game-choice">
      <v-list-item-title>
        ゲーム選択
        <i v-if="isVisibleGames" class="bi bi-chevron-down ms-2"></i>
        <i v-if="!isVisibleGames" class="bi bi-chevron-right ms-2"></i>
      </v-list-item-title>
    </v-list-item>
      <v-list 
        v-for="(totalRecord, index) in totalRecords" 
        :key="menu" :id="'game-' + (index + 1)" 
        class="ms-3 py-0 border-start"
        v-if="isVisibleGames && authUser"
      >
        <v-list-item class="border-bottom" @click="toGames(totalRecord.id)">
          <v-list-item-title>{{ totalRecord.game_name }}</v-list-item-title>
        </v-list-item>
      </v-list>
      <v-list v-if="isVisibleGames && !authUser" class="ms-3 py-0 border-start">
        <v-list-item class="border-bottom">
          <v-list-item-title>ログイン後に利用できます</v-list-item-title>
        </v-list-item>
      </v-list>
  </v-list>

  <template v-slot:append>
    <div class="m-2" v-if="authUser">
      <v-btn block color="danger" @click="handleSignOut">
        <span class="text-white">ログアウト</span>
      </v-btn>
    </div>
  </template>

</v-navigation-drawer>
</template>

<script>
import { mapGetters, mapActions } from 'vuex';

export default {
  name: 'SideBar',
  data() {
    return {
      isVisiblePages: false,
      isVisibleGames: false,
      menus: [
        { name: "現金換算", link: "Top", path: "/" },
        { name: "ガチャ記録", link: "Gacha", path: "/gachas" },
        { name: "ゲーム記録", link: "Game", path: "/games" },
        { name: "換算用データ", link: "Conversion", path: "/conversions" },
        { name: "カレンダー", link: "Calendar", path: "/calendars" },
      ]
    }
  },
  computed: {
    ...mapGetters('gachas', ["totalRecords"]),
    ...mapGetters('users', ["authUser"]),
  },
  created() {
    this.fetchAuthUser();
  },
  methods: {
    ...mapActions('gachas', ["gachas"]),
    ...mapActions('users', [
      "logoutUser",
      "fetchAuthUser",
    ]),
    toMypage() {
      this.$router.push({ name: 'MyPage' })
    },
    toPages(link) {
      this.$router.push({ name: link })
    },
    toGames(id) {
      this.$router.push({ name: 'GameFullData', params: { id: id } })
    },
    toInfo() {
      this.$router.push({ name: 'Information' })
    },
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
    },
  }
}
</script>

<style scoped>
.here{
  pointer-events: none;
}
</style>