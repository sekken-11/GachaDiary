<template>
  <div class="py-3 d-flex justify-content-center">
    <v-card class="col-12 col-md-6 shadow" id="signup-form">
      <v-card-title class="signup-title">
        <h4>新規登録</h4>
      </v-card-title>
      <v-card-text>
        <Form @submit="handleSignUp">
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
          <div class="form-group mb-4">
            <label for="password_confirmation" class="form-label">パスワード（再入力）</label>
            <Field name="password_confirmation" id="password_confirmation" v-model="user.password_confirmation" class="form-control" type="password" :rules="isPassConRequired" />
            <div class="text-danger"><ErrorMessage name="password_confirmation" /></div>
          </div>
          <div class="text-center bg-white">
            <v-btn block type="submit" class="my-3" color="info">登録</v-btn>
          </div>
        </Form>
        <div class="mt-3">
          <router-link :to="{ name: 'Mailaddress' }">
            <i class="bi bi-caret-right me-1"></i>メールアドレスの登録について
          </router-link>
        </div>
      </v-card-text>
    </v-card>
  </div>
</template>

<script>
import { Field, Form, ErrorMessage } from 'vee-validate';
import axios from 'axios';
import { mapActions } from 'vuex';

export default {
  name: 'SignUp',
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
        password_confirmation: ''
      },
      error: '',
    }
  },
  methods: {
    ...mapActions('transition', ["addMessage"]),
    handleSignUp() {
      axios
        .post('api/users', { user: this.user })
        .then(res => {
          this.$router.push({ name: 'SignIn' })
          this.addMessage({
            message: "ユーザー登録に成功しました",
            messageType: "success"
          })
        })
        .catch(err => {
          console.log(err)
          this.addMessage({
            message: "ユーザー登録に失敗しました",
            messageType: "danger"
          })
        })
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
.signup-title{
  background-color: cornflowerblue;
  color: white;
  padding-top: 1rem;
  text-align: center;
}
</style>