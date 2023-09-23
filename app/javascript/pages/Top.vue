<template>
  <div class="py-3">
    <div class="container">
      <div class="row">
        <div class="col-12 col-md-8">
          <div class="card bg-light">
            <div class="card-header">
              <div class="card-text text-center m-3">
                <p>あなたの所持するガチャ石の数・ガチャ石の価格を入力してください</p>
                <p>現金換算で何円分になるか計算いたします</p>
              </div>
            </div>
            <div class="card-body m-3">
              <div class="form-group mb-5">
                <label for="posses_stone" class="mb-1">ガチャ石の個数</label>
                <input id="posses_stone" v-model.number="gacha.posses_stone" class="form-control" type="text" style="width:75%" placeholder="現金換算したい石の個数を入力してください（個）">
              </div>
              <div class="form-group my-5">
                <label for="currency_package" class="mb-1">ガチャ石の価格</label>
                <input id="stone_quantity" v-model.number="gacha.stone_quantity" class="form-control mb-3" type="text" style="width:75%" placeholder="購入する際の個数を入力してください（個）">
                <input id="stone_price" v-model.number="gacha.stone_price" class="form-control" type="text" style="width:75%" placeholder="購入する際の金額を入力してください（円）">
              </div>
              <div class="form-group">
                <label for="game" class="mb-1">ゲーム名*任意</label>
                <input id="game" v-model="gacha.game" class="form-control" type="text" style="width:75%">
              </div>
            </div>
            <div class="card-footer text-center">
              <button type="button" class="btn btn-primary my-3" @click="handleConversion">
                追加
              </button>
            </div>
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
              <div v-for="(conversion_record, index) in conversion_records" :key="index" :id="'record-' + index" class="bg-white border shadow-sm rounded my-2 py-2">
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
          <div>
            <div class="text-center">
              <h4>{{ conversion_records_sub }}</h4>
              <h4>{{ total }}</h4>
              <h4>{{ store }}</h4>
              <router-link :to="{ name: 'Task' }" class="btn btn-dark mt-5">はじめる</router-link>
            </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: "Top",
  data() {
    return {
      title: "タスク管理アプリ",
      cash_conversion: 0,
      total : 0,
      gacha: {
        posses_stone: '',
        stone_quantity: '',
        stone_price: '',
        game: ''
      },
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
      this.cash_conversion = Math.round(this.gacha.stone_price/this.gacha.stone_quantity*this.gacha.posses_stone);
      this.conversion_records_sub.push({ name: this.gacha.game, price: this.cash_conversion, posses_stone: this.gacha.posses_stone });
      this.total += this.cash_conversion;
      this.store.push(this.cash_conversion);
    },
    handleDelete(index) {
      this.conversion_records_sub.splice(index, 1);
      this.total -= this.store[index];
      this.store.splice(index, 1);
    }
  }
}
</script>

<style scoped>
</style>