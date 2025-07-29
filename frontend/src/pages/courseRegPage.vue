<template>
    <div class="bg-gray-200 min-h-screen flex justify-center p-8">
        <div class="bg-white w-full flex flex-col space-y-4">
            <p class="text-4xl font-semibold text-green-800 mt-8 text-center">{{courseName}}</p>
            <h3 class="text-purple-800 text-center text-lg">You have successfully appied for {{ courseName }} Course. Keep on checking the email for more info.</h3>
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
    }
}
</script>
