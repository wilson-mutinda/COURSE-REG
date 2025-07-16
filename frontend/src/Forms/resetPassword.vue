<template>
    <div class="reset-form bg-gray-600 min-h-screen flex justify-center items-center">
        <div class="bg-white rounded-md p-4 w-full max-w-md relative">
            <p v-if="errors.general" class="text-sm text-red-500 text-center">{{ errors.general }}</p>
            <form @submit.prevent="resetEmail" action="">
                <button @click="redirectToLogin" type="button" class="absolute right-4">
                    <img src="/close.png" alt="close" width="14px">
                </button>
                <h3 class="font-semibold text-center mt-3">Enter new password below:</h3>
                <div class="">
                    <div class="">
                        <label class="block font-semibold mt-2" for="password">Password</label>
                        <input v-model="password" class="ring-1 w-full rounded-md p-2 outline-none mt-2 hover:ring-green-400 mb-2" type="password" name="password" id="">
                        <p v-if="errors.password" class="text-sm text-red-500">{{ errors.password }}</p>
                    </div>
                    <div class="">
                        <label class="block font-semibold mt-2" for="password_confirmation">Password Confirmation</label>
                        <input v-model="password_confirmation" class="ring-1 w-full rounded-md p-2 outline-none mt-2 hover:ring-green-400 mb-2"  type="password" name="password" id="">
                        <p v-if="errors.password_confirmation" class="text-sm text-red-500">{{ errors.password_confirmation }}</p>
                    </div>

                    <div class="">
                        <button type="submit" class="rounded-md ring-1 w-full bg-blue-300 text-white p-2 font-semibold mt-2">
                            <h3>Reset Password</h3>
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</template>

<script>
import api from '@/sevices/api';

export default {
    created() {
        const tokenFromUrl = new URLSearchParams(window.location.search).get('token');
        if (tokenFromUrl) {
            this.token = tokenFromUrl;
        }
    },

    methods: {
        // redirectToLogin
        redirectToLogin(){
            this.$router.push('/login')
        },
        // resetEmail
        async resetEmail() {
            const payload = {
                token: this.token,
                password: this.password,
                password_confirmation: this.password_confirmation
            }
            try {
                const response = await api.post('reset_email', payload)
                alert('Password Reset Successfully')
                localStorage.removeItem('token')
                this.$router.push('/login')
            } catch (error) {
                if (error.response && error.response.data && error.response.data.errors) {
                    this.errors = error.response.data.errors
                } else {
                    this.errors = { general: "Ooops!Something went wrong!"}
                }
            }
        }
    },
    data(){
        return {
            password: '',
            password_confirmation: '',
            token: '',
            errors: {}
        }
    }
}
</script>
