<template>
  <div class="py-3 d-flex justify-content-center">
    <v-card class="col-12 col-md-6 shadow">
      <v-card-title class="text-center bg-warning pt-3"><h4>メールアドレス変更</h4></v-card-title>
      <v-card-text>
        <div class="my-5">
          <p class="text-muted">現在のメールアドレス</p>
          <h5 class="text-success">{{ this.authUser.email }}</h5>
        </div>
        <Form @submit="handleEmailChange">
          <div v-if="error" class="text-danger my-4">{{ error }}</div>
          <div class="form-group my-4">
            <label for="email">メールアドレス</label>
            <Field name="email" id="email" v-model="user.email" class="form-control" type="email" :rules="isEmailRequired" />
            <div class="text-danger"><ErrorMessage name="email" /></div>
          </div>
          <div class="text-center bg-white">
            <v-btn type="submit" class="bg-dark my-3">
              <span class="text-white">変更</span>
            </v-btn>
          </div>
        </Form>
      </v-card-text>
    </v-card>
  </div>
</template>

<script>
import { Field, Form, ErrorMessage } from 'vee-validate';
import { mapGetters, mapActions } from 'vuex'

export default {
  name: 'EmailChange',
  components: {
    Field,
    Form,
    ErrorMessage,
  },
  computed: {
    ...mapGetters('users',["authUser"]),
  },
  data() {
    return {
      user: {
        email: '',
      },
      error: ''
    }
  },
  methods: {
    ...mapActions('users',[
      "fetchAuthUser",
      "updateUser",
    ]),
    ...mapActions('transition', ["addMessage"]),
    async handleEmailChange() {
      var result = confirm('変更してもよろしいですか？');
      if (result) {
        try {
          await this.updateUser(this.user)
          this.$router.push({ name: 'MyPage' })
          this.addMessage({
            message: "メールアドレスを変更しました",
            messageType: "success",
            timeOut: 10000
          })
        } catch (error) {
          console.log(error)
          this.error = 'メールアドレスを変更できません'
        }
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