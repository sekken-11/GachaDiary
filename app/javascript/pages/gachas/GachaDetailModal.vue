<template>
<div id="gacha-detail-dialog">
  <div class="modal" @click.self="handleClose">
    <div class="modal-dialog" id="gacha_modal">
      <div class="modal-content">
        <div class="modal-header">
          <span>ガチャ記録 詳細</span>
        </div>
        <div class="modal-body">
          <div class="bg-light border shadow-sm rounded my-2 px-2">
            <v-container>
              <v-row class="border-bottom">
                <v-col cols="4" class="text-center border-end">
                  <span>日付</span>
                </v-col>
                <v-col cols="8" class="text-center">
                  <span>{{ gacha.date }}</span>
                </v-col>
              </v-row>
              <v-row class="border-bottom">
                <v-col cols="4" class="text-center border-end">
                  <span>ゲーム名</span>
                </v-col>
                <v-col cols="8" class="text-center">
                  <span>{{ gacha.currency_package.name }}</span>
                </v-col>
              </v-row>
              <v-row class="border-bottom">
                <v-col cols="4" class="text-center border-end">
                  <span>現金換算</span>
                </v-col>
                <v-col cols="8" class="text-center">
                  <span>{{ Math.round(gacha.currency_package.price/gacha.currency_package.quantity*gacha.currency_package.need_one_gacha_stones*gacha.count) }}円</span>
                </v-col>
              </v-row>
              <v-row class="border-bottom">
                <v-col cols="4" class="text-center border-end">
                  <span>回数</span>
                </v-col>
                <v-col cols="8" class="text-center">
                  <span>{{ gacha.count }}回</span>
                </v-col>
              </v-row>
              <v-row>
                <v-col cols="4" class="text-center border-end">
                  <span>備考</span>
                </v-col>
                <v-col cols="8" class="ext-center">
                  <span>{{ gacha.description }}</span>
                </v-col>
              </v-row>
            </v-container>
          </div>
        </div>
        <div class="modal-footer">
          <button class="btn btn-outline-info" @click="handleClose">戻る</button>
        </div>
      </div>
    </div>
  </div>
  <div class="modal-backdrop show"></div>
</div>
</template>

<script>
export default {
    name: 'GachaDetailModal',
    props: ['gacha'],
    methods: {
        handleClose() {
            this.$emit('Close')
        },
    },
}
</script>

<style scoped>
.modal {
  display: block;
}
.modal-backdrop {
  width: 100% !important;
  height: 100% !important;
}
</style>