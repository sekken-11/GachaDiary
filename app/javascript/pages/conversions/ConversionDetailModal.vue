<template>
<div id="conversion-detail-dialog">
  <div class="modal" @click.self="handleClose">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <span>換算用データ詳細</span>
        </div>
        <div class="modal-body">
          <div class="bg-light border shadow-sm rounded my-2 px-2">
            <v-container>
              <v-row class="border-bottom py-2">
                <span>{{ currency_package.name }}</span>
              </v-row>
              <v-row class="border-bottom">
                <v-col cols="4" class="text-center border-end">
                  <span>購入価格</span>
                </v-col>
                <v-col cols="8" class="text-center">
                  <span>{{ currency_package.price }}円 ／ {{ currency_package.quantity }}個</span>
                </v-col>
              </v-row>
              <v-row>
                <v-col cols="4" class="text-center border-end">
                  <span>ガチャ1回</span>
                </v-col>
                <v-col cols="8" class="text-center">
                  <span>{{ currency_package.need_one_gacha_stones }}個</span>
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
    name: 'ConversionDetailModal',
    props: ['currency_package'],
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
</style>