<template>
  <header class="sticky-top">
    <nav class="navbar navbar-dark bg-dark">
      <span class="navbar-brand mb-0 h1">タスク管理アプリ</span>
        <ul class="navbar-nav">
          <li class="nav-item d-flex align-items-center">
            <div class="btn btn-primary btn-sm me-2">新規登録</div>
            <div class="btn btn-primary btn-sm me-2">ログイン</div>
          </li>
        </ul>
    </nav>
    <nav class="navbar bg-light">
      <div v-for="menu in menus" :key="menu" class="flex-fill bd-highlight text-center">
        <router-link :to="{ name: menu.link }">{{ menu.name }}</router-link>
      </div>
    </nav>
  </header>
</template>

<script>
  export default {
    name: "Header",
    data() {
      return {
        menus: [
          { name: "現金換算", link: "Top" },
          { name: "ガチャ記録", link: "Gacha" },
          { name: "ゲーム記録", link: "Game" },
          { name: "換算用データ", link: "ConData" },
          { name: "カレンダー", link: "Calender" },
        ]
      }
    }
  }
</script>