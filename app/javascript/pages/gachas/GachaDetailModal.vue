<template>
<div id="gacha-detail-dialog">
  <div class="modal" @click.self="handleClose">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <span>ガチャ記録 詳細</span>
        </div>
        <div class="modal-body">
          <div class="bg-light border shadow-sm rounded my-2 py-2">
            <div class="container border-bottom pb-2">
              <div class="row">
                <div class="col-4 text-center border-end">
                  <span>日付</span>
                </div>
                <div class="col-8 text-center">
                  <span>{{ gacha.date }}</span>
                </div>
              </div>
            </div>
            <div class="container border-bottom py-2">
              <div class="row">
                <div class="col-4 text-center border-end">
                  <span>ゲーム名</span>
                </div>
                <div class="col-8 text-center">
                  <span>{{ gacha.currency_package.name }}</span>
                </div>
              </div>
            </div>
            <div class="container border-bottom py-2">
              <div class="row">
                <div class="col-4 text-center border-end">
                  <span>現金換算</span>
                </div>
                <div class="col-8 text-center">
                  <span>{{ Math.round(gacha.currency_package.price/gacha.currency_package.quantity*gacha.currency_package.need_one_gacha_stones*gacha.count) }}円</span>
                </div>
              </div>
            </div>
            <div class="container border-bottom py-2">
              <div class="row">
                <div class="col-4 text-center border-end">
                  <span>回数</span>
                </div>
                <div class="col-8 text-center">
                  <span>{{ gacha.count }}回</span>
                </div>
              </div>
            </div>
            <div class="container py-2">
              <div class="row">
                <div class="col-4 text-center border-end">
                  <span>備考</span>
                </div>
                <div class="col-8 text-center">
                  <span>{{ gacha.description }}</span>
                </div>
              </div>
            </div>
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
</style>