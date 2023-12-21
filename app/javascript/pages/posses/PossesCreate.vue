<template>
  <v-card class="shadow mb-3">
    <v-card-title class="bg-white py-3">
      <span class="form-title">ゲームごとの石の所持データ作成</span>
    </v-card-title>
    <v-card-text>
      <Form @submit="handleCreatePossesStone" id="posses-form">
        <div class="form-group m-3">
          <label for="quantity" class="form-label">石の所持数</label>
          <Field
            name="quantity"
            id="quantity"
            v-model.number="user_posses_stone.quantity"
            class="form-control"
            :rules="isNumericRequired"
          />
          <ErrorMessage
            name="quantity"
            id="quantity_error"
            class="text-danger"
          />
        </div>
        <div class="form-group m-3">
          <label for="currency_package" class="form-label">換算用データ</label>
          <br>
          <label for="initial_package" class="my-1">初期登録データを除く</label>
          <input type="checkbox" id="initial_package" name="initial_package" v-model="checked">
          <Field
            as="select"
            name="currency_package_id"
            id="currency_package"
            v-model.number="user_posses_stone.currency_package_id"
            class="form-control"
          >
            <option
              v-for="(currency_package, index) in checkedPackeges"
              :key="index"
              :value="currency_package.id"
            >
              {{ currency_package.name }}
            </option>
          </Field>
        </div>
        <div class="text-end m-3 mt-5">
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
  name: "PossesCreate",
  components: {
    Form,
    Field,
    ErrorMessage,
  },
  data() {
    return {
      user_posses_stone: {
        quantity: "",
        currency_package_id: "",
      },
      checked: false,
    };
  },
  computed: {
    ...mapGetters("gachas", ["currencyPackages"]),
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
  },
  methods: {
    ...mapActions("gachas", ["fetchPackages"]),
    ...mapActions("posses_stones", ["createPossesStone"]),
    ...mapActions("transition", ["addMessage"]),
    async handleCreatePossesStone(posses_stone) {
      try {
        await this.createPossesStone(posses_stone);
        this.$router.push({ name: "Posses" });
        this.addMessage({
          message: "所持ガチャ石記録を作成しました",
          messageType: "success",
        });
      } catch (error) {
        console.log(error);
        this.addMessage({
          message: "所持ガチャ石記録の作成に失敗しました",
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
