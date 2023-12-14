<template>
  <div
    v-if="message"
    class="flash-message"
    @click="deleteMessage"
    :class="{
      'flash-danger': messageType == 'danger',
      'flash-success': messageType == 'success',
    }"
  >
    <span>{{ message }}</span>
  </div>
</template>

<script>
import { mapGetters, mapActions } from "vuex";

export default {
  name: "FlashMessage",
  computed: {
    ...mapGetters("transition", [
      "message",
      "messageType"
    ]),
  },
  methods: {
    ...mapActions("transition", ["emptyMessage"]),
    deleteMessage() {
      this.emptyMessage();
    },
  },
};
</script>

<style scoped>
.flash-message {
  height: 90px;
  opacity: 0.8;
}
.flash-danger {
  background-color: darksalmon;
  color: white;
  font-size: 15px;
  text-align: center;
  padding: 0.7rem;
}
.flash-success {
  background-color: cornflowerblue;
  color: white;
  font-size: 15px;
  text-align: center;
  padding: 0.7rem;
}
span {
  display: flex;
  align-items: center;
  justify-content: center;
  height: 100%;
}
</style>
