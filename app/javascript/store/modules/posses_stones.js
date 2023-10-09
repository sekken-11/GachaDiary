import axios from '../../plugins/axios'

export default {
    namespaced: true,
    state: {
        posses_stones: [],
        posses_stone: [],
    },
    getters: {
        possesStones: state => state.posses_stones,
        possesStone: state => state.posses_stone,
    },
    mutations: {
        setPossesStones: (state, posses_stones) => {
            state.posses_stones = posses_stones
        },
        setPossesStone: (state, posses_stone) => {
            state.posses_stone = posses_stone
        },
        addPossesStone: (state, posses_stone) => {
            state.posses_stones.push(posses_stone)
        },
        deletePossesStone: (state, deletePossesStone) => {
            state.posses_stones = state.posses_stones.filter(posses_stone => {
                return posses_stone.id != deletePossesStone.id
            })
        },
        changePossesStone: (state,changePossesStone) => {
            const index = state.posses_stones.findIndex(posses_stone => {
                return posses_stone.id == changePossesStone.id
            })
            state.posses_stones.splice(index, 1, changePossesStone)
        },
    },
    actions: {
        // 所持石データ取得
        fetchPossesStones({commit}) {
            axios.get('user_posses_stones')
            .then(res => {
                commit('setPossesStones', res.data)
            })
            .catch(err => console.log(err.response));
        },
        // 所持石データ取得（個別）
        fetchPossesStone({commit}, id) {
            axios.get('user_posses_stones/' + id)
            .then(res => {
                commit('setPossesStone', res.data)
            })
            .catch(err => console.log(err.response));
        },
        // 所持石データ作成
        createPossesStone({commit}, posses_stone) {
            return axios.post('user_posses_stones', { user_posses_stone: posses_stone })
            .then(res => {
                commit('addPossesStone', res.data)
            })
        },
        // 所持石データ削除
        deletePossesStone({commit}, posses_stone) {
            return axios.delete('user_posses_stones/' + posses_stone.id)
            .then(res => {
                commit('deletePossesStone', res.data)
            })
        },
        editPossesStone({commit}, posses_stone) {
            return axios.patch('user_posses_stones/' + posses_stone.id, { user_posses_stone: posses_stone })
            .then(res => {
                commit('changePossesStone', res.data)
            })
        },
    }
}