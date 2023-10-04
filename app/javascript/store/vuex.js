import { createStore } from 'vuex'
import users from './modules/users'
import gachas from './modules/gachas'
import currency_packages from './modules/currency_packages'
import posses_stones from './modules/posses_stones'

export default createStore({
    modules: {
        users,
        gachas,
        currency_packages,
        posses_stones
    }
})
