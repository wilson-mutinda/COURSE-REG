<template>
    <!-- redirect toast -->
     <div v-if="showToast" class="fixed top-5 right-5 z-50 shadow-lg bg-green-500 rounded-md p-2 flex items-center justify-center gap-3">
        <button @click="returnToLogin" type="button">
            <img src="/close.png" alt="close" width="14px">
        </button>
        <h3 class="text-white font-semibold">Check email to reset password</h3>
     </div>

     <!-- login toast -->
      <div v-if="showLoginToast" class="bg-green-400 rounded-md fixed p-2 top-5 z-50 flex items-center justify-center gap-3 right-3">
        <button @click="returnToLogin" type="button">
            <img src="/close.png" alt="close" width="14px">
        </button>
        <h3 class="text-white font-semibold">Login Successful</h3>
      </div>

    <div class="form-template bg-gray-600 flex min-h-screen items-center justify-center p-2">
        <div class="login-form bg-white w-full max-w-md rounded-md p-4 relative">
            <form @submit.prevent="userLogin" action="">
                <!-- close button -->
                 <div class="">
                    <button @click="goToHome" type="button" class="absolute right-3">
                        <img src="/close.png" alt="close" width="14px">
                    </button>
                 </div>
                <p v-if="errors.general" class="text-sm text-red-500 text-center mb-3">{{ errors.general }}</p>
                <h3 class="text-red-400 text-center font-bold">Sign in with email</h3>
                <div class="">
                    <div class="">
                        <label class="block font-bold" for="email">Email</label>
                        <input @input="clearError('email')" v-model="email" class="ring-1 rounded-md p-1 outline-none hover:ring-red-400 w-full mt-3 mb-2" type="email" name="email" id="">
                        <p v-if="errors.email" class="text-sm text-red-500">{{ errors.email }}</p>
                    </div>
                    <div class="relative">
                        <label class="block font-bold" for="password">Password</label>
                        <input @input="clearError('password')" v-model="password" class="ring-1 rounded-md p-1 outline-none hover:ring-red-400 w-full mt-3" :type="viewPassword ? 'text' : 'password'" name="password" id="">
                        <button @click="showPassword" type="button" class="absolute right-3 top-11">
                            <img :src="viewPassword ? '/show.png' : '/hide.png'" alt="hide" width="14px">
                        </button>
                        <p v-if="errors.password" class="text-sm text-red-500">{{ errors.password }}</p>
                    </div>
                </div>
                <!-- forgot password -->
                 <div class="flex justify-end">
                    <button @click="showModal = true" type="button" class="mt-2 font-semibold">
                        <p>Forgot Password?</p>
                    </button>
                 </div>
                <!-- login button -->
                 <div class="">
                    <button class="w-full bg-black text-white mt-3 rounded-md p-2 font-semibold flex items-center justify-center gap-2">
                        <svg v-if="loading" class="animate-spin h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                            <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v8z"></path>
                        </svg>
                        <p>Get Started</p>
                    </button>
                 </div>
                 <!-- OR -->
                  <div class="flex items-center mt-3">
                    <div class="bg-gray-500 h-px flex-grow"></div>
                    <span class="px-4">OR</span>
                    <div class="bg-gray-500 h-px flex-grow"></div>
                  </div>
                 <!-- Google Signup -->
                  <div class="">
                    <button @click="googleAuth" class="flex items-center justify-center gap-6 ring-1 hover:ring-green-400 w-full mt-4 rounded-md p-2 mb-2">
                        <img src="/google.png" alt="google" width="18px" height="18px">
                        <h3>Continue with Google</h3>
                    </button>
                  </div>
                  <!-- signup -->
                   <div class="flex justify-end mt-3">
                    <p>Dont have an account? <a class="text-green-400 font-semibold" href="/create-account">Sign Up</a></p>
                   </div>
            </form>
        </div>
    </div>
    <!-- send_Email_modal -->
     <div v-if="showModal" class="fixed z-50 inset-0 bg-black bg-opacity-30 flex justify-center items-center">
        <div class="bg-white p-4 rounded-md shadow-lg w-full max-w-sm relative">
            <!-- close Modal -->
             <button @click="closeModal" type="button" class="absolute right-4">
                <img src="/close.png" alt="close" width="14px">
             </button>
             <p v-if="resetErrors.emailGeneral" class="text-sm text-red-500">{{ resetErrors.emailGeneral }}</p>
            <form @submit.prevent="resetPassword" action="">
                <p class="p-4 font-semibold text-center">Please enter email to reset password</p>
                <div class="">
                    <div class="mb-3">
                        <label class="block font-semibold mb-1" for="email">Email</label>
                        <input @input="clearEmailError('resetEmail')" v-model="resetEmail" class="rounded-md ring-1 w-full outline-none p-2" type="email" name="email" id="">
                        <p v-if="resetErrors.resetEmail" class="test-sm text-red-500">{{ resetErrors.resetEmail }}</p>
                    </div>
                    <div class="">
                        <button class="bg-blue-300 rounded-md p-2 text-white font-semibold w-full">
                            <p>Get New Password</p>
                        </button>
                    </div>
                </div>
            </form>
        </div>
     </div>
</template>

<script>
import api from '@/sevices/api';

export default{
    methods: {
        // googleAuth
        googleAuth(){
            window.location.href = 'http://localhost:3000/auth/google_oauth2'
        },

        // goToHome
        goToHome(){
            this.$router.push('/')
        },

        // clearResetEmail
        clearResetEmail() {
            this.resetEmail = ''
        },
        // returnToLogin
        returnToLogin(){
            this.showToast = false
            this.$router.push('/login')
        },
        // clearEmailError
        clearEmailError(field) {
            this.resetErrors[field] = ''
        },
        // resetPassword
        async resetPassword() {
            const payload = {
                email: this.resetEmail
            }
            try {
                const response = await api.post('send_reset_email', payload)
                const token = response.data.token
                localStorage.setItem('token', token)
                this.clearResetEmail();
                this.closeModal();

                this.showToast = true

                setTimeout(() => {
                    this.showToast = false
                }, 3000);

            } catch (error) {
                if (error.response && error.response.data && error.response.data.errors) {
                    this.resetErrors = error.response.data.errors
                } else {
                    this.resetErrors = { emailGeneral: "Something went wrong! Please retry"}
                }
            }
        },
        // closeModal
        closeModal(){
            this.showModal = false
        },
        // showPassword
        showPassword() {
            this.viewPassword = !this.viewPassword
        },
        // clearError
        clearError(field) {
            this.errors[field] = ''
        },
        // clearForm
        clearForm() {
            this.email = '';
            this.password = ''
        },

        // user_login
        async userLogin(){
            this.loading = true
            this.errors = {}
            const payload = {
                email: this.email,
                password: this.password
            }
            try {
                const response = await api.post('user_login', payload)
                this.clearForm();
                this.errors = {};
                this.showLoginToast = true;

                setTimeout(() => {
                    this.showLoginToast = false
                    this.$router.push('/dashboard')
                }, 3000);
            } catch (error) {
                if (error.response && error.response.data && error.response.data.errors) {
                    this.errors = error.response.data.errors
                } else {
                    this.errors = { general: "Ooops! Something went wrong!"}
                }
            } finally {
                setTimeout(() => {
                    this.loading = false
                }, 5000)
            }
        }
    },

    data() {
        return{
            email: '',
            password: '',

            errors: {},

            viewPassword: false,

            showModal: false,

            resetEmail: '',

            resetErrors: {},

            showToast: false,

            showLoginToast: false,

            loading: false
        }
    }
}
</script>
