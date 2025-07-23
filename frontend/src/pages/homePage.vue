<template>
    <!-- AllCourse Toast
     <div class="bg-white">
        <button @click="goToCourses" type="button" class="hover:text-green-400 text-lg">
            Courses
        </button>
     </div> -->
    <div class="bg-gray-100 min-h-screen p-2">
        <!-- header -->
         <div class="header bg-green-100 p-2 rounded-md">
            <div class="mx-auto w-fit">
                <div class="flex items-center gap-4 ring-1 rounded-md p-6">
                    <!-- logo -->
                    <div class="logo flex gap-2">
                        <img src="/book.png" alt="book" width="20px">
                        <p class="font-semibold text-lg">E<span class="text-green-400">Learn</span></p>
                    </div>
                    <!-- buttons -->
                    <div class="flex gap-6 px-3">
                        <!-- home -->
                        <button class="text-lg hover:text-green-400 text-green-400">Home</button>
                        <!-- all courses with hover toast -->
                        <div class="relative" @mouseenter="handleMouseEnter" @mouseleave="handleMouseLeave">
                            <button class="text-lg hover:text-green-400">All Courses</button>
                            <div v-if="showCourses" class="absolute bg-white top-full left-0 mt-2 ring-1 shadow-lg ring-gray-300 rounded-md p-4 z-50 w-60">
                                <p class="text-gray-700 font-semibold mb-2">All Courses</p>
                                <ul class="text-sm space-y-2">
                                    <li class="text-lg hover:text-green-400"><a href="/courses">Courses</a></li>
                                </ul>
                            </div>
                        </div>
                        <!-- <button class="text-lg hover:text-green-400">All Courses</button> -->
                        <!-- pages -->
                        <button class="text-lg hover:text-green-400">Pages</button>
                        <!-- contact -->
                        <button class="text-lg hover:text-green-400">Contact</button>
                    </div>
                    <!-- sign-in and sign-up -->
                    <div class="flex gap-4 px-4">
                        <button type="button" @click="goToLogin" class="text-black hover:text-green-400 text-lg">Sign In</button>
                        <button type="button" @click="goToRegister" class="ring-1 p-2 rounded-md ring-green-400 text-lg hover:text-white hover:bg-green-400">Sign Up</button>
                    </div>
                </div>
                <!-- About -->
                <div class="flex items-center w-full max-w-96 mt-20">
                    <div class="left mt-8 mb-28">
                        <p class="text-green-400 text-lg mb-8">Start your favourite course</p>
                        <div class="mt-3 mb-5">
                            <h3 class="text-3xl">Now learning from anywhere, and <br> build your <span class="text-green-400">bright</span> <br> <span class="text-green-400">career.</span></h3>
                        </div>
                        <h3 class="text-gray-600 mb-8 mt-6">It has survived not only five centuries but also the leap into electronic typesetting.</h3>
                        <div class="button">
                            <button @click="goToCourses" type="button" class="text-white bg-green-400 rounded-md px-4 py-2 hover:bg-gray-900">Start A Course</button>
                        </div>
                    </div>
                    <div class="right">r</div>
                </div>
            </div>
         </div>
         <!-- footer -->
          <div class="footer"></div>
    </div>
</template>

<script>
export default {
    data(){
        return{
            showCourses: false,
            hideTimeout: null
        }
    },
    methods: {
        // delay hide
        handleMouseEnter(){
            clearTimeout(this.hideTimeout);
            this.showCourses = true;
        },
        handleMouseLeave(){
            this.hideTimeout = setTimeout(() => {
                this.showCourses = false;
            }, 100)
        },

        // goToCourses
        goToCourses(){
            this.$router.push('/courses')
        },
        // goToLogin
        goToLogin(){
            this.$router.push('/login')
        },

        // goToRegister
        goToRegister(){
            this.$router.push('/create-account')
        }
    }
}
</script>
