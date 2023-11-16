<template> 
<div 
 v-if="message"
 :class="{ 'flash-danger': messageType == 'danger',
           'flash-success': messageType == 'success' }"
>
  <span>{{ message }}</span>
</div>
</template>

<script>
import { mapGetters, mapActions } from 'vuex';

export default {
  name: "FlashMessage",
  computed: {
    ...mapGetters('transition', [
      "message",
      "messageType",
    ]),
  }
}
</script>

<style scoped>
.flash-danger {
  background-color: darksalmon;
  color: white;
  font-size: 15px;
  text-align: center;
  padding: 0.7rem
}
.flash-success {
  background-color: cornflowerblue;
  color: white;
  font-size: 15px;
  text-align: center;
  padding: 0.7rem
}
</style>