<template>
<div class="py-3">
  <div class="container">
    <div class="row">
      <div class="offset-md-1 col-12 col-md-10">
        <div class="card">

          <Form>
            <div class="card-header bg-white py-3">
              <span>ガチャ記録作成</span>
            </div>
            <div class="card-body">
              <div class="form-group m-3">
                <label for="count">ガチャ回数</label>
                <Field name="count" v-model.number="gacha.count" class="form-control" :rules="isNumericRequired" />
                <div class="text-danger"><ErrorMessage name="count" /></div>
              </div>
              <div class="form-group m-3">
                <label for="date">ガチャを引いた日付</label>
                <Field name="date" type="date" v-model="gacha.date" class="form-control" />
                <div class="text-danger"><ErrorMessage name="date" /></div>
              </div>
              <div class="form-group m-3">
                <label for="description">ガチャを引いた日付</label>
                <Field name="description" type="field" v-model="gacha.description" class="form-control">
                  <textarea name="description" v-model="gacha.description" style="width:100%" />
                </Field>
                <div class="text-danger"><ErrorMessage name="description" /></div>
              </div>
            </div>
          </Form>

        </div>
      </div>
    </div>
    {{ gacha }}
  </div>
</div>
</template>

<script>
import { Field, Form, ErrorMessage } from 'vee-validate';

export default {
  name: 'GachaRecordCreate',
  components: {
    Field,
    Form,
    ErrorMessage
  },
  data() {
    return {
      gacha: {
        count: '',
        date: '',
        description: '',
        conversion_id: '',
      }
    }
  },
  methods: {
    isNumericRequired(value) {
      if (!value.match(/^[0-9]*$/)) {
        return '半角数字で入力してください';
      }
      if (!value && !value.trim()) {
        return '入力してください';
      }
      return true;
    },
  },
}
</script>