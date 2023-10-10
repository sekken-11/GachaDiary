import axios from '../../plugins/axios'

export default {
    namespaced: true,
    state: {
        gachas: [],
        gacha: [],
        currency_packages: [],
        currency_package: [],
    },
    getters: {
        gachas(state) {
            return state.gachas.sort((a, b) => {
                return (a.date < b.date ? 1 : -1);
            });
        },
        gacha: state => state.gacha,
        specificGachas(state, getters) {
            return getters.gachas.filter(gacha => {
                return gacha.currency_package_id == state.currency_package.id
            })
        },
        currencyPackages: state => state.currency_packages,
        currencyPackage: state => state.currency_package,
        totalRecords(state) {
            var hash
            const games = state.currency_packages.map(
                (cp) => hash = { id: cp.id, game_name: cp.name, gacha_count: 0, need_one_gacha_price: cp.price/cp.quantity*cp.need_one_gacha_stones }
            );
            games.forEach((game) => {
                state.gachas.forEach((gacha) => {
                    if (game.id == gacha.currency_package_id) {
                        game.gacha_count += gacha.count;
                    }
                });
            });
            return games
        },
        totalAmount(state, getters) {
            const records = getters.totalRecords.map(
                (h) => Math.round(h.gacha_count*h.need_one_gacha_price)
            );
            if (records.length != 0) {
                return records.reduce((a, b) => { return a + b });
            } else {
                return 0
            }
        },
    },
    mutations: {
        setGachas: (state, gachas) => {
            state.gachas = gachas
        },
        setGacha: (state, gacha) => {
            state.gacha = gacha
        },
        addGacha: (state, gacha) => {
            state.gachas.push(gacha)
        },
        changeGacha: (state, changeGacha) => {
            const index = state.gachas.findIndex(gacha => {
                return gacha.id == changeGacha.id
            })
            state.gachas.splice(index, 1, changeGacha)
        },
        deleteGacha: (state, deleteGacha) => {
            state.gachas = state.gachas.filter(gacha => {
                return gacha.id != deleteGacha.id
            })
        },
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
        // ガチャ記録取得（個別）
        fetchGacha({commit}, id) {
            axios.get('gachas/' + id)
            .then(res => {
                commit('setGacha', res.data)
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
        // ガチャ記録編集
        editGacha({commit}, gacha) {
            return axios.patch('gachas/' + gacha.id, { gacha: gacha })
            .then(res => {
                commit('changeGacha', res.data)
            })
        },
        // ガチャ記録削除
        deleteGacha({commit}, gacha) {
            return axios.delete('gachas/' + gacha.id)
            .then(res => {
                commit('deleteGacha', res.data)
            })
        },
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
    }
}