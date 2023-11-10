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
            <div v-if="noPackage" class="text-center text-muted my-5 h3">
              <span>現金換算できる記録がありません</span>
            </div>
            <div v-if="gachas.length != 0 && !noPackage">
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

            <RecordPart v-for="(sortRecord, index) in sortRecords"
              :totalRecord="sortRecord"
              :key="sortRecord.id"
              :id="'record-' + (index + 1)"
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
              <p class="mb-1">ランク</p>
              <div v-if="stars">
                <div>
                  <i v-for="small_star in stars.milliom_stars" class="bi bi-star-fill" style="color:gold; font-size:200%;"></i>
                </div>
                <div>
                  <i v-for="small_star in stars.big_stars" class="bi bi-star-fill" style="color:gold; font-size:150%;"></i>
                </div>
                <div>
                  <i v-for="small_star in stars.small_stars" class="bi bi-star-fill" style="color:gold;"></i>
                </div>
                <div v-if="stars.milliom_stars == 0 && stars.big_stars == 0 && stars.small_stars == 0">
                  <i class="bi bi-star-half" style="color:gold;"></i>
                </div>
              </div>
              <div v-if="!stars">
                <i class="bi bi-star"></i>
              </div>
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
    noPackage() {
      const ary = this.gachas.filter(gacha => {
        return gacha.currency_package != null
      })
      if (ary.length == 0) {
        return true
      } else if (ary.length != 0) {
        return false
      }
    },
    stars() {
      if (this.totalAmount == 0) {
        return false
      } else if (this.totalAmount != 0) {
        const milliom_stars = Math.floor(this.totalAmount / 1000000)
        const big_stars = Math.floor((this.totalAmount % 1000000) / 100000)
        const small_stars = Math.floor((this.totalAmount % 100000) / 10000)
        return { "milliom_stars": milliom_stars, "big_stars": big_stars, "small_stars": small_stars }
      }
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