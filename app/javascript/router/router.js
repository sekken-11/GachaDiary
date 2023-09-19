import { createRouter, createWebHistory } from 'vue-router'
import TopIndex from '../pages/Top.vue'
import TaskIndex from '../pages/tasks/Task.vue'

const routes = [
    {
        path: '/top',
        name: 'Top',
        component: TopIndex
    },
    {
        path: '/task',
        name: 'Task',
        component: TaskIndex
    }
]
    

const router = createRouter({
    history: createWebHistory(), 
    routes,
    })
    
export default router