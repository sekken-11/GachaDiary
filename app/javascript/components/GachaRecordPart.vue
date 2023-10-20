<template>
<div class="bg-white rounded shadow p-3 mb-3">
  <div class="text-center text-muted">
    <span>ガチャ記録 一覧</span>
    <button v-if="isVisibleGacha" class="border-0 bg-white text-muted" @click="gachaUp"><i class="bi bi-chevron-up"></i></button>
    <button v-if="!isVisibleGacha" class="border-0 bg-white text-muted" @click="gachaDown"><i class="bi bi-chevron-down"></i></button>
  </div>
  <hr>
  <div v-if="isVisibleGacha">
    <div v-if="filteredGachas.length == 0" class="text-center text-muted p-3">
      <span><slot></slot></span>
    </div>
      <div v-for="gacha in getList"
           :key="gacha.id"
           class="bg-light border shadow-sm rounded my-2 pb-2"
      >
        <v-container class="">
          <v-row class="border-bottom">
            <v-col cols="6">{{ gacha.date }}</v-col>
            <v-col cols="6" class="text-center">{{ Math.round(gacha.currency_package.price/gacha.currency_package.quantity*gacha.currency_package.need_one_gacha_stones*gacha.count) }}円</v-col>
          </v-row>
          <v-row class="border-bottom">
            <v-col cols="6">{{ gacha.currency_package.name }}</v-col>
            <v-col cols="6" class="text-center">{{ gacha.count }}回</v-col>
          </v-row>
        </v-container>
        <div class="pt-2 px-4">
          <ul class="text-end mb-0">
            <button class="btn btn-sm btn-outline-info me-2" @click="handleOpenDetail(gacha)">詳細</button>
            <button class="btn btn-sm btn-outline-success me-2" @click="toEdit(gacha.id)">編集</button>
            <button class="btn btn-sm btn-outline-danger" @click="handleOpenDelete(gacha)">削除</button>
          </ul>
        </div>
      </div>
    <v-pagination
      v-model="currentPage"
      v-scroll-to="'#top'"
      :length="getPageCount"
      @click="pageChange"
    >
    </v-pagination>
  </div>
</div>

  <transition name="fade">
    <GachaDetailModal v-if="isVisibleDetail" :gacha="gacha" @Close="handleClose" />
  </transition>

  <transition name="fade">
    <DeleteModal v-if="isVisibleDelete" :deleteData="gacha" @Close="handleClose" @Delete="handleDeleteGacha" />
  </transition>

</template>

<script>
import { mapGetters, mapActions } from 'vuex';
import GachaDetailModal from '../pages/gachas/GachaDetailModal.vue';
import DeleteModal from './DeleteModal.vue';

export default {
    name: "GachaRecordPart",
    components: {
        GachaDetailModal,
        DeleteModal,
    },
    props: [
        'gachas',
        'perPage',
        'search',
        'select',
    ],
    data() {
        return {
            currentPage: this.currentPage = this.pageNumber || 1,
            gacha: {},
            isVisibleDetail: false,
            isVisibleDelete: false,
            isVisibleGacha: true,
        }
    },
    computed: {
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
            } else if (this.search) {
                return this.gachas.filter(gacha => {
                    return gacha.description.indexOf(this.search) != -1
                })
            } else {
                return this.gachas
            }
        },
        pageNumber() {
            return this.$route.query.page || 1 
        },
        gameId() {
            return this.$route.params.id
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
        gameId() {
            this.fetchGachas();
            if (this.search) {
                this.search = ''
            }
        }
    },
    created() {
        this.fetchGachas();
        this.pageMaintain();
    },
    methods: {
        ...mapActions('gachas', [
            "fetchGachas",
            "deleteGacha",
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
            if (this.$route.path.match(/gamedata/)) {
                if (!this.search) {
                    this.$router.push({ name: 'GameFullData', query: { page: this.currentPage } })
                } else if (this.search) {
                    this.$router.push({ name: 'GameFullData', query: { page: this.currentPage, search: this.search } })
                }
            } else if (this.$route.path.match(/gacha/)) {
                if (!this.search && !this.select) {
                    this.$router.push({ name: 'Gacha', query: { page: this.currentPage } })
                } else if (this.search && !this.select) {
                    this.$router.push({ name: 'Gacha', query: { page: this.currentPage, search: this.search } })
                } else if (!this.search && this.select) {
                    this.$router.push({ name: 'Gacha', query: { page: this.currentPage, select: this.select } })
                } else if (this.search && this.select) {
                    this.$router.push({ name: 'Gacha', query: { page: this.currentPage, search: this.search, select: this.select } })
                }
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
        gachaUp() {
            this.isVisibleGacha = false
        },
        gachaDown() {
            this.isVisibleGacha = true
        },
    },
}
</script>