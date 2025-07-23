import { createRouter, createWebHistory } from 'vue-router'
import loginForm from '@/Forms/loginForm.vue'
import resetPassword from '@/Forms/resetPassword.vue'
import OauthSuccess from '@/pages/oauthSuccess.vue'
import registerForm from '@/Forms/registerForm.vue'
import homePage from '@/pages/homePage.vue'
import coursesPage from '@/pages/coursesPage.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    { path: '/', name: 'home', component: homePage },
    { path: '/login', name: 'login', component: loginForm },
    { path: '/reset_password', name: 'reset_password', component: resetPassword },
    { path: '/oauth-success', name: 'oauth-success', component: OauthSuccess },
    { path: '/create-account', name: 'create-account', component: registerForm },
    { path: '/courses', name: 'courses', component: coursesPage },
  ],
})

export default router
