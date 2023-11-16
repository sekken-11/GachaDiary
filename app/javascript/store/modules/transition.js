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
    setMessage: (state, { message, messageType}) => {
      state.message = message
      state.messageType = messageType
      setTimeout(() => (state.message = ''), 6000)
    },
  },
  actions: {
    datePick({commit}, date) {
      commit('setDate', date)
    },
    addMessage({commit}, { message, messageType }) {
      commit('setMessage', { message: message, messageType: messageType})
    },
  },
}