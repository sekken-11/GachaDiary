<template>
  <div class="py-3 d-flex justify-content-center">
    <v-card class="card col-12 col-md-6 shadow">
      <v-card-title class="text-center bg-warning pt-3"><h4>パスワード変更</h4></v-card-title>
      <v-card-text>
        <p class="my-4 text-muted">下記に入力したメールアドレスにパスワード変更用メールが送信されます。</p>
        <Form @submit="handlePasswordResetMail">
          <div v-if="error" class="text-danger my-4">{{ error }}</div>
          <div class="form-group my-4">
            <label for="email">メールアドレス</label>
            <Field name="email" id="email" v-model="user.email" class="form-control" type="email" :rules="isEmailRequired" />
            <div class="text-danger"><ErrorMessage name="email" /></div>
          </div>
          <div class="text-center bg-white">
            <v-btn type="submit" class="bg-dark my-3">
              <span class="text-white">送信</span>
            </v-btn>
          </div>
        </Form>
      </v-card-text>
    </v-card>
  </div>
</template>

<script>
import { Field, Form, ErrorMessage } from 'vee-validate';
import axios from 'axios';
import { mapGetters } from 'vuex';


export default {
  name: 'PasswordReset',
  components: {
    Field,
    Form,
    ErrorMessage,
  },
  data() {
    return {
      user: {
        email: '',
      },
      error: ''
    }
  },
  computed: {
    ...mapGetters('users',["authUser"]),
  },
  created() {
    this.setEmail();
  },
  methods: {
    async handlePasswordResetMail() {
      axios
        .post('api/password_resets', { email: this.user.email })
        .then(res => {
          alert("メールを送信しました")
          this.$router.push({ name: 'SignIn' })
        })
        .catch(err => {
          console.log(err)
          this.error = 'メールを送信しました'
        })
    },
    setEmail() {
      if (this.authUser) {
        this.user.email = this.authUser.email
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
  }
}
</script>