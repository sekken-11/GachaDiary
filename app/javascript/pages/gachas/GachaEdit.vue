<template>
  <v-card class="mb-3">
    <Form @submit="handleEditGacha" id="gacha-edit-form">
      <v-card-item class="bg-white py-3 border-bottom">
        <span class="form-title">ガチャ記録 編集</span>
      </v-card-item>
      <v-card-text>
        <div class="form-group m-3">
          <label for="count" class="form-label">ガチャ回数</label>
          <Field name="count" id="count" v-model.number="gacha.count" class="form-control" :rules="isNumericRequired" />
          <ErrorMessage name="count" id="count_error" class="text-danger" />
        </div>
        <div class="form-group m-3">
          <label for="date" class="form-label">ガチャを引いた日付</label>
          <Field name="date" id="date" type="date" v-model="gacha.date" class="form-control" />
          <ErrorMessage name="date" id="date" class="text-danger" />
        </div>
        <div class="form-group m-3">
          <label for="currency_package" class="form-label">換算用データ</label>
          <br>
          <label for="initial_package" class="my-1">初期登録データを除く</label>
          <input type="checkbox" id="initial_package" name="initial_package" v-model="checked">
          <Field as="select" name="currency_package_id" id="currency_package" v-model.number="gacha.currency_package_id" class="form-control">
            <option v-for="(currency_package, index) in checkedPackeges" :key="index" :value="currency_package.id">{{ currency_package.name }}</option>
          </Field>
        </div>
        <div class="form-group m-3">
          <label for="description" class="form-label">備考</label>
          <Field as="textarea" name="description" id="description" v-model="gacha.description" style="width:100%" rows="3" />
        </div>
        <div class="text-end m-3 mt-5">
          <v-btn block class="bg-success" type="submit">変更</v-btn>
        </div>
      </v-card-text>
    </Form>
  </v-card>
</template>

<script>
import { Field, Form, ErrorMessage } from 'vee-validate';
import { mapGetters, mapActions } from 'vuex';

export default {
  name: 'GachaDetail',
  components: {
    Field,
    Form,
    ErrorMessage
  },
  data() {
    return {
      checked: false,
    }
  },
  computed: {
    ...mapGetters('gachas', [
      "gacha", 
      "currencyPackages",
    ]),
    checkedPackeges() {
      if (this.checked) {
        return this.currencyPackages.filter(currency_package => {
          return currency_package.category == "add"
        }) 
      } else {
        return this.currencyPackages
      }
    },
  },
  created() {
    this.fetchPackages();
    this.fetchGacha(this.$route.params.id);
  },
  methods: {
    ...mapActions('gachas', [
      "fetchPackages",
      "fetchGacha",
      "editGacha",
    ]),
    ...mapActions('transition', ["addMessage"]),
    async handleEditGacha() {
        try {
            await this.editGacha(this.gacha)
            this.$router.back()
            this.addMessage({
                message: "ガチャ記録を編集しました",
                messageType: "success"
            })
        } catch (error) {
            console.log(error)
            this.addMessage({
                message: "ガチャ記録の編集に失敗しました",
                messageType: "danger"
            })
        }
    },
    isNumericRequired(value) {
      if (!value.toString().match(/^[0-9]*$/)) {
        return '半角数字で入力してください';
      }
      if (!value && !value.trim()) {
        return '入力してください';
      }
      return true;
    },
  },
}
</script>