import * as vueRouter from 'vue-router'
import Top from '../pages/Top.vue'
import Task from '../pages/tasks/Task.vue'

const routes = [
    {
        path: '/',
        name: 'Top',
        component: Top
    },
    {
        path: '/tasks',
        name: 'Task',
        component: Task
    }
]
    

const router = vueRouter.createRouter({
    history: vueRouter.createWebHistory(),
    routes: routes,
  })
  export default router