<template>
  <div id="gacharecords" class="bg-white rounded shadow p-3 mb-3">
    <div class="text-center text-muted">
      <span>ガチャ記録 一覧</span>
      <button v-if="isVisibleGacha" class="border-0 bg-white text-muted" @click="gachaUp">
        <i class="bi bi-chevron-up"></i>
      </button>
      <button v-if="!isVisibleGacha" class="border-0 bg-white text-muted" @click="gachaDown">
        <i class="bi bi-chevron-down"></i>
      </button>
    </div>
    <hr />
    <div v-if="isVisibleGacha">
      <div v-if="filteredGachas.length == 0" class="text-center text-muted p-3">
        <span><slot></slot></span>
      </div>
      <div
        v-for="(gacha, index) in getList"
        :key="gacha.id"
        :id="'gacharecord-' + (index + 1)"
        class="bg-light border shadow-sm rounded my-2 pb-2"
      >
        <v-container>
          <v-row class="border-bottom">
            <v-col cols="6">{{ gacha.date }}</v-col>
            <v-col cols="6" class="text-center">
              <span v-if="gacha.currency_package">
              {{ Math.round((gacha.currency_package.price / gacha.currency_package.quantity) * gacha.currency_package.need_one_gacha_stones * gacha.count) }}円</span>
            </v-col>
          </v-row>
          <v-row class="border-bottom">
            <v-col cols="6">
              <span v-if="gacha.currency_package">{{ gacha.currency_package.name }}</span>
              <span v-if="!gacha.currency_package">未設定</span>
            </v-col>
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
    <GachaDetailModal
      v-if="isVisibleDetail"
      :gacha="gacha"
      @Close="handleClose"
    />
  </transition>

  <transition name="fade">
    <DeleteModal
      v-if="isVisibleDelete"
      :deleteData="gacha"
      @Close="handleClose"
      @Delete="handleDeleteGacha"
    />
  </transition>

</template>

<script>
import { mapGetters, mapActions } from "vuex";
import GachaDetailModal from "../pages/gachas/GachaDetailModal.vue";
import DeleteModal from "./DeleteModal.vue";

export default {
  name: "GachaRecordPart",
  components: {
    GachaDetailModal,
    DeleteModal,
  },
  props: [
    "gachas",
    "perPage",
    "search",
    "select",
    "from_date",
    "to_date",
    "from_count",
    "to_count",
  ],
  data() {
    return {
      currentPage: this.currentPage = this.$route.query.page || 1,
      gacha: {},
      isVisibleDetail: false,
      isVisibleDelete: false,
      isVisibleGacha: true,
    };
  },
  computed: {
    getPageCount() {
      return Math.ceil(this.filteredGachas.length / this.perPage);
    },
    getList() {
      const current = this.currentPage * this.perPage;
      const start = current - this.perPage;
      return this.filteredGachas.slice(start, current);
    },
    searchGachas() {
      return this.gachas.filter((gacha) => {
        return (gacha.description.indexOf(this.search) != -1)
      })
    },
    selectGachas() {
      if (this.select && this.select != "null") {
        return this.gachas.filter((gacha) => {
          return (gacha.currency_package_id == this.select)
        })
      } else if (this.select == "null") {
        return this.gachas.filter((gacha) => {
          return (gacha.currency_package_id == null)
        })
      } else if (!this.select) {
        return this.gachas
      }
    },
    fromDateGachas() {
      if (this.from_date) {
        return this.gachas.filter((gacha) => {
          return (gacha.date >= this.from_date)
        })
      } else if (!this.from_date) {
        return this.gachas
      }
    },
    toDateGachas() {
      if (this.to_date) {
        return this.gachas.filter((gacha) => {
          return (gacha.date <= this.to_date)
        })
      } else if (!this.to_date) {
        return this.gachas
      }
    },
    fromCountGachas() {
      if (this.from_count) {
        return this.gachas.filter((gacha) => {
          return (gacha.count >= this.from_count)
        })
      } else if (!this.from_count) {
        return this.gachas
      }
    },
    toCountGachas() {
      if (this.to_count) {
        return this.gachas.filter((gacha) => {
          return (gacha.count <= this.to_count)
        })
      } else if (!this.to_count) {
        return this.gachas
      }
    },
    filteredGachas() {
      return this.gachas.filter((gacha) => {
        return (
          this.searchGachas.includes(gacha) &&
          this.selectGachas.includes(gacha) &&
          this.fromDateGachas.includes(gacha) &&
          this.toDateGachas.includes(gacha) &&
          this.fromCountGachas.includes(gacha) &&
          this.toCountGachas.includes(gacha)
        );
      });
    },
    gameId() {
      return this.$route.params.id;
    },
  },
  watch: {
    search() {
      this.currentPage = 1
      if (this.search) {
        this.$router.push({ query: Object.assign({}, this.$route.query, { search: this.search, page: 1 }) });
      } else if (!this.search) {
        var new_query = Object.assign({}, this.$route.query, { page: 1 })
        delete new_query.search
        this.$router.push({ query: new_query });
      } 
    },
    select() {
      this.currentPage = 1;
      if (this.select) {
        this.$router.push({ query: Object.assign({}, this.$route.query, { select: this.select, page: 1 }) });
      } else if (!this.select) {
        var new_query = Object.assign({}, this.$route.query, { page: 1 })
        delete new_query.select
        this.$router.push({ query: new_query });
      }
    },
    from_date() {
      this.currentPage = 1;
      if (this.from_date) {
        this.$router.push({ query: Object.assign({}, this.$route.query, { from: this.from_date, page: 1 }) });
      } else if (!this.from_date) {
        var new_query = Object.assign({}, this.$route.query, { page: 1 })
        delete new_query.from
        this.$router.push({ query: new_query });
      } 
    },
    to_date() {
      this.currentPage = 1;
      if (this.to_date) {
        this.$router.push({ query: Object.assign({}, this.$route.query, { to: this.to_date, page: 1 }) });
      } else if (!this.to_date) {
        var new_query = Object.assign({}, this.$route.query, { page: 1 })
        delete new_query.to
        this.$router.push({ query: new_query });
      } 
    },
    from_count() {
      this.currentPage = 1;
      if (this.from_count) {
        this.$router.push({ query: Object.assign({}, this.$route.query, { fcount: this.from_count, page: 1 }) });
      } else if (!this.from_count) {
        var new_query = Object.assign({}, this.$route.query, { page: 1 })
        delete new_query.fcount
        this.$router.push({ query: new_query });
      } 
    },
    to_count() {
      this.currentPage = 1;
      if (this.to_count) {
        this.$router.push({ query: Object.assign({}, this.$route.query, { tcount: this.to_count, page: 1 }) });
      } else if (!this.search) {
        var new_query = Object.assign({}, this.$route.query, { page: 1 })
        delete new_query.tcount
        this.$router.push({ query: new_query });
      } 
    },
    gameId() {
      this.fetchGachas();
      if (this.search) {
        this.search = "";
      }
    },
  },
  created() {
    this.fetchGachas();
    this.pageMaintain();
  },
  methods: {
    ...mapActions("gachas", ["fetchGachas", "deleteGacha"]),
    ...mapActions("transition", ["addMessage"]),
    toCreate() {
      this.$router.push({ name: "GachaRecordCreate" });
    },
    toEdit(int) {
      this.$router.push({ name: "GachaEdit", params: { id: int } });
    },
    pageChange() {
      this.$router.push({ query: Object.assign({}, this.$route.query, { page: this.currentPage }) })
    },
    pageMaintain() {
      if (this.$route.query.page) {
        this.currentPage = this.$route.query.page;
      }
    },
    handleClose() {
      this.isVisibleDetail = false;
      this.isVisibleDelete = false;
      this.gacha = {};
    },
    handleOpenDetail(gacha) {
      this.isVisibleDetail = true;
      this.gacha = Object.assign({}, gacha);
    },
    handleOpenDelete(gacha) {
      this.isVisibleDelete = true;
      this.gacha = gacha;
    },
    async handleDeleteGacha(gacha) {
      try {
        await this.deleteGacha(gacha);
        this.handleClose();
        this.addMessage({
          message: "ガチャ記録を削除しました",
          messageType: "success",
        });
      } catch (error) {
        console.log(error);
        this.addMessage({
          message: "ガチャ記録の削除に失敗しました",
          messageType: "danger",
        });
      }
    },
    gachaUp() {
      this.isVisibleGacha = false;
    },
    gachaDown() {
      this.isVisibleGacha = true;
    },
  },
};
</script>
