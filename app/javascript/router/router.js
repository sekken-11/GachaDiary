import * as vueRouter from 'vue-router'
import Top from '../pages/Top.vue'
import Gacha from '../pages/Gacha.vue'
import Game from '../pages/Game.vue'
import ConData from '../pages/Conversion_Data.vue'
import Calender from '../pages/Calender.vue'
import SignUp from '../pages/user_session/Signup.vue'
import SignIn from '../pages/user_session/Signin.vue'
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
        path: '/Games',
        name: 'Game',
        component: Game,
        meta: { requiredAuth: true },
    },
    {
        path: '/condata',
        name: 'ConData',
        component: ConData,
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
        component: SignUp
    },
    {
        path: '/signin',
        name: 'SignIn',
        component: SignIn
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

export default router