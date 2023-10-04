import axios from '../../plugins/axios'

export default {
    namespaced: true,
    state: {
        currency_packages: [],
    },
    getters: {
        currencyPackages: state => state.currency_packages,
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
        changePackage: (state,changePackage) => {
            const index = state.currency_packages.findIndex(currency_package => {
                return currency_package.id == changePackage.id
            })
            state.currency_packages.splice(index, 1, changePackage)
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
        // 換算用データ編集
        editPackage({commit}, currency_package) {
            return axios.patch('currency_packages/' + currency_package.id, { currency_package: currency_package })
            .then(res => {
                commit('changePackage', res.data)
            })
        },
    }
}