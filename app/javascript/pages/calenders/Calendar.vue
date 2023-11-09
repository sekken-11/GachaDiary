<template>
<div id="calendar" class="bg-white rounded shadow p-3 mb-3">
  <div class="mb-4">
    <v-btn block color="success" @click="eventChange">表示切替</v-btn>
  </div>
  <FullCalendar :options='calendarOptions' />
</div>

<GachaRecordPart :gachas="daysGachas" :perPage="perPage" :search="search_null">日付が選択されていません</GachaRecordPart>

</template>

<script>
import FullCalendar from '@fullcalendar/vue3'
import dayGridPlugin from '@fullcalendar/daygrid'
import interactionPlugin from '@fullcalendar/interaction'
import { mapGetters, mapActions } from 'vuex';
import GachaRecordPart from '../../components/GachaRecordPart.vue';

export default {
  name: 'Calendar',
  components: {
    FullCalendar,
    GachaRecordPart,
  },
  data() {
    return {
      event_type: 'gacha_count',
      perPage: 5,
      date: new Date().toLocaleDateString('sv-SE'),
      search_null: '',
      calendarOptions: {
        locale: 'ja',
        plugins: [dayGridPlugin, interactionPlugin],
        initialView: 'dayGridMonth',
        events: [],
        dateClick: (info) => {
          this.toCreate(info.date)
        },
        eventClick: (info) => {
          this.daySelect(info.event.start)
        },
        headerToolbar: {
          left: 'prev',
          center: 'title',
          right: 'next'
        },
        eventClassNames: ['text-center'],
        fixedWeekCount: false,
      }
    }
  },
  computed: {
    ...mapGetters('gachas', ["gachas"]),
    daysGachas() {
      return this.gachas.filter(gacha => {
        return gacha.date.indexOf(this.date) != -1
      })
    },
  },
  watch: {
    gachas() {
      this.calendarEvents()
    },
  },
  created() {
    this.fetchGachas();
    this.datePick(this.date);
  },
  methods: {
    ...mapActions('transition', ["datePick"]),
    ...mapActions('gachas', ["fetchGachas"]),
    toCreate(date) {
      this.datePick(date.toLocaleDateString('sv-SE'));
      this.$router.push({ name: 'GachaRecordCreate' })
    },
    calendarEvents() {
      if (this.gachas.length > 0) {
        if (this.event_type == 'gacha_count') {
        var array = [{ title: 0, start: this.gachas[0].date }]
        var int = 0
        this.gachas.forEach(gacha => {
          if (array[int].start == gacha.date) {
            array[int].title += gacha.count
          } else if (array[int].start != gacha.date) {
            if (!array[int + 1]) {
              int += 1
              array.push({ title: gacha.count, start: gacha.date })
            }
          }
        });
        array.forEach(gacha => {
          gacha.title = gacha.title + '回'
        })
      } else if (this.event_type == 'gacha_price') {
        var array = [{ title: 0, start: this.gachas[0].date }]
        var int = 0
        this.gachas.forEach(gacha => {
          if (array[int].start == gacha.date) {
            if (gacha.currency_package_id) {
              array[int].title += Math.round(gacha.currency_package.price/gacha.currency_package.quantity*gacha.currency_package.need_one_gacha_stones*gacha.count)
            } else if (!gacha.currency_package_id) {
              array[int].title += 0
            }
          } else if (array[int].start != gacha.date) {
            if (!array[int + 1]) {
              int += 1
              if (gacha.currency_package) {
                array.push({ title: Math.round(gacha.currency_package.price/gacha.currency_package.quantity*gacha.currency_package.need_one_gacha_stones*gacha.count), start: gacha.date })
              } else if (!gacha.currency_package) {
                array.push({ title: 0, start: gacha.date })
              }
            }
          }
        });
        array.forEach(gacha => {
          gacha.title = gacha.title + '円'
        })
      }
      this.calendarOptions.events = array
      } else if (this.gachas.length == 0) {
        this.calendarOptions.events = []
      }
      
    },
    daySelect(day) {
      this.date = day.toLocaleDateString('sv-SE')
    },
    eventChange() {
      if (this.event_type == 'gacha_count') {
        this.event_type = 'gacha_price'
      } else {
        this.event_type = 'gacha_count'
      }
      this.calendarEvents()
    },
  },
}
</script>

<style>
@media (max-width:767px) {
  .fc-daygrid-body {
    width: 100% !important;
    height: 100% !important;
  }
  .fc-col-header {
    width: 100% !important;
    height: 100% !important;
  }
  .fc-scrollgrid-sync-table {
    width: 100% !important;
    height: 100% !important;
  }
}
</style>