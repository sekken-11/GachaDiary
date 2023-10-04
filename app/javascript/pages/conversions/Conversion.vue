<template>
<div class="btn-primary rounded mb-3 p-2 text-center" @click="toCreate">
  <span class="text-white">換算用データ新規作成</span>
</div>
<div class="bg-white rounded shadow p-3 mb-3">
    <div class="text-center text-secondary">
    <span>換算用データ 一覧</span>
  </div>
  <hr>
    <div v-for="currencyPackage in currencyPackages"
         :key="currencyPackage.id"
         class="bg-light border shadow-sm rounded my-2 py-2"
    >
      <div class="container border-bottom pb-2">
        <div class="row">
          <span>{{ currencyPackage.name }}</span>
        </div>
      </div>
      <div class="pt-2 px-4">
        <ul class="text-end mb-0">
          <li class="btn btn-sm btn-outline-info me-2" @click="handleOpenDetail(currencyPackage)">詳細</li>
          <li class="btn btn-sm btn-outline-success me-2" @click="handleOpenEdit(currencyPackage)">編集</li>
          <li class="btn btn-sm btn-outline-danger" @click="handleOpenDelete(currencyPackage)">削除</li>
        </ul>
      </div>
    </div>
</div>

  <transition name="fade">
    <ConversionDetailModal v-if="isVisibleDetail" :currency_package="currency_package" @Close="handleClose" />
  </transition>

  <transition name="fade">
    <ConversionEditModal v-if="isVisibleEdit" :currency_package="currency_package" @Close="handleClose" @Edit="handleEditPackage" />
  </transition>

  <transition name="fade">
    <ConversionDeleteModal v-if="isVisibleDelete" :currency_package="currency_package" @Close="handleClose" @Delete="handleDeletePackage" />
  </transition>
    
</template>

<script>
import { Field, Form, ErrorMessage } from 'vee-validate';
import { mapGetters, mapActions } from 'vuex';
import ConversionDeleteModal from './ConversionDeleteModal.vue';
import ConversionDetailModal from './ConversionDetailModal.vue';
import ConversionEditModal from './ConversionEditModal.vue';

export default {
    name: "Conversion",
    components: {
        Form,
        Field,
        ErrorMessage,
        ConversionDeleteModal,
        ConversionDetailModal,
        ConversionEditModal
    },
    data() {
        return {
            isVisibleDetail: false,
            isVisibleDelete: false,
            isVisibleEdit: false,
            currency_package: {},
        }
    },
    computed: {
        ...mapGetters('currency_packages', ["currencyPackages"])
    },
    created() {
        this.fetchPackages();
    },
    methods: {
        ...mapActions('currency_packages', [
            "fetchPackages",
            "editPackage",
            "deletePackage",
        ]),
        toCreate() {
            this.$router.push({ name: 'ConversionCreate' })
        },
        handleOpenDetail(currencyPackage) {
            this.isVisibleDetail = true;
            this.currency_package = currencyPackage;
        },
        handleOpenEdit(currencyPackage) {
            this.isVisibleEdit = true;
            this.currency_package = Object.assign({}, currencyPackage);
        },
        handleOpenDelete(currencyPackage) {
            this.isVisibleDelete = true;
            this.currency_package = currencyPackage;
        },
        handleClose() {
            this.isVisibleDelete = false;
            this.isVisibleDetail = false;
            this.isVisibleEdit = false;
            this.currency_package = {};
        },
        async handleDeletePackage(currency_package) {
            try {
                await this.deletePackage(currency_package);
                this.handleClose();
            } catch (error) {
                console.log(error);
            }
        },
        async handleEditPackage(currency_package) {
            try {
                await this.editPackage(currency_package);
                this.handleClose();
            } catch (error) {
                console.log(error);
            }
        },
    },
}
</script>