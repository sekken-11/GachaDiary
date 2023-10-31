<template>
<div id="delete-dialog">
  <div class="modal" @click.self="handleClose">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header p-4">
          <span>削除してもよろしいですか？</span>
        </div>
        <div class="modal-footer">
          <button class="btn btn-outline-info" @click="handleClose">戻る</button>
          <button id="delete-button" class="btn btn-outline-danger" @click="handleDelete">削除</button>
        </div>
      </div>
    </div>
  </div>
  <div class="modal-backdrop show"></div>
</div>
</template>

<script>
export default {
    name: 'DeleteModal',
    props: ['deleteData'],
    methods: {
        handleClose() {
            this.$emit('Close')
        },
        handleDelete() {
            this.$emit('Delete', this.deleteData)
        }
    },
}
</script>

<style scoped>
.modal {
  display: block;
}
</style>