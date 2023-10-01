<template>
<div class="bg-secondary mb-3 p-3 rounded shadow">
  <div class="h5 text-white">合計</div>
    <hr>
    <div class="h4 text-white text-center">3333円</div>
  </div>
  <div class="bg-secondary rounded shadow p-3">
    <div class="h5 text-white text-center">換算合計</div>
    <div class="bg-white border shadow-sm rounded my-2 py-2">
      <div class="container border-bottom pb-2">
        <div class="row">
          <div class="col-9">
            <span>ゲーム名</span>
          </div>
          <div class="col-3">
            <div class="d-flex justify-content-end">
              <button type="button" class="btn-close"></button>
            </div>
          </div>
        </div>
      </div>
      <div class="container pt-2">
        <div class="row">
          <div class="col-6 text-center border-end">
            <span>1111円</span>
          </div>
          <div class="col-6 text-center">
            <span>2222回</span>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'TotalRecord',
}
</script>