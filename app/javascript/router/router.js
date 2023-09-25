import * as vueRouter from 'vue-router'
import Top from '../pages/Top.vue'
import Gacha from '../pages/Gacha.vue'
import Game from '../pages/Game.vue'
import ConData from '../pages/Conversion_Data.vue'
import Calender from '../pages/Calender.vue'


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
]
    

const router = vueRouter.createRouter({
    history: vueRouter.createWebHistory(),
    routes: routes,
  })
  export default router