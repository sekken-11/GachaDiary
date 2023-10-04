import axios from '../../plugins/axios'

export default {
    namespaced: true,
    state: {
        gachas: []
    },
    getters: {
        gachas(state) {
            return state.gachas.sort((a, b) => (a.date) - (y.date))
        }
    },
    mutations: {
        setGachas: (state, gachas) => {
            state.gachas = gachas
        },
        addGacha: (state, gacha) => {
            state.gachas.push(gacha)
        },
    },
    actions: {
        // ガチャ記録取得
        fetchGachas({commit}) {
            axios.get('gachas')
            .then(res => {
                commit('setGachas', res.data)
            })
            .catch(err => console.log(err.response));
        },
        // ガチャ記録作成
        createGacha({commit}, gacha) {
            return axios.post('gachas', { gacha: gacha })
            .then(res => {
                commit('addGacha', res.data)
            })
        },
    }
}