<template>
<v-container>
  <div class="bg-white rounded shadow p-3 mb-3">
    <span class="h5 text-success">{{ authUser.email }} 様</span>
    <span class="text-muted"> の マイページ</span>
  </div>
  <v-row>
    <v-col cols="9">
      <v-row>
        <v-col cols="12">
          <div class="bg-white rounded shadow p-3">
            <div class="text-center mb-2">
              <span class="text-muted">ガチャ記録合計</span>
            </div>
            <div class="text-center h3">
              <span>{{ totalAmount }}円</span>
            </div>
          </div>
        </v-col>
        <v-col cols="12">
          <div class="bg-white rounded shadow p-3">
            <div class="h5 text-center my-2">
              <span class="text-muted">ゲームごとの割合</span>
            </div>
            <div v-if="gachas.length == 0" class="text-center text-muted my-5 h3">
              <span>ガチャ記録がありません</span>
            </div>
            <div v-if="gachas.length != 0">
              <div><Pie :data="chartData" :options="chartOptions" class="p-4" /></div>
              <hr>
              <div v-for="sortRecord in sortRecords">
                <v-row>
                  <v-col cols="4">
                    <span class="bg-info rounded px-2 py-2">
                      {{ percentage(sortRecord.gacha_count, sortRecord.need_one_gacha_price) }}
                    </span>
                  </v-col>
                  <v-col cols="4">
                    <span>{{ sortRecord.game_name }}</span>
                  </v-col>
                  <v-col cols="4">
                    <span>{{ amount(sortRecord.gacha_count, sortRecord.need_one_gacha_price) }}円</span>

                  </v-col>
                </v-row>
                <hr>
              </div>
            </div>
          </div>
        </v-col>
        <v-col cols="12">
          <div class="bg-white rounded shadow p-3 mb-3">
            <div class="text-center text-muted">
              <span>換算合計一覧</span>
            </div>
            <hr>
            <div v-if="totalRecords.length == 0" class="text-center text-muted p-3">
              <span>データがありません</span>
            </div>
            <div v-for="sortRecord in sortRecords" class="bg-light shadow-sm rounded my-2 p-2">
              <v-container class="pb-2">
                <v-row class="border-bottom">
                  <div class="mb-2">
                    <span>{{ sortRecord.game_name }}</span>
                  </div>
                </v-row>
                <v-row class="border-bottom">
                  <v-col cols="4" class="text-center border-end">
                    <span>金額</span>
                  </v-col>
                  <v-col cols="8" class="text-center">
                    <span>{{ amount(sortRecord.gacha_count, sortRecord.need_one_gacha_price) }}円</span>
                  </v-col>
                </v-row>
                <v-row>
                  <v-col cols="4" class="text-center border-end">
                    <span>回数</span>
                  </v-col>
                  <v-col cols="8" class="text-center">
                    <span>{{ sortRecord.gacha_count }}回</span>
                  </v-col>
                </v-row>
              </v-container>
            </div>

          </div>
        </v-col>
      </v-row>
    </v-col>
    <v-col cols="3">
      <div class="bg-white rounded shadow p-3 mb-3">
      </div>
    </v-col>
  </v-row>
</v-container>
</template>

<script>
import { mapGetters, mapActions } from 'vuex';
import { Chart as ChartJS, ArcElement, Tooltip } from 'chart.js';
import { Pie } from 'vue-chartjs';

ChartJS.register(ArcElement, Tooltip)

export default {
  name: 'Mypage',
  components: {
    Pie,
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
              '#41B883', '#E46651', '#00D8FF'
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
    ...mapActions('users', ["setUser"]),
    amount(gacha_count, need_one_gacha_price) {
      return Math.round(gacha_count*need_one_gacha_price)
    },
    percentage(gacha_count, need_one_gacha_price) {
      return (gacha_count*need_one_gacha_price/this.totalAmount*100).toFixed(1) + '%'
    }
  },
}

</script>

<style scoped>
</style>