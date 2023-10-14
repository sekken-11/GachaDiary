<template>
<v-btn block id="top" color="info" class="mb-3" @click="toCreate">ガチャ記録 新規作成</v-btn>
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

<GachaRecordPart :gachas="gachas" :perPage="perPage" :search="search" :select="select">データがありません</GachaRecordPart>

</template>

<script>
import { mapGetters, mapActions } from 'vuex';
import GachaRecordPart from '../../components/GachaRecordPart.vue';

export default {
  name: "Gacha",
  components: {
    GachaRecordPart,
  },
  data() {
    return {
      perPage: 10,
      search: this.search = this.$route.query.search || '',
      select: this.select = this.$route.query.select || '',
    }
  },
  computed: {
    ...mapGetters('gachas', [
      "gachas",
      "currencyPackages"
    ]),
  },
  created() {
    this.fetchGachas();
    this.pageMaintain();
  },
  methods: {
    ...mapActions('gachas', [
      "fetchGachas",
    ]),
    toCreate() {
      this.$router.push({ name: 'GachaRecordCreate' })
    },
    pageMaintain() {
      if (this.$route.query.page) {
        this.currentPage = this.$route.query.page
      }
    },
  },
}
</script>