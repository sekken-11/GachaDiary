<template>
<div id="gamename" class="bg-white rounded shadow p-3 mb-3">
  <span class="text-success">{{ currencyPackage.name }}</span>
  <span class="text-muted"> の 記録一覧</span>
</div>
<div id="gamedata" class="bg-white rounded shadow p-3 mb-3">
  <div class="text-center mb-2">
    <span class="text-muted">合計</span>
  </div>
  <div class="text-center h3">
    <span>{{specificTotalAmount}}円</span>
  </div>
  <hr class="m-3">
  <div class="text-center mb-2">
    <span class="text-muted">現金換算データ</span>
  </div>
  <v-container>
    <v-row>
      <v-col cols="6" class="border-end text-center">
        <span>{{ currencyPackage.price }}円／{{ currencyPackage.quantity }}個</span>
      </v-col>
      <v-col cols="6" class="text-center">
        <span>{{ currencyPackage.need_one_gacha_stones }}個／1回</span>
      </v-col>
    </v-row>
  </v-container>
</div>

<PossesStonesPart :possesStones="specificPossesStones">石の所持データ</PossesStonesPart>

<div id="search-form">
  <div class="form-group mb-3">
    <input type="text" v-model="search" class="form-control" id="search" placeholder="絞り込み">
  </div>
</div>

<GachaRecordPart :gachas="specificGachas" :perPage="perPage" :search="search">データがありません</GachaRecordPart>

</template>

<script>
import { mapGetters, mapActions } from 'vuex';
import PossesStonesPart from '../components/PossesStonesPart.vue';
import GachaRecordPart from '../components/GachaRecordPart.vue';


export default {
    name: "GameFullData",
    components: {
        PossesStonesPart,
        GachaRecordPart,
    },
    data() {
        return {
            perPage: 5,
            search: this.search = this.$route.query.search || '',
        }
    },
    computed: {
        ...mapGetters('gachas', [
            "currencyPackage",
            "specificGachas"
        ]),
        ...mapGetters('posses_stones',[
            "possesStones",
        ]),
        gameId() {
            return this.$route.params.id
        },
        specificPossesStones() {
            return this.possesStones.filter(possesStone => {
                return possesStone.currency_package_id == this.currencyPackage.id
            })
        },
        specificTotalAmount() {
            var amount = 0
            const one_stone_price = this.currencyPackage.price/this.currencyPackage.quantity
            this.specificGachas.forEach(gacha => {
                amount += Math.round(one_stone_price*gacha.currency_package.need_one_gacha_stones*gacha.count)
            })
            this.specificPossesStones.forEach(possesStone => {
                amount += Math.round(one_stone_price*possesStone.quantity)
            })
            return amount
        },
    },
    watch: {
        gameId() {
            this.fetchPackage(this.gameId);
            this.fetchGachas();
            this.fetchPossesStones();
            this.search = ''
        }
    },
    created() {
        this.fetchGachas();
        this.fetchPackage(this.$route.params.id);
        this.fetchPossesStones();
    },
    methods: {
        ...mapActions('gachas', [
            "fetchGachas",
            "fetchPackage"
        ]),
        ...mapActions('posses_stones',[
            "fetchPossesStones",
        ]),
    },
}
</script>