<template>
<v-card class="shadow mb-3">
  <v-card-title class="bg-white py-3">
    <span>ゲームごとの石の所持データ作成</span>
  </v-card-title>
  <v-card-text>
    <Form @submit="handleCreatePossesStone">
      <div class="form-group m-3">
        <label for="quantity">石の所持数</label>
        <Field name="quantity" v-model.number="user_posses_stone.quantity" class="form-control" :rules="isNumericRequired" />
        <ErrorMessage name="quantity" class="text-danger" />
      </div>
      <div class="form-group m-3">
        <label for="currency_package">換算用データ</label>
        <Field as="select" name="currency_package_id" id="currency_package" v-model.number="user_posses_stone.currency_package_id" class="form-control">
          <option v-for="(currency_package, index) in currencyPackages" :key="index" :value="currency_package.id">{{ currency_package.name }}</option>
        </Field>
      </div>
      <div class="text-end m-3 mt-5">
        <v-btn block color="info">作成</v-btn>
      </div>
    </Form>
  </v-card-text>
</v-card>
</template>

<script>
import { Field, Form, ErrorMessage } from 'vee-validate';
import { mapGetters, mapActions } from 'vuex';

export default {
    name: "GameCreate",
    components: {
        Form,
        Field,
        ErrorMessage
    },
    data() {
        return {
            user_posses_stone: {
                quantity: '',
                currency_package_id: '',
            },
        }
    },
    computed: {
        ...mapGetters('gachas', ["currencyPackages"])
    },
    created() {
        this.fetchPackages();
    },
    methods: {
        ...mapActions('gachas', ["fetchPackages",]),
        ...mapActions('posses_stones', ["createPossesStone"]),
        async handleCreatePossesStone(posses_stone) {
            try {
                await this.createPossesStone(posses_stone)
                this.$router.push({ name: 'Game' })
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