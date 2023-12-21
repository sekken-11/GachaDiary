<template>
  <v-container>
    <v-row>
      <v-col col="12">
        <v-card>
          <Form @submit="handleCreateGacha" id="gacha-form">
            <v-card-title class="bg-white py-3">
              <span class="form-title">ガチャ記録作成</span>
            </v-card-title>
            <v-card-text>
              <div class="form-group m-3">
                <label for="count" class="form-label">ガチャ回数</label>
                <Field name="count" id="count" v-model.number="gacha.count" class="form-control" :rules="isNumericRequired" />
                <div class="text-danger"><ErrorMessage name="count" id="count_error" /></div>
              </div>
              <div class="form-group m-3">
                <label for="date" class="form-label">ガチャを引いた日付</label>
                <Field name="date" id="date" type="date" v-model="gacha.date" class="form-control" />
                <div class="text-danger"><ErrorMessage name="date" id="date_error" /></div>
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
              <div class="m-3 mt-5">
                <v-btn block color="info" type="submit">作成</v-btn>
              </div>
            </v-card-text>
          </Form>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import { Field, Form, ErrorMessage } from 'vee-validate';
import { mapGetters, mapActions } from 'vuex';

export default {
  name: 'GachaRecordCreate',
  components: {
    Field,
    Form,
    ErrorMessage
  },
  data() {
    return {
      gacha: {
        count: '',
        date: '',
        description: '',
        currency_package_id: '',
      },
      checked: false,
    }
  },
  computed: {
    ...mapGetters('gachas', ["gachas"]),
    ...mapGetters('gachas', [
      "currencyPackages",
      "currencyPackageId",
    ]),
    ...mapGetters('transition', ["selectDate"]),
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
    this.setDate();
    if (this.currencyPackageId) {
      this.gacha.currency_package_id = Number(this.currencyPackageId);
    }
  },
  methods: {
    ...mapActions('gachas', ["createGacha"]),
    ...mapActions('gachas', [
      "fetchPackages",
      "pickPackageId",
    ]),
    ...mapActions('transition', ["addMessage"]),
    setDate() {
      this.gacha.date = this.selectDate || new Date().toLocaleDateString('sv-SE')
    },
    async handleCreateGacha(gacha) {
      try {
        await this.createGacha(gacha)
        this.$router.back()
        this.pickPackageId(gacha.currency_package_id)
        this.addMessage({
          message: "ガチャ記録を作成しました",
          messageType: "success"
        })
      } catch (error) {
        console.log(error)
        this.addMessage({
          message: "ガチャ記録の作成に失敗しました",
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

<style scoped>

</style>