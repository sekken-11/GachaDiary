<template>
<div id="conversion-delete-dialog">
  <div class="modal" @click.self="handleClose">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <span>下記の換算用データを削除しますか？</span>
        </div>
        <div class="modal-body">
          <div class="bg-light border shadow-sm rounded my-2 py-2">
            <div class="container border-bottom pb-2">
              <div class="row">
                <span>{{ currency_package.name }}</span>
              </div>
            </div>
            <div class="container border-bottom py-2">
              <div class="row">
                <div class="col-4 text-center border-end">
                  <span>購入価格</span>
                </div>
                <div class="col-8 text-center">
                  <span>{{ currency_package.price }}円 ／ {{ currency_package.quantity }}個</span>
                </div>
              </div>
            </div>
            <div class="container py-2">
              <div class="row">
                <div class="col-4 text-center border-end">
                  <span>ガチャ1回</span>
                </div>
                <div class="col-8 text-center">
                  <span>{{ currency_package.need_one_gacha_stones }}個</span>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button class="btn btn-outline-info" @click="handleClose">戻る</button>
          <button class="btn btn-outline-danger" @click="handleDelete">削除</button>
        </div>
      </div>
    </div>
  </div>
  <div class="modal-backdrop show"></div>
</div>
</template>

<script>
export default {
    name: 'ConversionDeleteModal',
    props: ['currency_package'],
    methods: {
        handleClose() {
            this.$emit('Close')
        },
        handleDelete() {
            this.$emit('Delete', this.currency_package)
        }
    },
}
</script>

<style scoped>
.modal {
  display: block;
}
</style>