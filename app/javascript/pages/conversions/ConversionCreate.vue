<template>
<div class="card shadow mb-3">
  <div class="card-header bg-white py-3">
    <span>換算用データ作成</span>
  </div>
  <div class="card-body">
    <Form @submit="handleCreatePackage">
      <div class="form-group m-3">
        <label for="name">ゲーム名</label>
        <Field name="name" v-model="currency_package.name" class="form-control" :rules="isRequired" />
        <ErrorMessage name="name" class="text-danger" />
      </div>
      <div class="form-group m-3">
        <label for="name">ガチャ一回に必要なガチャ石</label>
        <Field name="need_one_gacha_stones" v-model.number="currency_package.need_one_gacha_stones" class="form-control" :rules="isNumericRequired" />
        <ErrorMessage name="need_one_gacha_stones" class="text-danger" />
      </div>
      <div class="form-group m-3">
        <label>ガチャ石の価格</label>
        <div class="mb-1">
          <Field name="quantity" v-model.number="quantity" class="form-control" :rules="isNumericRequired" placeholder="購入する際の個数を入力してください（個）" />
          <ErrorMessage name="quantity" class="text-danger" />
        </div>
        <div>
          <Field name="price" v-model.number="price" class="form-control" :rules="isNumericRequired" placeholder="購入する際の金額を入力してください（円）" />
          <ErrorMessage name="price" class="text-danger" />
        </div>
      </div>
      <div class="text-end m-3 mt-5">
        <button class="btn btn-primary">作成</button>
      </div>
    </Form>
  </div>
</div>
</template>

<script>
import { Field, Form, ErrorMessage } from 'vee-validate';
import { mapGetters, mapActions } from 'vuex';

export default {
    name: "ConversionCreate",
    components: {
        Form,
        Field,
        ErrorMessage
    },
    data() {
        return {
            currency_package: {
                name: '',
                need_one_gacha_stones: '',
                price: '',
                quantity: '',
            },
        }
    },
    computed: {
        ...mapGetters('gacha_records', ["currencyPackages"])
    },
    methods: {
        ...mapActions('gacha_records', ["createPackage",]),
        async handleCreatePackage(currency_package) {
            try {
                await this.createPackage(currency_package)
                this.$router.push({ name: 'Conversion' })
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
        isRequired(value) {
            if (!value && !value.trim()) {
                return '入力してください';
            }
            return true;
        },
    },
}
</script>