<template>
  <div>
    <div class="text-center">
      <h3>タスクを管理しよう！</h3>
      <div class="mt-4">生活や仕事に関するタスクを見える化して抜け漏れを防ぎましょう。</div>
      <router-link :to="{ name: 'Task' }" class="btn btn-dark mt-5">はじめる</router-link>
    </div>
  </div>
</template>

<script>
export default {
  name: "Top",
  data() {
    return {
      title: "タスク管理アプリ"
    }
  }
}
</script>

<style scoped>
</style>