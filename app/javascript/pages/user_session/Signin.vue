<template>
  <div class="py-3 d-flex justify-content-center">
    <div class="card col-12 col-md-6 shadow">
      <div class="card-header text-center bg-secondary text-light pt-3"><h4>ログイン</h4></div>
      <div class="card-body">
        <Form @submit="handleSignIn">
          <div v-if="error" class="text-danger my-4">{{ error }}</div>
          <div class="form-group my-4">
            <label for="email">メールアドレス</label>
            <Field name="email" id="email" v-model="user.email" class="form-control" type="email" :rules="isEmailRequired" />
            <div class="text-danger"><ErrorMessage name="email" /></div>
          </div>
          <div class="form-group mb-4">
            <label for="password">パスワード</label>
            <Field name="password" id="password" v-model="user.password" class="form-control" type="password" :rules="isSixToSixteenRequired" />
            <div class="text-danger"><ErrorMessage name="password" /></div>
          </div>
          <div class="text-center bg-white">
            <button type="submit" class="btn btn-dark my-3">
              ログイン
            </button>
          </div>
        </Form>
      </div>
    </div>
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
    async handleSignIn() {
      try {
        await this.loginUser(this.user);
        this.$router.push({ name: 'Top' })
      } catch (error) {
        console.log(error);
        this.error = 'ログインに失敗しました'
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