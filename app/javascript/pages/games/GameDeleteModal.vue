<template>
<div id="game-delete-dialog">
  <div class="modal" @click.self="handleClose">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <span>下記のデータを削除しますか？</span>
        </div>
        <div class="modal-body">
          <div class="bg-light border shadow-sm rounded my-2 py-2">
            <div class="container border-bottom pb-2">
              <div class="row">
                <span>{{ posses_stone.currency_package.name }}</span>
              </div>
            </div>
            <div class="container border-bottom py-2">
              <div class="row">
                <div class="col-4 text-center border-end">
                  <span>現金換算</span>
                </div>
                <div class="col-8 text-center">
                  <span>{{ amount(posses_stone.currency_package.price, posses_stone.currency_package.quantity, posses_stone.quantity) }}円</span>
                </div>
              </div>
            </div>
            <div class="container py-2">
              <div class="row">
                <div class="col-4 text-center border-end">
                  <span>所持数</span>
                </div>
                <div class="col-8 text-center">
                  <span>{{ posses_stone.quantity }}個</span>
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
    name: 'GameDeleteModal',
    props: ['posses_stone'],
    methods: {
        handleClose() {
            this.$emit('Close')
        },
        handleDelete() {
            this.$emit('Delete', this.posses_stone)
        },
        amount(price, quantity, stone) {
            return Math.round(price/quantity*stone)
        },
    },
}
</script>

<style scoped>
.modal {
  display: block;
}
</style>