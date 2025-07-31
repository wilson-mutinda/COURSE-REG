import { createRouter, createWebHistory } from 'vue-router'
import loginForm from '@/Forms/loginForm.vue'
import resetPassword from '@/Forms/resetPassword.vue'
import OauthSuccess from '@/pages/oauthSuccess.vue'
import registerForm from '@/Forms/registerForm.vue'
import homePage from '@/pages/homePage.vue'
import coursesPage from '@/pages/coursesPage.vue'
import adminDashboard from '@/pages/adminDashboard.vue'
import studentDashboard from '@/pages/studentDashboard.vue'
import adminStudentPage from '@/pages/adminStudentPage.vue'
import studentInfoPage from '@/pages/studentInfoPage.vue'
import courseRegPage from '@/pages/courseRegPage.vue'
import adminCoursePage from '@/pages/adminCoursePage.vue'
import { getUserRole } from '@/sevices/auth'
const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    { path: '/', name: 'home', component: homePage },
    { path: '/login', name: 'login', component: loginForm },
    { path: '/reset_password', name: 'reset_password', component: resetPassword },
    { path: '/oauth-success', name: 'oauth-success', component: OauthSuccess },
    { path: '/create-account', name: 'create-account', component: registerForm },
    { path: '/courses', name: 'courses', component: coursesPage },
    { path: '/admin-dashboard', name: 'admin-dashboard', component: adminDashboard },
    { path: '/student-dashboard', name: 'student-dashboard', component: studentDashboard },
    { path: '/admin-dashboard/students', name: 'admin-dashboard-students', component: adminStudentPage },
    { path: '/student/info', name: 'student-info', component: studentInfoPage },
    { path: '/student/course-reg', name: 'student/course-reg', component: courseRegPage },
    { path: '/admin-dashboard/courses', name: 'admin-dashboard-courses', component: adminCoursePage },
  ],
});

router.beforeEach((to) => {
  const isAuthenticated = localStorage.getItem('access_token')

  const publicRoutes = ['/login', '/reset_password', 'create-account'];
  if (!isAuthenticated) return '/login'

  if (publicRoutes.includes(to.path)) return true

  const userRole = getUserRole();
  
  if (to.path.startsWith('/student') && userRole !== 'student') {
    return `${userRole}-dashboard`;
  }

  if (to.path.startsWith('/admin') && userRole !== 'admin') {
    return `${userRole}-dashboard`;
  }

  return true
})

export default router
