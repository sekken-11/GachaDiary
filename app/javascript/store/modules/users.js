import axios from '../../plugins/axios'

const state = {
    authUser: null
  }
  
  const getters =  {
    authUser: state => state.authUser
  }
  
  const mutations = {
    setUser: (state, user) => {
      state.authUser = user
    },
  }
  
  const actions = {
    async loginUser({ commit }, user) {
      // ログイン
      const sessionsResponse = await axios.post('sessions', user)
      localStorage.auth_token = sessionsResponse.data.token
      axios.defaults.headers.common['Authorization'] = `Bearer ${localStorage.auth_token}`
  
      // ログインユーザー情報のセット
      const userResponse = await axios.get('users/me')
      commit('setUser', userResponse.data)
    },
    logoutUser({ commit }) {
      // ログアウト
      localStorage.removeItem('auth_token')
      axios.defaults.headers.common['Authorization'] = ''
      commit('setUser', null)
    },
    async fetchAuthUser({ commit, state }) {
      if (!localStorage.auth_token) return null
      if (state.authUser) return state.authUser
  
      const userResponse = await axios.get('users/me')
        .catch((err) => {
          return null
        })
      if (!userResponse) return null
  
      const authUser = userResponse.data
      if (authUser) {
        commit('setUser', authUser)
        return authUser
      } else {
        commit('setUser', null)
        return null
      }
    },
    updateUser({commit, state}, user) {
      return axios.patch('users/' + state.authUser.id, user)
      .then(res => {
          commit('setUser', res.data)
      })
    },
    setProfile({commit}) {
      return axios.get('users/me')
      .then(res => {
        commit('setUser', res.data)
      })
    }
  }
  
  export default {
    namespaced: true,
    state,
    getters,
    mutations,
    actions
  }