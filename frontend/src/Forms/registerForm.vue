<template>
    <div class="form-template bg-gray-500 p-2 min-h-screen flex items-center justify-center">
        <div class="register-form bg-white rounded-md p-6 shadow-md w-full max-w-md relative">
            <form @submit.prevent="createAccount" action="">
                <!-- close button -->
                 <div class="absolute right-3 top-3">
                    <button @click="goToHome" type="button" class="">
                        <img src="/close.png" alt="close" width="14px">
                    </button>
                 </div>
                <h3 class="font-semibold text-center mb-3">Create Account</h3>
                <div class="">
                    <div class="flex gap-3">
                        <div class="">
                            <label class="font-semibold" for="first_name">Firstname</label>
                            <input @input="clearError('first_name')" v-model="first_name" class="ring-1 hover:ring-green-400 outline-none p-2 rounded-md w-full" type="text" name="first_name" id="">
                            <p v-if="errors.first_name" class="text-red-500 text-sm">{{ errors.first_name }}</p>
                        </div>
                        <div class="">
                            <label class="font-semibold" for="last_name">Lastname</label>
                            <input @input="clearError('last_name')" v-model="last_name" class="ring-1 hover:ring-green-400 outline-none p-2 rounded-md w-full" type="text" name="last_name" id="">
                            <p v-if="errors.last_name" class="text-red-500 text-sm">{{ errors.last_name }}</p>
                        </div>
                    </div>
                    <div class="flex gap-3 mt-3">
                        <div class="">
                            <label class="font-semibold" for="email">Email</label>
                            <input @input="clearError('email')" v-model="email" class="ring-1 hover:ring-green-400 outline-none p-2 rounded-md w-full" type="email" name="email" id="">
                            <p v-if="errors.email" class="text-red-500 text-sm">{{ errors.email }}</p>
                        </div>
                        <div class="">
                            <label class="font-semibold" for="phone">Phone</label>
                            <input @input="clearError('phone')" v-model="phone" class="ring-1 hover:ring-green-400 outline-none p-2 rounded-md w-full" type="tel" name="phone" placeholder="254712345678" id="">
                            <p v-if="errors.phone" class="text-red-500 text-sm">{{ errors.phone }}</p>
                        </div>
                    </div>
                    <div class="flex gap-3 mt-3">
                        <div class="relative">
                            <label class="font-semibold" for="password">Password</label>
                            <input @input="clearError('password')" v-model="password" class="ring-1 hover:ring-green-400 outline-none p-2 rounded-md w-full" :type="showPassword ? 'text' : 'password'" name="password" id="">
                            <button type="button" @click="viewPassword" class="absolute right-3 top-9">
                                <img :src="showPassword ? '/hide.png' : '/show.png'" alt="hide" width="18px">
                            </button>
                            <p v-if="errors.password" class="text-red-500 text-sm">{{ errors.password }}</p>
                        </div>
                        <div class="relative">
                            <label class="font-semibold" for="password_confirmation">PasswordConfirmation</label>
                            <input @input="clearError('password_confirmation')" v-model="password_confirmation" class="ring-1 hover:ring-green-400 outline-none p-2 rounded-md w-full" :type="showPassword ?'text' : 'password'" name="password" id="">
                            <button type="button" @click="viewPassword" class="absolute right-3 top-9">
                                <img :src="showPassword ? '/hide.png' : '/show.png'" alt="hide" width="18px">
                            </button>
                            <p v-if="errors.password_confirmation" class="text-red-500 text-sm">{{ errors.password_confirmation }}</p>
                        </div>
                    </div>
                    <!-- create_account -->
                     <div class="">
                        <button class="bg-blue-400 rounded-md p-2 w-full text-white mt-3 font-semibold hover:bg-blue-300">
                            <p>Create account</p>
                        </button>
                     </div>
                     <!-- login -->
                      <div class="flex justify-end mt-3">
                        <p>Already have an account? <a class="text-green-400 font-semibold" href="/login">Login</a></p>
                      </div>
                </div>
            </form>
        </div>
    </div>
</template>

<script>
import api from '@/sevices/api';

export default {

    data() {
        return {
            first_name: '',
            last_name: '',
            email: '',
            phone: '',
            password: '',
            password_confirmation: '',

            errors: {},

            courseId: '',

            showPassword: false
        }
    },

    mounted(){
        const CourseId = localStorage.getItem('course_id')
        if (!CourseId) {
            this.$router.push('/')
        }
    },
    methods: {
        // goToHome
        goToHome(){
            this.$router.push('/')
        },
        // viewPassword
        viewPassword(){
            this.showPassword = !this.showPassword
        },
        // clearForm
        clearForm(){
            this.first_name = '',
            this.last_name = '',
            this.email = '',
            this.phone = '',
            this.password = '',
            this.password_confirmation = ''
        },
        // clearError
        clearError(field){
            this.errors[field] = ''
        },

        // createAccount
        async createAccount() {
            this.errors = {}
            const courseId = localStorage.getItem('course_id')
            if (!courseId) {
                throw new Error('Please select a course first');
            }
            
            const payload = {
                user: {
                    email: this.email,
                    phone: this.phone,
                    password: this.password,
                    password_confirmation: this.password_confirmation
                },
                student: {
                    first_name: this.first_name,
                    last_name: this.last_name,
                    course_id: courseId
                }
            };
            try {
                const response = await api.post('create_student', payload)
                this.clearForm();
                this.$router.push('/student/info')

                const first_name = response.data.first_name
                const last_name = response.data.last_name
                const phone = response.data.phone
                const user_id = response.data.user_id

                // store in localStorage
                localStorage.setItem('first_name', first_name);
                localStorage.setItem('last_name', last_name);
                localStorage.setItem('phone', phone);
                localStorage.setItem('user_id', user_id);

            } catch (error) {
                if (error.response && error.response.data && error.response.data.errors) {
                    this.errors = error.response.data.errors
                } else {
                    this.errors = { general: "Oops!Something went wrong!"}
                }
            } finally {
                localStorage.removeItem('course_id')
            }
        }
    },

}
</script>
