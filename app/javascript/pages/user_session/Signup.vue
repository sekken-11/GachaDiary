<template>
  <div class="py-3 d-flex justify-content-center">
    <div class="card col-12 col-md-6 shadow">
      <div class="card-header text-center bg-secondary text-light pt-3"><h4>新規登録</h4></div>
      <div class="card-body">
        <Form @submit="handleSignUp">
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
          <div class="form-group mb-4">
            <label for="password_confirmation">パスワード（再入力）</label>
            <Field name="password_confirmation" id="password_confirmation" v-model="user.password_confirmation" class="form-control" type="password" :rules="isPassConRequired" />
            <div class="text-danger"><ErrorMessage name="password_confirmation" /></div>
          </div>
          <div class="text-center bg-white">
            <button type="submit" class="btn btn-dark my-3">
              登録
            </button>
          </div>
        </Form>
      </div>
    </div>
  </div>
</template>

<script>
import { Field, Form, ErrorMessage } from 'vee-validate';
import axios from 'axios';

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
      }
    }
  },
  methods: {
    handleSignUp() {
      axios
        .post('api/users', { user: this.user })
        .then(res => {
          this.$router.push({ name: 'SignIn' })
        })
        .catch(err => {
          console.log(err)
        })
    },
    isEmailRequired(value) {
      if (!value && !value.trim()) {
        return '入力してください';
      }
      if (!value.match(/.+@.+\..+/)) {
        return '登録できないメールアドレスの形式です';
      }
      return true;
    },
    isSixToSixteenRequired(value) {
      if (!value && !value.trim()) {
        return '入力してください';
      }
      if (!value.match(/^[ -~]*$/)) {
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