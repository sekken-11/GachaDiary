import { createStore } from 'vuex'
import users from './modules/users'
import gacha_records from './modules/gacha_records'

export default createStore({
    modules: {
        users,
        gacha_records,
    }
})
