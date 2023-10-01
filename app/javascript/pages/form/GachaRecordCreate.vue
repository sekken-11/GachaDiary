<template>
<div class="py-3">
  <div class="container">
    <div class="row">
      <div class="offset-md-1 col-12 col-md-10">
        <div class="card">

          <Form @submit="handleCreateGacha">
            <div class="card-header bg-white py-3">
              <span>ガチャ記録作成</span>
            </div>
            <div class="card-body">
              <div class="form-group m-3">
                <label for="count">ガチャ回数</label>
                <Field name="count" v-model.number="gacha.count" class="form-control" :rules="isNumericRequired" />
                <div class="text-danger"><ErrorMessage name="count" /></div>
              </div>
              <div class="form-group m-3">
                <label for="date">ガチャを引いた日付</label>
                <Field name="date" type="date" v-model="gacha.date" class="form-control" />
                <div class="text-danger"><ErrorMessage name="date" /></div>
              </div>
              <div class="form-group m-3">
                <label for="currency_package">換算用データ</label>
                <Field as="select" name="currency_package_id" id="currency_package" v-model.number="gacha.currency_package_id" class="form-control">
                  <option v-for="(currency_package, index) in currencyPackages" :key="index" :value="currency_package.id">{{ currency_package.name }}</option>
                </Field>
              </div>
              <div class="form-group m-3">
                <label for="description">備考</label>
                <Field as="textarea" name="description" id="description" v-model="gacha.description" style="width:100%" rows="3" />
              </div>
              <div class="text-end m-3 mt-5">
                <button class="btn btn-primary">作成</button>
              </div>
            </div>
          </Form>
        </div>
      </div>
    </div>
    {{ gacha }}
    {{ currencyPackages }}
  </div>
</div>
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
    }
  },
  computed: {
    ...mapGetters('gacha_records', [
        "currencyPackages",
        "gachas"
    ]),
  },
  created() {
    this.fetchPackages();
  },
  methods: {
    ...mapActions('gacha_records', [
        "fetchPackages",
        "createGacha",
    ]),
    async handleCreateGacha(gacha) {
        try {
            await this.createGacha(gacha)
            this.$router.push({ name: 'Gacha' })
        } catch (error) {
        console.log(error)
        }
    },
    isNumericRequired(value) {
      if (!value.match(/^[0-9]*$/)) {
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