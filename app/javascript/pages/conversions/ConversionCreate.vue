<template>
  <v-card class="shadow mb-3">
    <v-card-title class="bg-white py-3">
      <span class="form-title">換算用データ作成</span>
    </v-card-title>
    <v-card-text>
      <Form @submit="handleCreatePackage" id="currency_package-form">
        <div class="form-group m-3">
          <label for="name" class="form-label">ゲーム名</label>
          <Field
            name="name"
            id="name"
            v-model="currency_package.name"
            class="form-control"
            :rules="isRequired"
          />
          <ErrorMessage name="name" id="name_error" class="text-danger" />
        </div>
        <div class="form-group m-3">
          <label for="need_one_gacha_stones" class="form-label">ガチャ一回に必要なガチャ石</label>
          <Field
            name="need_one_gacha_stones"
            id="need_one_gacha_stones"
            v-model.number="currency_package.need_one_gacha_stones"
            class="form-control"
            :rules="isNumericRequired"
          />
          <ErrorMessage
            name="need_one_gacha_stones"
            id="need_one_gacha_stones_error"
            class="text-danger"
          />
        </div>
        <div class="form-group m-3">
          <div>
            <label for="stone_price" class="form-label">ガチャ石の価格</label>
            <Field
              name="price"
              id="stone_price"
              v-model.number="price"
              class="form-control"
              :rules="isNumericRequired"
              placeholder="購入する際の金額を入力してください（円）"
            />
            <ErrorMessage
              name="price"
              id="stone_price_error"
              class="text-danger"
            />
          </div>
          <div>
            <label for="stone_quantity"></label>
            <Field
              name="quantity"
              id="stone_quantity"
              v-model.number="quantity"
              class="form-control"
              :rules="isNumericRequired"
              placeholder="購入する際の個数を入力してください（個）"
            />
            <ErrorMessage
              name="quantity"
              id="stone_quantity_error"
              class="text-danger"
            />
          </div>
        </div>
        <div class="m-3 mt-5">
          <v-btn block color="info" type="submit">作成</v-btn>
        </div>
      </Form>
    </v-card-text>
  </v-card>
</template>

<script>
import { Field, Form, ErrorMessage } from "vee-validate";
import { mapGetters, mapActions } from "vuex";

export default {
  name: "ConversionCreate",
  components: {
    Form,
    Field,
    ErrorMessage,
  },
  data() {
    return {
      currency_package: {
        name: "",
        need_one_gacha_stones: "",
        price: "",
        quantity: "",
      },
    };
  },
  computed: {
    ...mapGetters("gachas", ["currencyPackages"]),
  },
  methods: {
    ...mapActions("gachas", ["createPackage"]),
    ...mapActions("transition", ["addMessage"]),
    async handleCreatePackage(currency_package) {
      try {
        await this.createPackage(currency_package);
        this.$router.push({ name: "Conversion" });
        this.addMessage({
          message: "換算用データを作成しました",
          messageType: "success",
        });
      } catch (error) {
        console.log(error);
        this.addMessage({
          message: "換算用データの作成に失敗しました",
          messageType: "danger",
        });
      }
    },
    isNumericRequired(value) {
      if (!value.toString().match(/^[0-9]*$/)) {
        return "半角数字で入力してください";
      }
      if (!value && !value.trim()) {
        return "入力してください";
      }
      return true;
    },
    isRequired(value) {
      if (!value && !value.trim()) {
        return "入力してください";
      }
      return true;
    },
  },
};
</script>
