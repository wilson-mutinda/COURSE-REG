<template>
    <div class="bg-gray-200 min-h-screen flex justify-center p-8">
        <div class="bg-white w-full flex flex-col space-y-4">
            <p class="text-4xl font-semibold text-green-800 mt-8 text-center">{{courseName}}</p>
            <h3 class="text-purple-800 text-center text-lg">You have successfully appied for {{ courseName }} Course. Keep on checking the email for more info.</h3>
            <div class="flex justify-center">
                <button type="button" @click="goToLogin" class="bg-green-500 rounded-md px-4 py-2 text-white text-lg">Login</button>
            </div>
        </div>
    </div>
</template>

<script>
export default {
    data() {
        return {
            courseName: ''
        }
    },
    mounted() {
        this.courseName = localStorage.getItem('course_name')
    },
    methods: {
        // goToLogin
        goToLogin(){
            this.$router.push('/login')
        }
    }
}
</script>
