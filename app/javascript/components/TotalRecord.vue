<template>
<div class="bg-secondary mb-3 p-3 rounded shadow">
  <div class="h5 text-white">合計</div>
    <hr>
    <div class="h4 text-white text-center">{{ totalRecord }}円</div>
  </div>
  <div class="bg-secondary rounded shadow p-3">
    <div class="h5 text-white text-center">換算合計</div>
    <div v-for="totalRecord in totalRecords" class="bg-white border shadow-sm rounded my-2 py-2">
      <div class="container border-bottom pb-2">
        <div class="row">
          <div>
            <span>{{ totalRecord.game_name }}</span>
          </div>
        </div>
      </div>
      <div class="container border-bottom py-2">
        <div class="row">
          <div class="col-4 text-center border-end">
            <span>金額</span>
          </div>
          <div class="col-8 text-center">
            <span>{{ amount(totalRecord.gacha_count, totalRecord.need_one_gacha_price) }}円</span>
          </div>
        </div>
      </div>
      <div class="container pt-2">
        <div class="row">
          <div class="col-4 text-center border-end">
            <span>回数</span>
          </div>
          <div class="col-8 text-center">
            <span>{{ totalRecord.gacha_count }}回</span>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { mapGetters, mapActions } from 'vuex';

export default {
  name: 'TotalRecord',
  data() {
    return {
        total_sub: 0,
    }
  },
  computed: {
    ...mapGetters('gachas', ["gachas", "currencyPackages", "totalRecords", "totalRecord"]),
    total() {
        return this.total_sub
    },
  },
  created() {
    this.fetchGachas();
    this.fetchPackages();
  },
  methods: {
    ...mapActions('gachas', ["fetchGachas", "fetchPackages"]),
    amount(gacha_count, need_one_gacha_price) {
        return Math.round(gacha_count*need_one_gacha_price)
    },
    sum() {
        
    },
  },
}
</script>