<template>
<v-container>
  <div class="bg-white rounded shadow p-3 mb-3">
    <span class="h5 text-success">{{ authUser.email }} 様</span>
    <span class="text-muted"> の マイページ</span>
  </div>
  <v-row>
    <v-col cols="12" md="9">
      <v-row>
        <v-col cols="12">
          <div id="total" class="bg-white rounded shadow p-3">
            <div class="text-center mb-2">
              <span class="text-muted">ガチャ記録合計</span>
            </div>
            <div class="text-center h3">
              <span>{{ totalAmount }}円</span>
            </div>
          </div>
        </v-col>
        <v-col cols="12">
          <div id="chart" class="bg-white rounded shadow p-3">
            <div class="h5 text-center my-2">
              <span class="text-muted">ゲームごとの割合</span>
            </div>
            <div v-if="gachas.length == 0" class="text-center text-muted my-5 h3">
              <span>ガチャ記録がありません</span>
            </div>
            <div v-if="gachas.length != 0">
              <div id="pie-chart">
                <Pie :data="chartData" :options="chartOptions" class="p-4" />
              </div>
              <hr>
              <div v-for="(sortRecord, index) in sortRecords" :id="'game-' + (index + 1)">
                <v-row>
                  <v-col cols="4" class="text-center">
                    <span>{{ sortRecord.game_name }}</span>
                  </v-col>
                  <v-col cols="4" class="text-center">
                    <span class="bg-warning rounded px-2 py-2">
                      {{ percentage(sortRecord.gacha_count, sortRecord.need_one_gacha_price) }}
                    </span>
                  </v-col>
                  <v-col cols="4" class="text-center">
                    <span>{{ amount(sortRecord.gacha_count, sortRecord.need_one_gacha_price) }}円</span>
                  </v-col>
                </v-row>
                <hr>
              </div>
            </div>
          </div>
        </v-col>
        <v-col cols="12">
          <div id="totalrecords" class="bg-white rounded shadow p-3 mb-3">
            <div class="text-center text-muted">
              <span>換算合計一覧</span>
            </div>
            <hr>
            <div v-if="totalRecords.length == 0" class="text-center text-muted p-3">
              <span>データがありません</span>
            </div>

            <RecordPart v-for="sortRecord in sortRecords"
              :totalRecord="sortRecord"
              :key="sortRecord.id"
              :id="'record-' + sortRecord.id"
              @toGameFullData="toGameFullData(sortRecord.id)"
            />

          </div>
        </v-col>
      </v-row>
    </v-col>
    <v-col cols="12" md="3">
      <div id="user-info" class="bg-white rounded shadow p-3 mb-3">
        <div class="text-muted">
          <h4>ユーザー情報</h4>
            <hr>
          <p class="mb-1">メールアドレス</p>
          <p class="text-success">{{ authUser.email }}</p>
            <hr>
          <p class="mb-1">記録開始日</p>
          <p class="text-success">{{ new Date(authUser.created_at).toLocaleDateString('sv-SE') }}</p>
            <hr>
        </div>
        <div class="text-muted mt-5">
          <h4>アカウント管理</h4>
            <hr>
          <v-btn block class="bg-info" @click="toPasswordReset">パスワード変更</v-btn>
            <hr>
          <v-btn block class="bg-info" @click="toEmailChange">メールアドレス変更</v-btn>
            <hr>
        </div>
      </div>
    </v-col>
  </v-row>
</v-container>
</template>

<script>
import { mapGetters, mapActions } from 'vuex';
import { Chart as ChartJS, ArcElement, Tooltip } from 'chart.js';
import { Pie } from 'vue-chartjs';
import RecordPart from '../components/RecordPart.vue';

ChartJS.register(ArcElement, Tooltip)

export default {
  name: 'Mypage',
  components: {
    Pie,
    RecordPart
  },
  computed: {
    ...mapGetters('gachas', [
      "gachas", "currencyPackages", "totalRecords", "totalAmount"
    ]),
    ...mapGetters('users', ["authUser"]),
    chartData() {
      return {
        labels: this.pieLabels,
        datasets: [
          {
            data: this.pieData,
            backgroundColor: [
              'antiquewhite',
              'aqua',
              'aquamarine',
              'bisque',
              'burlywood',
              'chocolate',
              'coral',
              'cornflowerblue',
              'crimson',
              'cyan',
              'darkcyan',
              'darkorange',
            ],
            hoverOffset: 4,
          },
        ],
      }
    },
    chartOptions() {
      return {
        responsive: true,
        maintainAspectRatio: false
      }
    },
    sortRecords() {
      return this.totalRecords.sort((a, b) => {
        return (Math.round(a.gacha_count*a.need_one_gacha_price) < Math.round(b.gacha_count*b.need_one_gacha_price) ? 1 : -1);
      });
    },
    pieData() {
      return this.sortRecords.map((sortRecord) => {
        return Math.round(sortRecord.gacha_count*sortRecord.need_one_gacha_price)
      });
    },
    pieLabels() {
      return this.sortRecords.map((sortRecord) => {
        return sortRecord.game_name
      });
    },
  },
  created() {
    this.fetchGachas();
    this.fetchPackages();
    this.setProfile();
  },
  methods: {
    ...mapActions('gachas', [
      "fetchGachas",
      "fetchPackages",
    ]),
    ...mapActions('users', ["setProfile"]),
    amount(gacha_count, need_one_gacha_price) {
      return Math.round(gacha_count*need_one_gacha_price)
    },
    percentage(gacha_count, need_one_gacha_price) {
      return (gacha_count*need_one_gacha_price/this.totalAmount*100).toFixed(1) + '%'
    },
    toPasswordReset() {
      this.$router.push({ name: 'PasswordReset' })
    },
    toEmailChange() {
      this.$router.push({ name: 'EmailChange' })
    },
    toGameFullData(int) {
      this.$router.push({ name: 'GameFullData', params: { id: int} })
    }
  },
}

</script>

<style scoped>
</style>