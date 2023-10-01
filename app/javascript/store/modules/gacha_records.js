import axios from '../../plugins/axios'

export default {
    namespaced: true,
    state: {
        gachas: [],
        currency_packages: [],
    },
    getters: {
        currencyPackages: state => state.currency_packages,
        gachas(state) {
            return state.gachas.sort((a, b) => (a.date) - (y.date))
        },
    },
    mutations: {
        setPackages: (state, currency_packages) => {
            state.currency_packages = currency_packages
        },
        setGachas: (state, gachas) => {
            state.gachas = gachas
        },
        addGacha: (state, gacha) => {
            state.gachas.push(gacha)
        },
    },
    actions: {
        // 換算用データ取得
        fetchPackages({commit}) {
            axios.get('currency_packages')
            .then(res => {
                commit('setPackages', res.data)
            })
            .catch(err => console.log(err.response));
        },
        // ガチャ記録取得
        fetchGachas({commit}) {
            axios.get('gachas')
            .then(res => {
                commit('setGachas', res.data)
            })
            .catch(err => console.log(err.response));
        },
        //ガチャ記録作成
        createGacha({commit}, gacha) {
            return axios.post('gachas', { gacha: gacha })
            .then(res => {
                commit('addGacha', res.data)
            })
        },
    }
}