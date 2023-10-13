<template>
<div class="bg-white rounded shadow p-3 mb-3">
  <FullCalendar :options='calendarOptions'
  />
  {{test}}
</div>

<GachaRecordPart :gachas="daysGachas" :perPage="perPage">日付が選択されていません</GachaRecordPart>

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
      perPage: 5,
      date: '2023-10-12',
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
        eventColor: 'rightblue',
        eventClassNames: ['text-center', 'mx-3'],
        dayHeaderClassNames: [''],
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
      this.calendarEvents();
    },
  },
  created() {
    this.fetchGachas();
  },
  methods: {
    ...mapActions('transition', ["datePick"]),
    ...mapActions('gachas', ["fetchGachas"]),
    toCreate(date) {
      this.datePick(date.toLocaleDateString('sv-SE'));
      this.$router.push({ name: 'GachaRecordCreate' })
    },
    calendarEvents() {
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
      this.calendarOptions.events = array
    },
    daySelect(day) {
      this.date = day.toLocaleDateString('sv-SE')
    },
  },
}
</script>