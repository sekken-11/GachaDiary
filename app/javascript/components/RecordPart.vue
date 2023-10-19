<template>
<div
  class="records shadow-sm rounded my-2 p-2" 
  :class="{ 'here': $route.path.slice(10) == totalRecord.id }" 
  @click="toGameFullData(totalRecord.id)" 
>
  <v-container>
    <v-row class="border-bottom pb-2">
      <div>
        <span>{{ totalRecord.game_name }}</span>
      </div>
    </v-row>
    <v-row class="border-bottom py-2">
      <div class="col-4 text-center border-end">
        <span>金額</span>
      </div>
      <div class="col-8 text-center">
        <span>{{ amount(totalRecord.gacha_count, totalRecord.need_one_gacha_price) }}円</span>
      </div>
    </v-row>
    <v-row class="pt-2">
      <div class="col-4 text-center border-end">
        <span>回数</span>
      </div>
      <div class="col-8 text-center">
        <span>{{ totalRecord.gacha_count }}回</span>
      </div>
    </v-row>
  </v-container>
</div>
</template>

<script>
export default {
  name: 'RecordPart',
  props: ['totalRecord'],
  methods: {
    amount(gacha_count, need_one_gacha_price) {
        return Math.round(gacha_count*need_one_gacha_price)
    },
    toGameFullData(int) {
      this.$emit('toGameFullData', int)
    }
  },
}
</script>

<style scoped>
.records{
  background-color: white;
}
.records:hover{
  background-color: lightgray;
}
.here{
  background-color: silver;
}
</style>