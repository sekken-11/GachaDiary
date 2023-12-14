<template>
  <div id="posses_stones" class="bg-white rounded shadow p-3 mb-3">
    <div class="text-center text-muted">
      <span><slot></slot></span>
      <button v-if="isVisiblePossesStone" class="border-0 bg-white text-muted" @click="possesStoneUp">
        <i class="bi bi-chevron-up"></i>
      </button>
      <button v-if="!isVisiblePossesStone" class="border-0 bg-white text-muted" @click="possesStoneDown">
        <i class="bi bi-chevron-down"></i>
      </button>
    </div>
    <hr />

    <div v-if="isVisiblePossesStone">
      <div v-if="possesStones.length == 0" class="text-center text-muted p-3">
        <span>データがありません</span>
      </div>
      <div
        v-for="(possesStone, index) in possesStones"
        :key="possesStone.id"
        :id="'posses_stone_record-' + (index + 1)"
        class="bg-light border shadow-sm rounded my-2 p-2"
      >
        <v-container>
          <v-row class="border-bottom pb-2">
            <span v-if="possesStone.currency_package">
              {{ possesStone.currency_package.name }}
            </span>
            <span v-if="!possesStone.currency_package">データ未設定</span>
          </v-row>
          <v-row class="border-bottom">
            <v-col cols="4" class="text-center border-end">
              <span>現金換算</span>
            </v-col>
            <v-col cols="8" class="text-center">
              <span v-if="possesStone.currency_package">
                {{ amount(possesStone.currency_package.price, possesStone.currency_package.quantity, possesStone.quantity) }}円
              </span>
              <span v-if="!possesStone.currency_package">データ未設定</span>
            </v-col>
          </v-row>
          <v-row class="border-bottom">
            <v-col cols="4" class="text-center border-end">
              <span>所持数</span>
            </v-col>
            <v-col cols="8" class="text-center">
              <span>{{ possesStone.quantity }}個</span>
            </v-col>
          </v-row>
        </v-container>
        <div class="pt-2 px-4">
          <ul class="text-end mb-0">
            <button class="btn btn-sm btn-outline-success me-2" @click="toEdit(possesStone.id)">
              編集
            </button>
            <button class="btn btn-sm btn-outline-danger" @click="handleOpenDelete(possesStone)">
              削除
            </button>
          </ul>
        </div>
      </div>
    </div>
  </div>

  <transition name="fade">
    <DeleteModal
      v-if="isVisibleDelete"
      :deleteData="posses_stone"
      @Close="handleClose"
      @Delete="handleDeletePossesStone"
    />
  </transition>

</template>

<script>
import { mapActions } from "vuex";
import PossesEdit from "../pages/posses/PossesEdit.vue";
import DeleteModal from "./DeleteModal.vue";

export default {
  name: "PossesStonesPart",
  props: ["possesStones"],
  components: {
    PossesEdit,
    DeleteModal,
  },
  data() {
    return {
      isVisibleDelete: false,
      isVisiblePossesStone: true,
    };
  },
  methods: {
    ...mapActions("posses_stones", ["deletePossesStone", "editPossesStone"]),
    ...mapActions("transition", ["addMessage"]),
    toCreate() {
      this.$router.push({ name: "PossesCreate" });
    },
    toEdit(int) {
      this.$router.push({ name: "PossesEdit", params: { id: int } });
    },
    amount(price, quantity, stone) {
      return Math.round((price / quantity) * stone);
    },
    handleClose() {
      this.isVisibleDelete = false;
      this.isVisibleEdit = false;
      this.posses_stone = {};
    },
    handleOpenDelete(possesStone) {
      this.isVisibleDelete = true;
      this.posses_stone = possesStone;
    },
    async handleDeletePossesStone(posses_stone) {
      try {
        await this.deletePossesStone(posses_stone);
        this.handleClose();
        this.addMessage({
          message: "所持ガチャ石記録を削除しました",
          messageType: "success",
        });
      } catch (error) {
        console.log(error);
        this.addMessage({
          message: "所持ガチャ石記録の削除に失敗しました",
          messageType: "danger",
        });
      }
    },
    possesStoneUp() {
      this.isVisiblePossesStone = false;
    },
    possesStoneDown() {
      this.isVisiblePossesStone = true;
    },
  },
};
</script>
