<template>
    <div class="bg-gray-200 min-h-screen flex justify-center p-8">
        <div class="bg-white w-full flex flex-col space-y-4">
            <p class="text-4xl font-semibold text-green-800 mt-8 text-center">{{courseName}}</p>
            <h3 class="text-purple-800 text-center text-lg">You have successfully appied for {{ courseName }} course, costing {{ coursePrice }}. Login for more info.</h3>
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
            courseName: '',
            userId: '',
            coursePrice: ''
        }
    },
    mounted() {
        this.userId = localStorage.getItem('user_id')
        if (!this.userId) {
            this.$router.push('/student/info')
        }
        this.courseName = localStorage.getItem('course_name')
        this.coursePrice = localStorage.getItem('course_price')
    },
    methods: {
        // goToLogin
        goToLogin(){
            this.$router.push('/login');
            localStorage.removeItem('user_id');
        }
    }
}
</script>
