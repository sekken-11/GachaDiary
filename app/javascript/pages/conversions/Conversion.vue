<template>
<v-btn block class="mb-3 p-2" color="info" @click="toCreate">換算用データ 作成</v-btn>
<div class="bg-white rounded shadow p-3 mb-3">
    <div class="text-center text-muted">
    <span>換算用データ 一覧</span>
  </div>
  <hr>
  <div v-if="currencyPackages.length == 0" class="text-center text-muted p-3">
    <span>データがありません</span>
  </div>
    <div v-for="currencyPackage in currencyPackages"
         :key="currencyPackage.id"
         class="bg-light border shadow-sm rounded my-2 py-2"
    >
      <v-container>
        <v-row class="border-bottom pb-2 mx-2">
          <span>{{ currencyPackage.name }}</span>
        </v-row>
      </v-container>
      <div class="pt-2 px-4">
        <ul class="text-end mb-0">
          <button class="btn btn-sm btn-outline-info me-2" @click="handleOpenDetail(currencyPackage)">詳細</button>
          <button class="btn btn-sm btn-outline-success me-2" @click="toEdit(currencyPackage.id)">編集</button>
          <button class="btn btn-sm btn-outline-danger" @click="handleOpenDelete(currencyPackage)">削除</button>
        </ul>
      </div>
    </div>
</div>

  <transition name="fade">
    <ConversionDetailModal v-if="isVisibleDetail" :currency_package="currency_package" @Close="handleClose" />
  </transition>

  <transition name="fade">
    <DeleteModal v-if="isVisibleDelete" :deleteData="currency_package" @Close="handleClose" @Delete="handleDeletePackage" />
  </transition>
    
</template>

<script>
import { mapGetters, mapActions } from 'vuex';
import ConversionDetailModal from './ConversionDetailModal.vue';
import ConversionEdit from './ConversionEdit.vue';
import DeleteModal from '../../components/DeleteModal.vue';

export default {
    name: "Conversion",
    components: {
        ConversionDetailModal,
        ConversionEdit,
        DeleteModal
    },
    data() {
        return {
            isVisibleDetail: false,
            isVisibleDelete: false,
        }
    },
    computed: {
        ...mapGetters('gachas', ["currencyPackages"])
    },
    created() {
        this.fetchPackages();
    },
    methods: {
        ...mapActions('gachas', [
            "fetchPackages",
            "deletePackage",
        ]),
        toCreate() {
            this.$router.push({ name: 'ConversionCreate' })
        },
        toEdit(int) {
            this.$router.push({ name: 'ConversionEdit', params: { id: int } })
        },
        handleOpenDetail(currencyPackage) {
            this.isVisibleDetail = true;
            this.currency_package = currencyPackage;
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