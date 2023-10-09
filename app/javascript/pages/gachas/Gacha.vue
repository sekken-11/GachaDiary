<template>
<v-btn block id="top" class="bg-info mb-3" @click="toCreate">ガチャ記録 新規作成</v-btn>
<div class="form-row" id="search-form">
  <div class="form-group mb-3">
    <input type="text" v-model="search" class="form-control" id="search" placeholder="絞り込み">
  </div>
</div>
<div class="form-row" id="select-form">
  <div class="form-group mb-3">
    <select v-model="select" class="form-control" id="select">
      <option value="" selected>ゲーム名を指定しない</option>
      <option v-for="currencyPackage in currencyPackages" :key="currencyPackage.id" :value="currencyPackage.id">
        {{ currencyPackage.name }}
      </option>
    </select>
  </div>
</div>
<div class="bg-white rounded shadow p-3 mb-3">
    <div class="text-center text-secondary">
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
          <div class="col-6 text-center">3000円</div>
        </div>
      </div>
      <div class="container border-bottom py-2">
        <div class="row">
          <div class="col-6">ゲーム名</div>
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
import GachaDetailModal from './GachaDetailModal.vue';
import DeleteModal from '../../components/DeleteModal.vue';

export default {
    name: "Gacha",
    components: {
        GachaDetailModal,
        DeleteModal,
    },
    data() {
        return {
            currentPage: this.currentPage = this.pageNumber || 1,
            perPage: 10,
            search: this.search = this.$route.query.search || '',
            select: this.select = this.$route.query.select || '',
            gacha: {},
            isVisibleDetail: false,
            isVisibleDelete: false,
        }
    },
    computed: {
        ...mapGetters('gachas', [
            "gachas",
            "currencyPackages"
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
            if (this.select) {
                return this.gachas.filter(gacha => {
                    return gacha.description.indexOf(this.search) != -1 && gacha.currency_package_id == this.select
                })
            } else {
                return this.gachas.filter(gacha => {
                    return gacha.description.indexOf(this.search) != -1
                })
            }
            
        },
        pageNumber() {
            return this.$route.query.page || 1 
        },
    },
    watch: {
        search() {
            this.currentPage = 1
            this.pageChange();
        },
        select() {
            this.currentPage = 1
            this.pageChange();
        },
        pageNumber() {
            this.currentPage = this.pageNumber
        },
    },
    created() {
        this.fetchGachas();
        this.pageMaintain();
    },
    methods: {
        ...mapActions('gachas', [
            "fetchGachas",
            "deleteGacha"
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
            if (!this.search && !this.select) {
                this.$router.push({ name: 'Gacha', query: { page: this.currentPage } })
            } else if (this.search && !this.select) {
                this.$router.push({ name: 'Gacha', query: { page: this.currentPage, search: this.search } })
            } else if (!this.search && this.select) {
                this.$router.push({ name: 'Gacha', query: { page: this.currentPage, select: this.select } })
            } else if (this.search && this.select) {
                this.$router.push({ name: 'Gacha', query: { page: this.currentPage, search: this.search, select: this.select } })
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