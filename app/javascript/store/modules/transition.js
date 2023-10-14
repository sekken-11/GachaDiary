export default {
  namespaced: true,
  state: {
    date: new Date().toLocaleDateString('sv-SE')
  },
  getters: {
    selectDate: state => state.date,
  },
  mutations: {
    setDate: (state, date) => {
      state.date = date
    },
  },
  actions: {
    datePick({commit}, date) {
      commit('setDate', date)
    },
  },
}