export default {
  namespaced: true,
  state: {
    date: new Date().toLocaleDateString('sv-SE'),
    message: '',
    messageType: 'danger',
  },
  getters: {
    selectDate: state => state.date,
    message: state => state.message,
    messageType: state => state.messageType,
  },
  mutations: {
    setDate: (state, date) => {
      state.date = date
    },
    undoDate: (state, date) => {
      state.date = new Date().toLocaleDateString('sv-SE')
    },
    setMessage: (state, { message, messageType, timeOut}) => {
      state.message = message
      state.messageType = messageType
      timeOut = timeOut || 5000
      setTimeout(() => (state.message = ''), timeOut)
    },
    deleteMessage: (state) => {
      state.message = ''
    },
  },
  actions: {
    datePick({commit}, date) {
      commit('setDate', date)
    },
    dateToday({ commit }) {
      commit('undoDate')
    },
    addMessage({commit}, { message, messageType, timeOut }) {
      commit('setMessage', { message: message, messageType: messageType, timeOut: timeOut})
    },
    emptyMessage({commit}) {
      commit('deleteMessage')
    },
  },
}