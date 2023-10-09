<template>
<div id="game-edit-dialog">
  <div class="modal" @click.self="handleClose">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <span>石の所持データ編集</span>
        </div>
        <div class="modal-body">
          <Form>
            <div class="form-group m-3">
              <label for="quantity">石の所持数</label>
              <Field name="quantity" v-model.number="posses_stone.quantity" class="form-control" :rules="isNumericRequired" />
              <ErrorMessage name="quantity" class="text-danger" />
            </div>
            <div class="text-end m-3 mt-5">
              <button class="btn btn-outline-info me-2" @click="handleClose">戻る</button>
              <button class="btn btn-outline-success" @click="handleEdit">変更</button>
            </div>
          </Form>
        </div>
      </div>
    </div>
  </div>
  <div class="modal-backdrop show"></div>
</div>
</template>

<script>
import { Field, Form, ErrorMessage } from 'vee-validate';

export default {
    name: 'GameEditModal',
    components: {
        Field,
        Form,
        ErrorMessage
    },
    props: ['posses_stone'],
    methods: {
        handleClose() {
            this.$emit('Close')
        },
        handleEdit() {
            this.$emit('Edit', this.posses_stone)
        },
        isNumericRequired(value) {
            if (!value.toString().match(/^[0-9]*$/)) {
                return '半角数字で入力してください';
            }
            if (!value && !value.trim()) {
                return '入力してください';
            }
            return true;
        },
        isRequired(value) {
            if (!value && !value.trim()) {
                return '入力してください';
            }
            return true;
        },
    },
}
</script>

<style scoped>
.modal {
  display: block;
}
</style>