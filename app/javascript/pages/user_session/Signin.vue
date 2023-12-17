<template>
  <div class="py-3 d-flex justify-content-center">
    <v-card class="col-12 col-md-6 shadow" id="signin-form">
      <v-card-title class="login-title">
        <h4>ログイン</h4>
      </v-card-title>
      <v-card-text class="my-4">
        <Form @submit="handleSignIn">
          <div v-if="error" class="text-danger my-4">{{ error }}</div>
          <div class="form-group my-4">
            <label for="email" class="form-label">メールアドレス</label>
            <Field name="email" id="email" v-model="user.email" class="form-control" type="email" :rules="isEmailRequired" />
            <div class="text-danger"><ErrorMessage name="email" /></div>
          </div>
          <div class="form-group mb-4">
            <label for="password" class="form-label">パスワード</label>
            <Field name="password" id="password" v-model="user.password" class="form-control" type="password" :rules="isSixToSixteenRequired" />
            <div class="text-danger"><ErrorMessage name="password" /></div>
          </div>
          <div class="text-center bg-white">
            <v-btn block type="submit" class="my-3" color="info">ログイン</v-btn>
          </div>
        </Form>
        <div class="mt-3">
          <router-link :to="{ name: 'PasswordReset' }">
            <i class="bi bi-caret-right me-1"></i>パスワードを忘れた方はこちら
          </router-link>
        </div>
      </v-card-text>
    </v-card>
  </div>
</template>

<script>
import { Field, Form, ErrorMessage } from 'vee-validate';
import { mapActions } from 'vuex'

export default {
  name: 'SignIn',
  components: {
    Field,
    Form,
    ErrorMessage,
  },
  data() {
    return {
      user: {
        email: '',
        password: '',
      },
      error: ''
    }
  },
  methods: {
    ...mapActions('users', [
      'loginUser',
      'fetchAuthUser',
    ]),
    ...mapActions('transition', ["addMessage"]),
    async handleSignIn() {
      try {
        await this.loginUser(this.user);
        this.$router.push({ name: 'Top' })
        this.addMessage({
          message: "ログインしました",
          messageType: "success"
        })
      } catch (error) {
        console.log(error);
        this.addMessage({
          message: "ログインに失敗しました",
          messageType: "danger"
        })
      }
    },
    isEmailRequired(value) {
      if (!value && !value.trim()) {
        return '入力してください';
      }
      if (!value.toString().match(/.+@.+\..+/)) {
        return '登録できないメールアドレスの形式です';
      }
      return true;
    },
    isSixToSixteenRequired(value) {
      if (!value && !value.trim()) {
        return '入力してください';
      }
      if (!value.toString().match(/^[ -~]*$/)) {
        return '半角英数字または記号のみで入力してください';
      }
      if (value.length > 16 || value.length < 6) {
        return '6文字以上16文字以下で入力してください';
      }
      return true;
    },
    isPassConRequired(value) {
      if (!value && !value.trim()) {
        return '入力してください';
      }
      
      return true;
    },
  }
}
</script>

<style scoped>
.login-title{
  background-color: cornflowerblue;
  color: white;
  padding-top: 1rem;
  text-align: center;
}
</style>