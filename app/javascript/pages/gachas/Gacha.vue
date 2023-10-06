<template>
<v-btn block class="bg-info mb-3" @click="toCreate">ガチャ記録 新規作成</v-btn>
<div class="bg-white rounded shadow p-3 mb-3">
    <div class="text-center text-secondary">
    <span>ガチャ記録 一覧</span>
  </div>
  <hr>
  <div v-if="gachas.length == 0" class="text-center text-secondary p-3">
    <span>データがありません</span>
  </div>
    <div v-for="gacha in getList"
         :key="gacha.id"
         class="bg-light border shadow-sm rounded my-2 py-2"
    >
      <div class="container border-bottom pb-2">
        <div class="row">
          <div class="col-6">{{ gacha.date }}</div>
          <div class="col-6">ゲーム名</div>
        </div>
      </div>
      <div class="container border-bottom py-2">
        <div class="row">
          <div class="col-6 text-center">3000円</div>
          <div class="col-6 text-center">{{ gacha.count }}回</div>
        </div>
      </div>
      <div class="pt-2 px-4">
        <ul class="text-end mb-0">
          <button class="btn btn-sm btn-outline-info me-2" @click="">詳細</button>
          <button class="btn btn-sm btn-outline-success me-2" @click="toEdit(gacha.id)">編集</button>
          <button class="btn btn-sm btn-outline-danger">削除</button>
        </ul>
      </div>
    </div>
</div>

<v-pagination
 v-model="currentPage"
 :length="getPageCount"
 :click-handler="clickCallback">
</v-pagination>
</template>

<script>
import { mapGetters, mapActions } from 'vuex';

export default {
    name: "Gacha",
    data() {
        return {
            currentPage: 1,
            perPage: 10,
        }
    },
    computed: {
        ...mapGetters('gachas', ["gachas"]),
        getPageCount() {
            return Math.ceil(this.gachas.length/this.perPage)
        },
        getList() {
            const current = this.currentPage * this.perPage
            const start = current - this.perPage
            return this.gachas.slice(start, current)
        },
    },
    created() {
        this.fetchGachas();
    },
    methods: {
        ...mapActions('gachas', ["fetchGachas"]),
        toCreate() {
            this.$router.push({ name: 'GachaRecordCreate' })
        },
        toEdit(int) {
            this.$router.push({ name: 'GachaEdit', params: {id: int}})
        },
        clickCallback(pageNum) {
            this.currentPage = Number(pageNum)
        },
    },
}
</script>