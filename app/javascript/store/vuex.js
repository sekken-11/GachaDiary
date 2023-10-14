import { createStore } from 'vuex'
import users from './modules/users'
import gachas from './modules/gachas'
import posses_stones from './modules/posses_stones'
import transition from './modules/transition'

export default createStore({
    modules: {
        users,
        gachas,
        posses_stones,
        transition
    }
})
