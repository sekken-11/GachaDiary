<template>
<v-btn block id="top" color="info" class="mb-3" @click="toCreate">ガチャ記録 新規作成</v-btn>
<div class="form-group mb-3" id="search-form">
  <input type="text" v-model="search" class="form-control" id="search" placeholder="備考で絞り込み">
</div>
<div class="form-group mb-3" id="search-form">
  <input type="checkbox" id="checkbox" v-model="checked" />
  <label for="checkbox"><span class="text-muted ms-1">備考から正確な検索を行う</span></label>
  <v-autocomplete
    v-if="checked"
    v-model="search"
    class="form-control mt-1"
    id="search"
    :items="descriptions"
    color="white"
    hide-no-data="true"
    label="備考で絞り込み"
  >
  </v-autocomplete>
</div>
<div class="" id="date-form">
  <v-row>
    <v-col cols="6">
      <div class="form-group">
        <input id="from_date" type="date" v-model="from_date" class="form-control">
      </div>
    </v-col>
    <v-col cols="6">
      <div class="form-group">
        <input id="to_date" type="date" v-model="to_date" class="form-control">
      </div>
    </v-col>
  </v-row>
</div>
<div class="mb-3" id="count-form">
  <v-row>
    <v-col cols="6">
      <div class="form-group">
        <input id="from_count" v-model.number="from_count" class="form-control" placeholder="回数下限">
      </div>
    </v-col>
    <v-col cols="6">
      <div class="form-group">
        <input id="to_count" v-model.number="to_count" class="form-control" placeholder="回数上限">
      </div>
    </v-col>
  </v-row>
</div>
<div class="form-group mb-3" id="select-form">
  <select v-model="select" class="form-control" id="select">
    <option value="" selected>ゲーム名を指定しない</option>
    <option v-for="currencyPackage in currencyPackages" :key="currencyPackage.id" :value="currencyPackage.id">
      {{ currencyPackage.name }}
    </option>
    <option value="null" selected>未設定</option>
  </select>
</div>

<GachaRecordPart 
  :gachas="gachas" 
  :perPage="perPage" 
  :search="search" 
  :select="select" 
  :from_date="from_date" 
  :to_date="to_date"
  :from_count="from_count"
  :to_count="to_count"
>
  データがありません
</GachaRecordPart>

</template>

<script>
import { mapGetters, mapActions } from 'vuex';
import GachaRecordPart from '../../components/GachaRecordPart.vue';

export default {
  name: "Gacha",
  components: {
    GachaRecordPart,
  },
  data() {
    return {
      perPage: 10,
      search: this.search = this.$route.query.search || '',
      select: this.select = this.$route.query.select || '',
      from_date: this.from_date = this.$route.query.from || '',
      to_date: this.to_date = this.$route.query.to || '',
      from_count: this.from_count = this.$route.query.fcount || '',
      to_count: this.to_count = this.$route.query.tcount || '',
      checked: false,
    }
  },
  computed: {
    ...mapGetters('gachas', [
      "gachas",
      "currencyPackages"
    ]),
    descriptions() {
      return this.gachas.map(gacha => gacha.description)
    },
  },
  created() {
    this.fetchGachas();
  },
  methods: {
    ...mapActions('gachas', ["fetchGachas"]),
    toCreate() {
      this.$router.push({ name: 'GachaRecordCreate' })
    },
  },
}
</script>