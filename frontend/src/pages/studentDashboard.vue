<template>
    <div class="bg-gray-200 min-h-screen">
        <div class="flex w-full flex-col p-1 gap-4 md:flex-row">
            <!-- left -->
             <div class="left md:w-[20%] lg:w-[15%] bg-white md:min-h-screen rounded-md">
                <!-- logo -->
                 <div class="flex gap-2 p-2 items-center">
                    <img src="/book.png" alt="book" width="40px">
                    <p class="text-4xl">E<span class="text-green-400">Learn</span></p>
                 </div>

                 <!-- other buttons -->
                  <div class="flex flex-col space-y-3 mt-3 p-2">
                    <button class="flex items-center gap-2 bg-green-200 rounded-md p-2 hover:bg-purple-100">
                        <img src="/home.png" alt="home" width="30px">
                        <p class="text-2xl">Home</p>
                    </button>
                    <button class="flex items-center gap-2 rounded-md p-2 hover:bg-purple-100">
                        <img src="/learning.png" alt="learning" width="30px">
                        <p class="text-2xl">Content</p>
                    </button>
                  </div>
             </div>
             <!-- right --> 
              <div class="right md:w-[80%] lg:w-[85%] bg-gray-200 md:min-h-screen rounded-md relative">
                <!-- Navbar -->
                 <div class="md:w-[80%] lg:w-[85%] bg-white p-4 shadow-md rounded-md mt-2">
                    <div class="flex items-center justify-between px-6">
                        <div class="">
                            <p class="text-lg font-semibold">Home</p>
                        </div>
                        <div class="flex items-center justify-between gap-4">
                            <div class="flex gap-2 relative">
                                <img src="/user.png" alt="/avatar" width="30px">
                                <p class="text-gray-600 font-bold text-xl">{{ flag.charAt(0).toUpperCase() + flag.slice(1) }}</p>
                                <button @click="openModalButton" type="button">
                                    <img src="/arrow-down.png" class="transition-transform duration-300" :class="{ 'rotate-180' : openStudentModal, 'rotate-0': !openStudentModal}" alt="arrow-down" width="20px"></img>
                                </button>
                                <div v-if="openStudentModal" class="absolute rounded-md bg-white top-10 p-4">
                                    <p class="text-center text-xl">My Info</p>
                                    <div class="">
                                        <p class="text-xl">Email: <span class="text-lg text-gray-500">{{ email }}</span></p>
                                        <p class="text-xl">Phone: <span class="text-lg text-gray-500">{{ phone }}</span></p>
                                    </div>
                                </div>
                            </div>
                            <div class="">
                                <button @click="logout" type="button" class="rounded-md bg-purple-500 px-4 py-2 text-white">Logout</button>
                            </div>
                        </div>
                    </div>
                    
                 </div>
                 <!-- body -->
                  <div class="flex">
                    <div class="bg-white rounded-md shadow-sm mt-4 p-4">
                        <p class="text-xl font-semibold text-center">Course Info</p>
                        <div class="flex items-center gap-2 mt-4">
                            <p class="font-bold text-lg">Course Name:</p>
                            <p class="text-lg text-gray-600">{{ courseName }}</p>
                        </div>
                        <div class="flex items-center gap-2 mt-4">
                            <p class="font-bold text-lg">Cost:</p>
                            <p class="text-lg text-gray-600"><span>Ksh.</span> {{ coursePrice }}</p>
                        </div>
                        <div class="flex items-center gap-2 mt-4">
                            <p class="font-bold text-lg">Duration:</p>
                            <p class="text-lg text-gray-600">{{ courseDuration }}</p>
                        </div>
                        <div class="flex items-center gap-2 mt-4">
                            <p class="font-bold text-lg">Code:</p>
                            <p class="text-lg text-gray-600">{{ studentCode }}</p>
                        </div>
                        <div class="">
                            <button @click="makePayment" type="button" class="rounded-md bg-green-700 text-white px-4 py-2 mt-2 mb-2">Click to pay ksh. {{ coursePrice }}</button>
                        </div>
                    </div>
                  </div>
              </div>
        </div>
    </div>
</template>

<script>
import api from '@/sevices/api';

export default {

    methods: {

        // makePayment
        async makePayment(){
            const payload = {
                course_name: this.courseName,
                cost: this.coursePrice,
                user_phone: this.phone
            };
            try {
                const response = await api.post('create_payment', payload)
                alert("Response Sent!")
            } catch (error) {
                if (error.response && error.response.data && error.response.data.errors) {
                    this.errors = error.response.data.errors
                } else {
                    this.errors = { general: "Something went wrong!"}
                }
            }
        },

        clearItems(){
            this.coursePrice = '';
            this.courseName = '';
            this.courseDuration = '';
            this.studentCode = '';
        },

        openModalButton(){
            this.openStudentModal = !this.openStudentModal
        },

        logout(){
            localStorage.removeItem('access_token');
            localStorage.removeItem('refresh_token');

            this.clearItems();            
            this.$router.push('/');

        },
        
    },

    data() {
        return {
            flag: '',
            courseName: '',
            coursePrice: '',
            openStudentModal: false,
            courseDuration: '',

            email: '',
            phone: '',
            studentCode: '',

            errors: {}
        }
    },

    mounted() {
        // this.getUserInfo();
        this.flag = localStorage.getItem('flag');
        this.courseName = localStorage.getItem('course_name')
        this.coursePrice = localStorage.getItem('course_price');
        this.courseDuration = localStorage.getItem('course_period');
        this.studentCode = localStorage.getItem('student_code');

        this.email = localStorage.getItem('email')
        this.phone = localStorage.getItem('phone')
    }

}
</script>
