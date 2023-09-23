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
      <div class="flex-fill bd-highlight text-center">現金換算</div>
      <div class="flex-fill bd-highlight text-center">ガチャ記録</div>
      <div class="flex-fill bd-highlight text-center">ゲーム記録</div>
      <div class="flex-fill bd-highlight text-center">換算用データ</div>
      <div class="flex-fill bd-highlight text-center">カレンダー</div>
    </nav>
  </header>
</template>

<script>
  export default {
    name: "Header"
  }
</script>