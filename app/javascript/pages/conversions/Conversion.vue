<template>
<v-btn block class="mb-3 p-2" color="info" @click="toCreate">換算用データ 作成</v-btn>

<div id="initial-packages" class="bg-white rounded shadow p-3 mb-3">
    <div class="text-center text-muted">
    <span>初期登録データ 一覧</span>
    <button id="package-up" v-if="isVisibleInitialPackage" class="border-0 bg-white text-muted" @click="initialPackageUp"><i class="bi bi-chevron-up"></i></button>
    <button id="package-down" v-if="!isVisibleInitialPackage" class="border-0 bg-white text-muted" @click="initialPackageDown"><i class="bi bi-chevron-down"></i></button>
  </div>
  <hr>
    <div v-for="(initialPackage, index) in initialPackages"
         v-if="isVisibleInitialPackage"
         :key="initialPackage.id"
         :id="'initial-package-' + (index + 1)"
         class="bg-light border shadow-sm rounded my-2 py-2"
    >
      <v-container>
        <v-row class="border-bottom pb-2 mx-2">
          <span>{{ initialPackage.name }}</span>
        </v-row>
      </v-container>
      <div class="pt-2 px-4">
        <ul class="text-end mb-0">
          <button class="btn btn-sm btn-outline-info me-2" @click="handleOpenDetail(initialPackage)">詳細</button>
        </ul>
      </div>
    </div>
</div>

<div id="packages" class="bg-white rounded shadow p-3 mb-3">
    <div class="text-center text-muted">
    <span>追加データ 一覧</span>
  </div>
  <hr>
  <div v-if="userAddPackages.length == 0" class="text-center text-muted p-3">
    <span>データがありません</span>
  </div>
    <div v-for="(userAddPackage, index) in userAddPackages"
         :key="userAddPackage.id"
         :id="'package-' + (index + 1)"
         class="bg-light border shadow-sm rounded my-2 py-2"
    >
      <v-container>
        <v-row class="border-bottom pb-2 mx-2">
          <span>{{ userAddPackage.name }}</span>
        </v-row>
      </v-container>
      <div class="pt-2 px-4">
        <ul class="text-end mb-0">
          <button class="btn btn-sm btn-outline-info me-2" @click="handleOpenDetail(userAddPackage)">詳細</button>
          <button class="btn btn-sm btn-outline-success me-2" @click="toEdit(userAddPackage.id)">編集</button>
          <button class="btn btn-sm btn-outline-danger" @click="handleOpenDelete(userAddPackage)">削除</button>
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
            isVisibleInitialPackage: false,
        }
    },
    computed: {
        ...mapGetters('gachas', ["currencyPackages"]),
        initialPackages() {
          var initial_packages =  this.currencyPackages.filter(currencyPackage => {
            return currencyPackage.category == "initial"
          })
          return initial_packages.sort((a, b) => {
            return (a.name > b.name ? 1 : -1)
          });
        },
        userAddPackages() {
          var packages = this.currencyPackages.filter(currencyPackage => {
            return currencyPackage.category == "add"
          })
          return packages.sort((a, b) => {
            return (a.name > b.name ? 1 : -1)
          });
        },
    },
    created() {
        this.fetchPackages();
        this.fetchGachas();
    },
    methods: {
        ...mapActions('gachas', [
            "fetchPackages",
            "deletePackage",
            "fetchGachas",
        ]),
        ...mapActions('transition', ["addMessage"]),
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
        initialPackageUp() {
          this.isVisibleInitialPackage = false;
        },
        initialPackageDown() {
          this.isVisibleInitialPackage = true;
        },
        async handleDeletePackage(currency_package) {
            try {
                await this.deletePackage(currency_package);
                this.handleClose();
                this.addMessage({
                    message: "換算用データを削除しました",
                    messageType: "success"
                })
            } catch (error) {
                console.log(error);
                this.addMessage({
                    message: "換算用データの削除に失敗しました",
                    messageType: "danger"
                })
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