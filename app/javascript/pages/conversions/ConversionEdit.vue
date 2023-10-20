<template>
<v-card class="shadow mb-3">
  <v-card-title class="bg-white py-3">
    <span>換算用データ 編集</span>
  </v-card-title>
  <v-card-text>
    <Form @submit="handleEditPackage">
      <div class="form-group m-3">
        <label for="name">ゲーム名</label>
        <Field name="name" v-model="currencyPackage.name" class="form-control" :rules="isRequired" />
        <ErrorMessage name="name" class="text-danger" />
      </div>
      <div class="form-group m-3">
        <label for="name">ガチャ一回に必要なガチャ石</label>
        <Field name="need_one_gacha_stones" v-model.number="currencyPackage.need_one_gacha_stones" class="form-control" :rules="isNumericRequired" />
        <ErrorMessage name="need_one_gacha_stones" class="text-danger" />
      </div>
      <div class="form-group m-3">
        <label>ガチャ石の価格</label>
        <div class="mb-1">
          <Field name="price" v-model.number="currencyPackage.price" class="form-control" :rules="isNumericRequired" placeholder="購入する際の金額を入力してください（円）" />
          <ErrorMessage name="price" class="text-danger" />
        </div>
        <div>
          <Field name="quantity" v-model.number="currencyPackage.quantity" class="form-control" :rules="isNumericRequired" placeholder="購入する際の個数を入力してください（個）" />
          <ErrorMessage name="quantity" class="text-danger" />
        </div>
      </div>
      <div class="text-end m-3 mt-5">
        <v-btn block color="success" type="submit">変更</v-btn>
      </div>
    </Form>
  </v-card-text>
</v-card>
</template>

<script>
import { Field, Form, ErrorMessage } from 'vee-validate';
import { mapGetters, mapActions } from 'vuex';

export default {
    name: "ConversionEdit",
    components: {
        Form,
        Field,
        ErrorMessage
    },
    computed: {
        ...mapGetters('gachas', ["currencyPackage"]),
    },
    created() {
        this.fetchPackage(this.$route.params.id);
    },
    methods: {
        ...mapActions('gachas', [
            "fetchPackage",
            "editPackage"
        ]),
        async handleEditPackage() {
            try {
                await this.editPackage(this.currencyPackage)
                this.$router.push({ name: 'Conversion' })
            } catch (error) {
            console.log(error)
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
        isRequired(value) {
            if (!value && !value.trim()) {
                return '入力してください';
            }
            return true;
        },
    },
}
</script>