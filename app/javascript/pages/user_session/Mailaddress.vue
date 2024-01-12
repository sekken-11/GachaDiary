<template>
  <div class="py-3 d-flex justify-content-center">
    <v-card class="card col-12 col-md-10 shadow">
      <v-card-title class="text-center bg-warning pt-3"><h4>メールアドレスの登録について</h4></v-card-title>
      <v-card-text>
        <p class="mt-4 text-muted">本サイトにおいて、ご登録いただいたメールアドレスの用途はパスワードを忘れてしまった際などの再設定のためにのみ使用いたします。</p>
        <p class="mt-2 text-muted">そのため、パスワード再設定をする必要がないという利用者様は、下記のような形式でメールアドレスをご登録いただいても問題ありません。</p>
        <p class="mt-2 text-muted">下記の「任意のユーザー名」部分に好きな文字列を入力して登録してください。</p>
        <span>任意のユーザー名@example.com</span>
        <div class="mb-3 mt-5">
          <router-link :to="{ name: 'SignUp' }">
            <i class="bi bi-caret-right me-1"></i>新規登録
          </router-link>
        </div>
      </v-card-text>
    </v-card>
  </div>
</template>

<script>
export default {
  name: 'Mailaddress',
}
</script>

<style scoped>
span {
  color: dimgray;
  font-size: 20px;
  display: block;
  text-align: center;
  padding: 15px 0px;
  margin: 20px 70px;
  border: solid 1px dimgray;
  border-radius: 10px;
  letter-spacing: 1.5px;
}
</style>