import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '../views/HomeView.vue'
import loginForm from '@/Forms/loginForm.vue'
import resetPassword from '@/Forms/resetPassword.vue'
import OauthSuccess from '@/pages/oauthSuccess.vue'
import registerForm from '@/Forms/registerForm.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    { path: '/', name: 'home', component: HomeView },
    { path: '/login', name: 'login', component: loginForm },
    { path: '/reset_password', name: 'reset_password', component: resetPassword },
    { path: '/oauth-success', name: 'oauth-success', component: OauthSuccess },
    { path: '/create-account', name: 'create-account', component: registerForm }
  ],
})

export default router
