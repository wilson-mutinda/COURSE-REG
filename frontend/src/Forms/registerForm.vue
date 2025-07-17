<template>
    <div class="form-template bg-gray-500 p-2 min-h-screen flex items-center justify-center">
        <div class="register-form bg-white rounded-md p-6 shadow-md w-full max-w-md">
            <form @submit.prevent="createAccount" action="">
                <h3 class="font-semibold text-center mb-3">Create Account</h3>
                <div class="">
                    <div class="flex gap-3">
                        <div class="">
                            <label for="first_name">Firstname</label>
                            <input @input="clearError('first_name')" v-model="first_name" class="ring-1 hover:ring-green-400 outline-none p-2 rounded-md w-full" type="text" name="first_name" id="">
                            <p v-if="errors.first_name" class="text-red-500 text-sm">{{ errors.first_name }}</p>
                        </div>
                        <div class="">
                            <label for="last_name">Lastname</label>
                            <input @input="clearError('last_name')" v-model="last_name" class="ring-1 hover:ring-green-400 outline-none p-2 rounded-md w-full" type="text" name="last_name" id="">
                            <p v-if="errors.last_name" class="text-red-500 text-sm">{{ errors.last_name }}</p>
                        </div>
                    </div>
                    <div class="flex gap-3 mt-3">
                        <div class="">
                            <label for="email">Email</label>
                            <input @input="clearError('email')" v-model="email" class="ring-1 hover:ring-green-400 outline-none p-2 rounded-md w-full" type="email" name="email" id="">
                            <p v-if="errors.email" class="text-red-500 text-sm">{{ errors.email }}</p>
                        </div>
                        <div class="">
                            <label for="phone">Phone</label>
                            <input @input="clearError('phone')" v-model="phone" class="ring-1 hover:ring-green-400 outline-none p-2 rounded-md w-full" type="tel" name="phone" id="">
                            <p v-if="errors.phone" class="text-red-500 text-sm">{{ errors.phone }}</p>
                        </div>
                    </div>
                    <div class="flex gap-3 mt-3">
                        <div class="relative">
                            <label for="password">Password</label>
                            <input @input="clearError('password')" v-model="password" class="ring-1 hover:ring-green-400 outline-none p-2 rounded-md w-full" :type="showPassword ? 'text' : 'password'" name="password" id="">
                            <button type="button" @click="viewPassword" class="absolute right-3 top-9">
                                <img :src="showPassword ? '/hide.png' : '/show.png'" alt="hide" width="18px">
                            </button>
                            <p v-if="errors.password" class="text-red-500 text-sm">{{ errors.password }}</p>
                        </div>
                        <div class="relative">
                            <label for="password_confirmation">PasswordConfirmation</label>
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
    methods: {
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
            const payload = {
                user: {
                    email: this.email,
                    phone: this.phone,
                    password: this.password,
                    password_confirmation: this.password_confirmation
                },
                student: {
                    first_name: this.first_name,
                    last_name: this.last_name
                }
            };
            try {
                const response = await api.post('create_student', payload)
                alert('Student Created!')
                this.$router.push('/login')
                this.clearForm()
            } catch (error) {
                if (error.response && error.response.data && error.response.data.errors) {
                    this.errors = error.response.data.errors
                } else {
                    this.errors = { general: "Oops!Something went wrong!"}
                }
            }
        }
    },


    data() {
        return {
            first_name: '',
            last_name: '',
            email: '',
            phone: '',
            password: '',
            password_confirmation: '',

            errors: {},

            showPassword: false
        }
    }
}
</script>
