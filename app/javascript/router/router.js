import * as vueRouter from 'vue-router'
import Top from '../pages/Top.vue'
import Gacha from '../pages/Gacha.vue'
import Game from '../pages//games/Game.vue'
import GameCreate from '../pages/games/GameCreate.vue'
import Conversion from '../pages/conversions/Conversion.vue'
import ConversionCreate from '../pages/conversions/ConversionCreate.vue'
import Calender from '../pages/Calender.vue'
import SignUp from '../pages/user_session/Signup.vue'
import SignIn from '../pages/user_session/Signin.vue'
import GachaRecordCreate from '../pages/form/GachaRecordCreate.vue'
import store from '../store/vuex'



const routes = [
    {
        path: '/',
        name: 'Top',
        component: Top
    },
    {
        path: '/gachas',
        name: 'Gacha',
        component: Gacha,
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
        path: '/conversions',
        name: 'Conversion',
        component: Conversion,
        meta: { requiredAuth: true },
    },
    {
        path: '/conversion/new',
        name: 'ConversionCreate',
        component: ConversionCreate,
        meta: { requiredAuth: true },
    },
    {
        path: '/calender',
        name: 'Calender',
        component: Calender,
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