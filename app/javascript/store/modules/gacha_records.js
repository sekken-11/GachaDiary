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
        addPackage: (state, currency_package) => {
            state.currency_packages.push(currency_package)
        },
        deletePackage: (state, deletePackage) => {
            state.currency_packages = state.currency_packages.filter(currency_package => {
                return currency_package.id != deletePackage.id
            })
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
        // 換算用データ作成
        createPackage({commit}, currency_package) {
            return axios.post('currency_packages', { currency_package: currency_package })
            .then(res => {
                commit('addPackage', res.datas)
            })
        },
        // 換算用データ削除
        deletePackage({commit}, currency_package) {
            return axios.delete('currency_packages/' + currency_package.id)
            .then(res => {
                commit('deletePackage', res.data)
            })
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