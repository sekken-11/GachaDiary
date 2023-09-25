import * as vueRouter from 'vue-router'
import Top from '../pages/Top.vue'
import Gacha from '../pages/Gacha.vue'
import Game from '../pages/Game.vue'
import ConData from '../pages/Conversion_Data.vue'
import Calender from '../pages/Calender.vue'
import SignUp from '../pages/user_session/Signup.vue'
import SignIn from '../pages/user_session/Signin.vue' 



const routes = [
    {
        path: '/',
        name: 'Top',
        component: Top
    },
    {
        path: '/gachas',
        name: 'Gacha',
        component: Gacha
    },
    {
        path: '/Games',
        name: 'Game',
        component: Game
    },
    {
        path: '/condata',
        name: 'ConData',
        component: ConData
    },
    {
        path: '/calender',
        name: 'Calender',
        component: Calender
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
  export default router