<template>
  <div class="py-3">
    <div class="container">
      <div class="row">
        <div class="col-12 col-md-8">
          <div class="card bg-white shadow">
            <div class="card-header bg-white">
              <div class="card-text text-center m-3">
                <p>あなたの所持するガチャ石の数・ガチャ石の価格を入力してください</p>
                <p>現金換算で何円分になるか計算いたします</p>
              </div>
            </div>
            <Form @submit="handleConversion">
            <div class="card-body m-3">
              <div class="form-group mb-5">
                  <label for="posses_stone" class="mb-1">ガチャ石の個数</label>
                  <Field name="posses_stone" id="posses_stone" v-model.number="posses_stone" class="form-control" type="text" style="width:75%" placeholder="現金換算したい石の個数を入力してください（個）" :rules="isNumericRequired" />
                  <div class="text-danger"><ErrorMessage name="posses_stone" /></div>
              </div>
              <div class="form-group my-5">
                <label for="currency_package" class="mb-1">ガチャ石の価格</label>
                <div class="mb-3">
                <Field name="quantity" id="stone_quantity" v-model.number="stone_quantity" class="form-control" type="text" style="width:75%" placeholder="購入する際の個数を入力してください（個）" :rules="isNumericRequired" />
                <div class="text-danger"><ErrorMessage name="quantity" /></div>
                </div>
                <Field name="price" id="stone_price" v-model.number="stone_price" class="form-control" type="text" style="width:75%" placeholder="購入する際の金額を入力してください（円）" :rules="isNumericRequired" />
                <div class="text-danger"><ErrorMessage name="price" /></div>
              </div>
              <div class="form-group">
                <label for="game" class="mb-1">ゲーム名*任意</label>
                <input id="game" v-model="game_name" class="form-control" type="text" style="width:75%">
              </div>
            </div>
            <div class="card-footer text-center bg-white">
              <button type="submit" class="btn btn-primary my-3">
                追加
              </button>
            </div>
            </Form>
          </div>
        </div>
        <div class="col-12 col-md-4">
          <div class="bg-secondary mb-3 p-3 rounded shadow">
            <div class="h5 text-white">合計</div>
            <hr>
            <div class="h4 text-white text-center">{{ total }}円</div>
          </div>
          <div class="bg-secondary rounded shadow p-3">
            <div class="h5 text-white text-center">換算履歴</div>
              <div v-for="(conversion_record, index) in conversion_records" :key="conversion_record" :id="'record-' + index" class="bg-white border shadow-sm rounded my-2 py-2">
                <div class="container border-bottom pb-2">
                  <div class="row">
                    <div class="col-9">
                      <span>{{ conversion_record.name }}</span>
                    </div>
                    <div class="col-3">
                      <div class="d-flex justify-content-end">
                        <button type="button" class="btn-close" @click="handleDelete(index)"></button>
                      </div>
                    </div>
                  </div>
                </div>
                <div class="container pt-2">
                  <div class="row">
                    <div class="col-6 text-center border-end">
                      <span>{{ conversion_record.price }}円</span>
                    </div>
                    <div class="col-6 text-center">
                      <span>{{ conversion_record.posses_stone }}個</span>
                    </div>
                  </div>
                </div>
              </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { Field, Form, ErrorMessage } from 'vee-validate';

export default {
  name: "Top",
  components: {
    Field,
    Form,
    ErrorMessage,
  },
  data() {
    return {
      title: "タスク管理アプリ",
      cash_conversion: 0,
      total : 0,
      posses_stone: '',
      stone_quantity: '',
      stone_price: '',
      game: '',
      conversion_records_sub: [],
      store: []
    }
  },
  computed: {
    conversion_records() {
      return this.conversion_records_sub;
    },
  },
  methods: {
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
      if (!value.match(/^[0-9]*$/)) {
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
</style>