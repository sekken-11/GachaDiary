<template>
<div class="bg-white rounded shadow p-3 mb-3">
  <span class="text-success">{{ currencyPackage.name }}</span>
  <span class="text-muted"> の 記録一覧</span>
</div>
<div class="bg-white rounded shadow p-3 mb-3">
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
  <div class="container">
    <div class="row">
      <div class="col-6 border-end text-center">
        <span>{{ currencyPackage.price }}円／{{ currencyPackage.quantity }}個</span>
      </div>
      <div class="col-6 text-center">
        <span>{{ currencyPackage.need_one_gacha_stones }}個／1回</span>
      </div>
    </div>
  </div>
</div>
<PossesStonesPart :possesStones="specificPossesStones">石の所持データ</PossesStonesPart>
<div class="form-row" id="search-form">
  <div class="form-group mb-3">
    <input type="text" v-model="search" class="form-control" id="search" placeholder="絞り込み">
  </div>
</div>
<div class="bg-white rounded shadow p-3 mb-3">
  <div class="text-center text-muted">
    <span>ガチャ記録 一覧</span>
  </div>
  <hr>
  <div v-if="filteredGachas.length == 0" class="text-center text-secondary p-3">
    <span>データがありません</span>
  </div>
    <div v-for="gacha in getList"
         :key="gacha.id"
         class="bg-light border shadow-sm rounded my-2 py-2"
    >
      <div class="container border-bottom pb-2">
        <div class="row">
          <div class="col-6">{{ gacha.date }}</div>
          <div class="col-6 text-center">{{ Math.round(currencyPackage.price/currencyPackage.quantity*currencyPackage.need_one_gacha_stones*gacha.count) }}円</div>
        </div>
      </div>
      <div class="container border-bottom py-2">
        <div class="row">
          <div class="col-6">{{ gacha.currency_package.name }}</div>
          <div class="col-6 text-center">{{ gacha.count }}回</div>
        </div>
      </div>
      <div class="pt-2 px-4">
        <ul class="text-end mb-0">
          <button class="btn btn-sm btn-outline-info me-2" @click="handleOpenDetail(gacha)">詳細</button>
          <button class="btn btn-sm btn-outline-success me-2" @click="toEdit(gacha.id)">編集</button>
          <button class="btn btn-sm btn-outline-danger" @click="handleOpenDelete(gacha)">削除</button>
        </ul>
      </div>
    </div>
</div>
<v-pagination
  v-model="currentPage"
  v-scroll-to="'#top'"
  :length="getPageCount"
  @click="pageChange"
>
</v-pagination>

  <transition name="fade">
    <GachaDetailModal v-if="isVisibleDetail" :gacha="gacha" @Close="handleClose" />
  </transition>

  <transition name="fade">
    <DeleteModal v-if="isVisibleDelete" :deleteData="gacha" @Close="handleClose" @Delete="handleDeleteGacha" />
  </transition>

</template>

<script>
import { mapGetters, mapActions } from 'vuex';
import GachaDetailModal from './gachas/GachaDetailModal.vue';
import DeleteModal from '../components/DeleteModal.vue';
import PossesStonesPart from '../components/PossesStonesPart.vue';

export default {
    name: "GameFullData",
    components: {
        GachaDetailModal,
        DeleteModal,
        PossesStonesPart,
    },
    data() {
        return {
            currentPage: this.currentPage = this.pageNumber || 1,
            perPage: 5,
            search: this.search = this.$route.query.search || '',
            isVisibleDetail: false,
            isVisibleDelete: false,
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
        getPageCount() {
            return Math.ceil(this.filteredGachas.length/this.perPage)
        },
        getList() {
            const current = this.currentPage * this.perPage
            const start = current - this.perPage
            return this.filteredGachas.slice(start, current)
        },
        filteredGachas() {
            return this.specificGachas.filter(gacha => {
                return gacha.description.indexOf(this.search) != -1
            })   
        },
        pageNumber() {
            return this.$route.query.page || 1 
        },
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
            this.filteredGachas.forEach(gacha => {
                amount += Math.round(one_stone_price*gacha.currency_package.need_one_gacha_stones*gacha.count)
            })
            this.specificPossesStones.forEach(possesStone => {
                amount += Math.round(one_stone_price*possesStone.quantity)
            })
            return amount
        },
    },
    watch: {
        search() {
            this.currentPage = 1
            this.pageChange();
        },
        pageNumber() {
            this.currentPage = this.pageNumber
        },
        gameId() {
            this.fetchPackage(this.gameId);
            this.fetchGachas();
            this.fetchPossesStones();
            this.search = ''
        }
    },
    created() {
        this.fetchGachas();
        this.pageMaintain();
        this.fetchPackage(this.$route.params.id);
        this.fetchPossesStones();
    },
    methods: {
        ...mapActions('gachas', [
            "fetchGachas",
            "deleteGacha",
            "fetchPackage"
        ]),
        ...mapActions('posses_stones',[
            "fetchPossesStones",
        ]),
        toCreate() {
            this.$router.push({ name: 'GachaRecordCreate' })
        },
        toEdit(int) {
            if (!this.search && !this.select) {
                this.$router.push({ name: 'GachaEdit', params: {id: int}, query: { page: this.currentPage } })
            } else if (this.search && !this.select) {
                this.$router.push({ name: 'GachaEdit', params: {id: int}, query: { page: this.currentPage, search: this.search } })
            } else if (!this.search && this.select) {
                this.$router.push({ name: 'GachaEdit', params: {id: int}, query: { page: this.currentPage, select: this.select } })
            } else if (this.search && this.select) {
                this.$router.push({ name: 'GachaEdit', params: {id: int}, query: { page: this.currentPage, search: this.search, select: this.select } })
            }
        },
        pageChange() {
            if (!this.search) {
                this.$router.push({ name: 'GameFullData', query: { page: this.currentPage } })
            } else if (this.search) {
                this.$router.push({ name: 'GameFullData', query: { page: this.currentPage, search: this.search } })
            }
        },
        pageMaintain() {
            if (this.$route.query.page) {
                this.currentPage = this.$route.query.page
            }
        },
        handleClose() {
            this.isVisibleDetail = false
            this.isVisibleDelete = false
            this.gacha = {}
        },
        handleOpenDetail(gacha) {
            this.isVisibleDetail = true
            this.gacha = Object.assign({}, gacha)
        },
        handleOpenDelete(gacha) {
            this.isVisibleDelete = true
            this.gacha = gacha
        },
        async handleDeleteGacha(gacha) {
            try {
                await this.deleteGacha(gacha);
                this.handleClose();
            } catch (error) {
                console.log(error);
            }
        },
    },
}
</script>