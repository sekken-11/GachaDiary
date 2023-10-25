import * as vueRouter from 'vue-router'
import Top from '../pages/Top.vue'
import Gacha from '../pages/gachas/Gacha.vue'
import GachaEdit from '../pages/gachas/GachaEdit.vue'
import Game from '../pages//games/Game.vue'
import GameCreate from '../pages/games/GameCreate.vue'
import GameEdit from '../pages/games/GameEdit.vue'
import Conversion from '../pages/conversions/Conversion.vue'
import ConversionCreate from '../pages/conversions/ConversionCreate.vue'
import ConversionEdit from '../pages/conversions/ConversionEdit.vue'
import Calendar from '../pages/calenders/Calendar.vue'
import SignUp from '../pages/user_session/Signup.vue'
import SignIn from '../pages/user_session/Signin.vue'
import GachaRecordCreate from '../pages/form/GachaRecordCreate.vue'
import GameFullData from '../pages/GameFullData.vue'
import MyPage from '../pages/MyPage.vue'
import PasswordReset from '../pages/profiles/PasswordReset.vue'
import EmailChange from '../pages/profiles/EmailChange.vue'
import Information from '../pages/Information.vue'

import store from '../store/vuex'



const routes = [
    {
        path: '/',
        name: 'Top',
        component: Top
    },
    {
        path: '/info',
        name: 'Information',
        component: Information
    },
    {
        path: '/passreset',
        name: 'PasswordReset',
        component: PasswordReset
    },
    {
        path: '/mailchange',
        name: 'EmailChange',
        component: EmailChange,
        meta: { requiredAuth: true },
    },
    {
        path: '/gachas',
        name: 'Gacha',
        component: Gacha,
        meta: { requiredAuth: true },
    },
    {
        path: '/gachas/edit/:id',
        name: 'GachaEdit',
        component: GachaEdit,
        meta: { requiredAuth: true },
    },
    {
        path: '/games',
        name: 'Game',
        component: Game,
        meta: { requiredAuth: true },
    },
    {
        path: '/games/new',
        name: 'GameCreate',
        component: GameCreate,
        meta: { requiredAuth: true },
    },
    {
        path: '/games/edit/:id',
        name: 'GameEdit',
        component: GameEdit,
        meta: { requiredAuth: true },
    },
    {
        path: '/conversions',
        name: 'Conversion',
        component: Conversion,
        meta: { requiredAuth: true },
    },
    {
        path: '/conversions/new',
        name: 'ConversionCreate',
        component: ConversionCreate,
        meta: { requiredAuth: true },
    },
    {
        path: '/conversions/edit/:id',
        name: 'ConversionEdit',
        component: ConversionEdit,
        meta: { requiredAuth: true },
    },
    {
        path: '/calendars',
        name: 'Calendar',
        component: Calendar,
        meta: { requiredAuth: true },
    },
    {
        path: '/signup',
        name: 'SignUp',
        component: SignUp,
        meta: { doNotAuth: true }
    },
    {
        path: '/signin',
        name: 'SignIn',
        component: SignIn,
        meta: { doNotAuth: true }
    },
    {
        path: '/gachareco',
        name: 'GachaRecordCreate',
        component: GachaRecordCreate,
        meta: { requiredAuth: true },
    },
    {
        path: '/gamedata/:id',
        name: 'GameFullData',
        component: GameFullData,
        meta: { requiredAuth: true },
    },
    {
        path: '/mypage',
        name: 'MyPage',
        component: MyPage,
        meta: { requiredAuth: true },
    },
]
    

const router = vueRouter.createRouter({
    history: vueRouter.createWebHistory(),
    routes: routes,
  })

router.beforeEach((to, from, next) => {
    store.dispatch('users/fetchAuthUser').then((authUser) => {
        if (to.matched.some(record => record.meta.requiredAuth) && !authUser) {
            next({ name: 'SignIn' });
        } else {
            next();
        }
    })
});

router.beforeEach((to, from, next) => {
    store.dispatch('users/fetchAuthUser').then((authUser) => {
        if (to.matched.some(record => record.meta.doNotAuth) && authUser) {
            next({ name: 'Top' });
        } else {
            next();
        }
    })
});

export default router