<template>
    <div class="bg-gray-200 min-h-screen">
        <div class="flex items-center w-full flex-col p-1 gap-4 md:flex-row">
            <!-- left -->
             <div class="left md:w-[20%] lg:w-[15%] bg-white min-h-screen rounded-md">
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
              <div class="right md:w-[80%] lg:w-[85%] bg-gray-200 min-h-screen rounded-md relative">
                <!-- Navbar -->
                 <div class="fixed top-0 right-0 md:w-[80%] lg:w-[85%] bg-white p-4 shadow-md z-50 rounded-md mt-2">
                    <div class="flex items-center justify-between px-6">
                        <div class="">
                            <p class="text-lg font-semibold">Home</p>
                        </div>
                        <div class="flex gap-2">
                            <img src="/user.png" alt="/avatar" width="30px">
                            <p class="text-gray-600 font-bold text-xl">{{ flag.charAt(0).toUpperCase() + flag.slice(1) }}</p>
                            <button>
                                <img src="/arrow-down.png" alt="arrow-down" width="20px"></img>
                            </button>
                        </div>
                    </div>
                 </div>
                 <!-- body -->
                  <div class="">
                    <p>{{ courseName }}</p>
                  </div>
              </div>
        </div>
    </div>
</template>

<script>
export default {

    data() {
        return {
            flag: '',
            courseName: ''
        }
    },

    mounted() {
        this.flag = localStorage.getItem('flag');
        this.courseName = localStorage.getItem('course_name');
    }

}
</script>
