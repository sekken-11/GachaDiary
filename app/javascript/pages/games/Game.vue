<template>
<div class="btn-primary rounded mb-3 p-2 text-center" @click="toCreate">
  <span class="text-white">ゲームごとの石の所持データ 新規作成</span>
</div>
<div class="bg-white rounded shadow p-3 mb-3">
  <div class="text-secondary">
    <span>合計</span>
  </div>
  <hr>
  <div class="text-center h3">
    <span>{{ totalStones }}円</span>
  </div>
</div>

<PossesStonesPart :possesStones="possesStones">ゲームごとの石の所持データ</PossesStonesPart>

</template>

<script>
import { mapGetters, mapActions } from 'vuex';
import PossesStonesPart from '../../components/PossesStonesPart.vue';


export default {
    name: "Game",
    components: {
        PossesStonesPart
    },
    computed: {
        ...mapGetters('posses_stones', ["possesStones"]),
        totalStones() {
            const ary = this.possesStones.map(h => Math.round(h.currency_package.price/h.currency_package.quantity*h.quantity));
            if (ary.length != 0) {
                return ary.reduce((a, b) => { return a + b });
            } else {
                return 0;
            }
        },
    },
    created() {
        this.fetchPossesStones();
    },
    methods: {
        ...mapActions('posses_stones',[
            "fetchPossesStones",
            ]),
        toCreate() {
            this.$router.push({ name: 'GameCreate' })
        },
        amount(price, quantity, stone) {
            return Math.round(price/quantity*stone)
        },
    }
}
</script>