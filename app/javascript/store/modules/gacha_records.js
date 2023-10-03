import axios from '../../plugins/axios'

export default {
    namespaced: true,
    state: {
        gachas: [],
        currency_packages: [],
        currency_package: [],
    },
    getters: {
        currencyPackages: state => state.currency_packages,
        currencyPackage: state => state.currency_package,
        gachas(state) {
            return state.gachas.sort((a, b) => (a.date) - (y.date))
        },
    },
    mutations: {
        setPackages: (state, currency_packages) => {
            state.currency_packages = currency_packages
        },
        setPackage: (state, currency_package) => {
            state.currency_package = currency_package
        },
        addPackage: (state, currency_package) => {
            state.currency_packages.push(currency_package)
        },
        deletePackage: (state, deletePackage) => {
            state.currency_packages = state.currency_packages.filter(currency_package => {
                return currency_package.id != deletePackage.id
            })
        },
        changePackage: (state,changePackage) => {
            const index = state.currency_packages.findIndex(currency_package => {
                return currency_package.id == changePackage.id
            })
            state.currency_packages.splice(index, 1, changePackage)
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
        // 換算用データ取得（個別）
        fetchPackage({commit}, id) {
            axios.get('currency_packages/' + id)
            .then(res => {
                commit('setPackage', res.data)
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
        // 換算用データ編集
        editPackage({commit}, currency_package) {
            return axios.patch('currency_packages/' + currency_package.id, { currency_package: currency_package })
            .then(res => {
                commit('changePackage', res.data)
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