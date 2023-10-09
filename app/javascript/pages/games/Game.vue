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
<div class="bg-white rounded shadow p-3 mb-3">
  <div class="text-center text-secondary">
    <span>ゲームごとの石の所持データ 一覧</span>
  </div>
  <hr>
  <div v-if="possesStones.length == 0" class="text-center text-secondary p-3">
    <span>データがありません</span>
  </div>
  <div v-for="possesStone in possesStones"
       :key="possesStone.id"
       class="bg-light border shadow-sm rounded my-2 py-2"
  >
    <div class="container border-bottom pb-2">
      <div class="row">
        <span>{{ possesStone.currency_package.name }}</span>
      </div>
    </div>
    <div class="container border-bottom py-2">
      <div class="row">
        <div class="col-4 text-center border-end">
          <span>現金換算</span>
        </div>
        <div class="col-8 text-center">
          <span>{{ amount(possesStone.currency_package.price, possesStone.currency_package.quantity, possesStone.quantity) }}円</span>
        </div>
      </div>
    </div>
    <div class="container border-bottom py-2">
      <div class="row">
        <div class="col-4 text-center border-end">
          <span>所持数</span>
        </div>
        <div class="col-8 text-center">
          <span>{{ possesStone.quantity }}個</span>
        </div>
      </div>
    </div>
    <div class="pt-2 px-4">
      <ul class="text-end mb-0">
        <button class="btn btn-sm btn-outline-info me-2" @click="handleOpenDetail(possesStone)">詳細</button>
        <button class="btn btn-sm btn-outline-success me-2" @click="toEdit(possesStone.id)">編集</button>
        <button class="btn btn-sm btn-outline-danger" @click="handleOpenDelete(possesStone)">削除</button>
      </ul>
    </div>
  </div>
</div>

  <transition name="fade">
    <DeleteModal v-if="isVisibleDelete" :deleteData="posses_stone" @Close="handleClose" @Delete="handleDeletePossesStone" />
  </transition>

</template>

<script>
import { mapGetters, mapActions } from 'vuex';
import GameEdit from './GameEdit.vue';
import DeleteModal from '../../components/DeleteModal.vue';

export default {
    name: "Game",
    components: {
        GameEdit,
        DeleteModal
    },
    data() {
        return {
            isVisibleDelete: false,
        }
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
            "deletePossesStone",
            "editPossesStone",
            ]),
        toCreate() {
            this.$router.push({ name: 'GameCreate' })
        },
        toEdit(int) {
            this.$router.push({ name: 'GameEdit', params: { id: int } })
        },
        amount(price, quantity, stone) {
            return Math.round(price/quantity*stone)
        },
        handleClose() {
            this.isVisibleDelete = false
            this.isVisibleEdit = false
            this.posses_stone = {}
        },
        handleOpenDelete(possesStone) {
            this.isVisibleDelete = true
            this.posses_stone = possesStone
        },
        async handleDeletePossesStone(posses_stone) {
            try {
                await this.deletePossesStone(posses_stone);
                this.handleClose();
            } catch (error) {
                console.log(error);
            }
        },
        async handleEditPossesStone(posses_stone) {
            try {
                await this.editPossesStone(posses_stone);
                this.handleClose();
            } catch (error) {
                console.log(error);
            }
        },
    }
}
</script>