<template>
<div class="bg mb-3 p-3 rounded shadow">
  <div class="h5 text-white">合計</div>
    <hr class="bg-white">
    <div class="h4 text-white text-center">{{ totalAmount }}円</div>
  </div>
  <div class="bg rounded shadow p-3">
    <div class="h5 text-white text-center">換算合計</div>
      <RecordPart v-for="(totalRecord, index) in totalRecords"
        :totalRecord="totalRecord"
        :key="totalRecord.id"
        :id="'totalrecord-' + (index + 1)"
        @toGameFullData="toGameFullData(totalRecord.id)"
      />
  </div>
</template>

<script>
import { mapGetters, mapActions } from 'vuex';
import RecordPart from './RecordPart.vue';

export default {
  name: 'TotalRecord',
  components: {
    RecordPart
  },
  computed: {
    ...mapGetters('gachas', ["gachas", "currencyPackages", "totalRecords", "totalAmount"]),
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
    toGameFullData(int) {
      this.$router.push({ name: 'GameFullData', params: { id: int} })
    }
  },
}
</script>

<style scoped>
.bg {
  background-color: steelblue;
}
</style>