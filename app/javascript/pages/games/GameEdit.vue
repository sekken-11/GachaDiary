<template>
<div class="card shadow mb-3">
  <div class="card-header bg-white py-3">
    <span>ゲームごとの石の所持データ 編集</span>
  </div>
  <div class="card-body">
    <Form @submit="handleEditPossesStone">
      <div class="form-group m-3">
        <label for="quantity">石の所持数</label>
        <Field name="quantity" v-model.number="possesStone.quantity" class="form-control" :rules="isNumericRequired" />
        <ErrorMessage name="quantity" class="text-danger" />
      </div>
      <div class="form-group m-3">
        <label for="currency_package">換算用データ</label>
        <Field as="select" name="currency_package_id" id="currency_package" v-model.number="possesStone.currency_package_id" class="form-control">
          <option v-for="(currency_package, index) in currencyPackages" :key="index" :value="currency_package.id">{{ currency_package.name }}</option>
        </Field>
      </div>
      <div class="text-end m-3 mt-5">
        <v-btn block class="bg-success" type="submit">変更</v-btn>
      </div>
    </Form>
  </div>
</div>
</template>

<script>
import { Field, Form, ErrorMessage } from 'vee-validate';
import { mapGetters, mapActions } from 'vuex';

export default {
    name: "GameEdit",
    components: {
        Form,
        Field,
        ErrorMessage
    },
    computed: {
        ...mapGetters('gachas', ["currencyPackages"]),
        ...mapGetters('posses_stones', ["possesStone"])
    },
    created() {
        this.fetchPackages();
        this.fetchPossesStone(this.$route.params.id);
    },
    methods: {
        ...mapActions('gachas', ["fetchPackages",]),
        ...mapActions('posses_stones', [
            "editPossesStone",
            "fetchPossesStone",
        ]),
        async handleEditPossesStone() {
            try {
                await this.editPossesStone(this.possesStone)
                this.$router.back()
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