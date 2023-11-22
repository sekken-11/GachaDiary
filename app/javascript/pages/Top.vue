<template>
  <div>
    <v-container>
      <v-row>
        <v-col cols="12" md="8">
          <v-card class="bg-white shadow" id="top-form">
            <v-card-text class="text-center my-3 text-muted">
              <p>あなたの所持するガチャ石の数・ガチャ石の価格を入力してください</p>
              <p>現金換算で何円分になるか計算いたします</p>
            </v-card-text>
            <Form @submit="handleConversion">
              <v-card-text class="m-3">
                <div class="form-group mb-5">
                    <label for="posses_stone" class="mb-1">ガチャ石の個数</label>
                    <Field name="posses_stone" id="posses_stone" v-model.number="posses_stone" class="form-control" type="text" placeholder="現金換算したい石の個数を入力してください（個）" :rules="isNumericRequired" />
                    <div class="text-danger"><ErrorMessage name="posses_stone" id="posses_stone_error" /></div>
                </div>
                <div class="form-group my-5">
                    <label for="stone_price" class="mb-1">ガチャ石の価格</label>
                    <Field name="price" id="stone_price" v-model.number="stone_price" class="form-control" type="text" placeholder="購入する際の金額を入力してください（円）" :rules="isNumericRequired" />
                    <div class="text-danger"><ErrorMessage name="price" id="stone_price_error" /></div>
                    <label for="stone_quantity"></label>
                    <Field name="quantity" id="stone_quantity" v-model.number="stone_quantity" class="form-control" type="text" placeholder="購入する際の個数を入力してください（個）" :rules="isNumericRequired" />
                    <div class="text-danger"><ErrorMessage name="quantity" id="stone_quantity_error" /></div>
                </div>
                <div class="form-group mb-5">
                  <label for="game" class="mb-1">ゲーム名*任意</label>
                  <input id="game" v-model="game_name" class="form-control" type="text">
                </div>
                <div class="form-group">
                  <label for="game_select" class="mb-1">ゲーム選択</label>
                  <select v-model="select" class="form-control" id="select">
                    <option value="" selected>ゲームを選択しない</option>
                    <option v-for="(initialPackage, index) in initialPackages" :key="initialPackage.id" :value="index">
                      {{ initialPackage.name }}
                    </option>
                  </select>
                </div>
                <div class="text-center">
                  <v-btn block type="submit" class="mt-5" color="primary">追加</v-btn>
                </div>
              </v-card-text>
            </Form>
          </v-card>
        </v-col>
        <v-col cols="12" md="4">
          <div class="amount mb-3 p-3 rounded shadow" id="total">
            <div class="h5 text-white">合計</div>
            <hr class="bg-white">
            <div class="h4 text-white text-center">{{ total }}円</div>
          </div>
          <div class="amount rounded shadow p-3">
            <div class="h5 text-white text-center">換算履歴</div>
              <div v-for="(conversion_record, index) in conversion_records" :id="'record-' + (index + 1)" :key="conversion_record" class="bg-white border shadow-sm rounded my-2">
                <v-container>
                  <v-row class="border-bottom pb-2">
                    <v-col cols="9">
                      <span>{{ conversion_record.name }}</span>
                    </v-col>
                    <v-col cols="3">
                      <div class="d-flex justify-content-end">
                        <button type="button" class="btn-close" @click="handleDelete(index)" :id="'delete-' + (index + 1)"></button>
                      </div>
                    </v-col>
                  </v-row>
                  <v-row class="pt-2">
                    <v-col cols="6" class="text-center border-end">
                      <span>{{ conversion_record.price }}円</span>
                    </v-col>
                    <v-col cols="6" class="text-center">
                      <span>{{ conversion_record.posses_stone }}個</span>
                    </v-col>
                  </v-row>
                </v-container>
              </div>
          </div>
        </v-col>
      </v-row>
    </v-container>
  </div>
</template>

<script>
import { Field, Form, ErrorMessage } from 'vee-validate';
import { mapGetters, mapActions } from 'vuex';
import TotalRecord from '../components/TotalRecord.vue';

export default {
  name: "Top",
  components: {
    Field,
    Form,
    ErrorMessage,
    TotalRecord,
  },
  data() {
    return {
      title: "タスク管理アプリ",
      cash_conversion: 0,
      total : 0,
      posses_stone: '',
      stone_quantity: '',
      stone_price: '',
      game_name: '',
      conversion_records_sub: [],
      store: [],
      select: ''
    }
  },
  computed: {
    conversion_records() {
      return this.conversion_records_sub;
    },
    ...mapGetters('users', ["authUser"]),
    ...mapGetters('gachas', ["initialPackages"]),
  },
  created() {
    this.fetchInitialPackages();
  },
  watch: {
    select() {
      const set_package = this.initialPackages[this.select]
      this.stone_price = set_package.price
      this.stone_quantity = set_package.quantity
      this.game_name = set_package.name
    },
  },
  methods: {
    ...mapActions('gachas', ["fetchInitialPackages"]),
    handleConversion() {
      this.cash_conversion = Math.round(this.stone_price/this.stone_quantity*this.posses_stone);
      this.conversion_records_sub.push({ name: this.game_name, price: this.cash_conversion, posses_stone: this.posses_stone });
      this.total += this.cash_conversion;
      this.store.push(this.cash_conversion);
    },
    handleDelete(index) {
      this.conversion_records_sub.splice(index, 1);
      this.total -= this.store[index];
      this.store.splice(index, 1);
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
  }
}
</script>

<style scoped>
.amount{
  background-color: steelblue;
}
</style>