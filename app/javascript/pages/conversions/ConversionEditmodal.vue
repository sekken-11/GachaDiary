<template>
<div id="conversion-edit-dialog">
  <div class="modal" @click.self="handleClose">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <span>換算用データ編集</span>
        </div>
        <div class="modal-body">
          <Form>
            <div class="form-group m-3">
              <label for="name">ゲーム名</label>
              <Field name="name" v-model="currency_package.name" class="form-control" :rules="isRequired" />
              <ErrorMessage name="name" class="text-danger" />
            </div>
            <div class="form-group m-3">
              <label for="name">ガチャ一回に必要なガチャ石</label>
              <Field name="need_one_gacha_stones" v-model.number="currency_package.need_one_gacha_stones" class="form-control" :rules="isNumericRequired" />
              <ErrorMessage name="need_one_gacha_stones" class="text-danger" />
            </div>
            <div class="form-group m-3">
              <label>ガチャ石の価格</label>
              <div class="mb-1">
                <Field name="price" v-model.number="currency_package.price" class="form-control" :rules="isNumericRequired" placeholder="購入する際の金額を入力してください（円）" />
                <ErrorMessage name="price" class="text-danger" />
              </div>
              <div>
                <Field name="quantity" v-model.number="currency_package.quantity" class="form-control" :rules="isNumericRequired" placeholder="購入する際の個数を入力してください（個）" />
                <ErrorMessage name="quantity" class="text-danger" />
              </div>
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
    name: 'ConversionEditModal',
    components: {
        Field,
        Form,
        ErrorMessage
    },
    props: ['currency_package'],
    methods: {
        handleClose() {
            this.$emit('Close')
        },
        handleEdit() {
            this.$emit('Edit', this.currency_package)
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