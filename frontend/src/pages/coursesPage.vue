<template>
    <div class="course-page bg-gray-300 min-h-screen">
        <!-- header -->
         <div class="bg-white p-5 flex items-center justify-between fixed top-0 left-0 right-0 z-50 shadow-md">
            <!-- logo -->
             <div class="flex gap-3">
                <img src="/book.png" alt="book" width="20px" height="20px">
                <p class="text-2xl">E<span class="text-green-400">Learn</span></p>
             </div>
             <!-- buttons -->
              <div class="flex gap-7 text-xl">
                <!-- programmes -->
                 <div class="relative">
                    <button
                     @mouseenter="onMouseEnter" 
                     @mouseleave="onMouseLeave" 
                     class="hover:text-green-400 underline decoration-transparent hover:decoration-green-400 flex gap-2">
                        Courses
                        <img src="/down-chevron.png" alt="down-chevron" width="12px" height="12px" :class="['transition-transform duration-700', showToast ? 'rotate-180' : 'rotate-0']"></button>
                    <div v-if="showToast" class="bg-white rounded-md ring-1 p-4 ring-gray-400 mt-4 absolute w-60" @mouseenter="cancelHide" @mouseleave="onMouseLeave">
                        <p class="mb-2 underline decoration-green-400 hover:decoration-transparent text-sm">View All Courses</p>
                        <ul class="space-y-2">
                            <!-- data -->
                            <a href="#"><li class="flex items-center justify-between mt-3 relative"
                                 @mouseenter="onMouseEnterData" 
                                 @mouseleave="onMouseLeaveData">

                                <button class="hover:text-green-400 text-sm">
                                    Data
                                </button>

                                <img src="/right.png" alt="right" width="14px">
                                
                                <!-- data sub-menu -->
                                <div
                                 v-if="showDataToast" 
                                 class="bg-gray-200 flex flex-col p-4 rounded-md absolute left-full w-56 top-0 space-y-2 ml-2 z-50">
                                    <a href="#" class="text-sm">Data Analytics</a>
                                    <a href="#" class="text-sm">Data Science</a>
                                    <a href="#" class="text-sm">Data Engineering</a>
                                </div>
                            </li></a>
                            <!-- carrear -->
                             <a href="#"><li class="flex items-center justify-between mt-3 relative"
                                 @mouseenter="onMouseEnterCareer" 
                                 @mouseleave="onMouseLeaveCareer">

                                <button class="text-sm hover:text-green-400">
                                    Career
                                </button>
                                <img src="/right.png" alt="right" width="14px">

                                <!-- career sub-menu -->
                                 <div v-if="showCareerToast" class="bg-gray-200 flex flex-col p-4 rounded-md absolute left-full w-64 top-0 space-y-2 ml-2 z-50">
                                    <a href="#" class="text-sm">AI Career Essentials</a>
                                    <a href="#" class="text-sm">Virtual Assistant</a>
                                    <a href="#" class="text-sm">Professional Foundations</a>
                                 </div>
                            </li></a>
                             <!-- creative-tech -->
                             <a href="#"><li class="flex items-center justify-between mt-3 relative" @mouseenter="onMouseEnterCreative" @mouseleave="onMouseLeaveCreative">
                                <button class="text-sm hover:text-green-400">
                                    Creative Tech
                                </button>
                                <img src="/right.png" alt="right" width="14px">

                                <!-- creative-tech sub-menu -->
                                <div v-if="showCreativeToast" class="absolute bg-gray-200 rounded-md p-4 flex flex-col left-full w-64 top-0 space-y-2 z-50 ml-2">
                                    <a href="#" class="text-sm">Content Creation</a>
                                    <a href="#" class="text-sm">Graphic Design</a>
                                </div>
                            </li></a>
                             <!-- cyber-security -->
                             <a href="#"><li class="flex items-center justify-between mt-3 relative" @mouseenter="onMouseEnterCyber" @mouseleave="onMouseLeaveCyber">
                                <button class="text-sm hover:text-green-400">
                                    Cyber Security
                                </button>
                                <img src="/right.png" alt="right" width="14px">

                                <!-- cyber-security sub-menu -->
                                 <div v-if="showCyberToast" class="absolute p-4 rounded-md bg-gray-200 flex flex-col left-full w-64 top-0 space-y-2 z-50 ml-2">
                                    <a href="#" class="text-sm">Cyber Security</a>
                                 </div>
                            </li></a>
                        </ul>
                    </div>
                 </div>
                 <!-- about -->
                  <button type="button" class="hover:text-green-400">About</button>
              </div>
              <!-- login button -->
               <div class="mr-8">
                <button type="button" @click="goToLogin" class="rounded-md p-2 ring-1 ring-green-400 text-green-400 hover:text-white hover:bg-green-400 text-xl">Login to Portal</button>
               </div>
         </div>
         <!-- body -->
          <div class="mt-20 ml-32">
            <!-- title -->
             <div class="">
                <p class="font-semibold text-3xl text-blue-900">Our Courses</p>
             </div>
             <!-- courses -->
              <div class="flex items-center mt-10 gap-4">
                <!-- left -->
                 <div class="w-[16%]">
                    <!-- all courses -->
                     <button class="bg-blue-700 text-white px-8 py-4 w-full">
                        Show All
                     </button>

                     <p class="mt-10 text-gray-700">Filter by</p>
                     <div class="bg-gray-400 mt-4 h-px"></div>
                     <!-- categories -->
                      <p class="mt-6 font-semibold text-2xl text-blue-950 mb-5">Category</p>
                      <div class="space-y-1">

                        <!-- career -->
                        <div class="bg-white hover:bg-gray-300 text-lg hover:text-blue-400 p-2 flex gap-2">
                            <input type="checkbox" id="career" value="career" v-model="selectedCategories">
                            <p>Career</p>
                        </div>

                        <!-- creative-tech -->
                         <div class="bg-white hover:bg-gray-300 text-lg hover:text-blue-400 p-2 flex gap-2">
                            <input type="checkbox" id="creative tech" value="creative tech" v-model="selectedCategories">
                            <p>Creative Tech</p>
                         </div>

                         <!-- Cyber-security -->
                          <div class="bg-white hover:bg-gray-300 text-lg hover:text-blue-400 p-2 flex gap-2">
                            <input type="checkbox" id="cyber security" value="cyber security" v-model="selectedCategories">
                            <p>Cyber Security</p>
                          </div>

                          <!-- data -->
                           <div class="bg-white hover:bg-gray-300 text-lg hover:text-blue-400 p-2 flex gap-2">
                            <input type="checkbox" id="data" value="data" v-model="selectedCategories">
                            <p>Data</p>
                           </div>

                      </div>
                 </div>
                 <!-- right -->
                  <div class="w-[84%]">
                    <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-4">
                        <div v-for="(course, index) in threeCourses" :key="index" class="rounded-md bg-white p-4 shadow-md text-lg text-blue-900">
                            <p class="ml-6 font-bold">{{ course.name }}</p>

                            <!-- duration -->
                             <div class="flex gap-4 mt-6 mb-6">
                                <img src="/hour.png" alt="hour" width="25px">
                                <p>{{ course.duration }}</p>
                             </div>

                            <!-- Apply now button -->
                            <div class="ml-6">
                                <button type="button" @click="goToRegister" class="bg-green-400 mt-6 px-6 py-2 text-black rounded-xl hover:bg-blue-900 hover:text-white">
                                    Apply Now
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- next-button -->
                     <div v-if="threeCourses.length < allCourses.length" class="mt-6 flex justify-center">
                        <button @click="showMoreCourses" class="px-6 py-2 bg-green-400 text-white rounded hover:bg-green-500 text-lg">
                            Show More
                        </button>
                     </div>
                  </div>
              </div>
          </div>
          <!-- footer -->
           <div class=""></div>
    </div>
</template>

<script>
import api from '@/sevices/api';

export default {

    mounted(){
        this.fetchAllCourses();
    },

    data(){
        return {
            allCourses: [],
            selectedCategories: [],

            showToast: false,
            hideTimeOutId: null,

            showDataToast: false,
            hideTimeOut: null,

            showCareerToast: false,

            showCreativeToast: false,
            
            showCyberToast: false,

            courseLimit: 3
        }
    },

    computed: {
        // filteredCourses
        filteredCourses(){
            if (this.selectedCategories.length === 0){
                return this.allCourses;
            }
            return this.allCourses.filter(course => 
                this.selectedCategories.includes(course.category.toLowerCase())
            );
        },

        threeCourses() {
            return this.filteredCourses.slice(0, this.courseLimit)
        }
    },

    methods: {

        // goToRegister
        goToRegister(){
            this.$router.push('/create-account')
        },

        // showMoreCourses
        showMoreCourses(){
            this.courseLimit += 3;
        },

        // fetchAllCourses
        async fetchAllCourses(){
            const response = await api.get('all_courses');
            this.allCourses = response.data
        },

        // onMouseEnterCyber
        onMouseEnterCyber() {
            clearTimeout(this.hideTimeOut);
            this.showCyberToast = true;
        },
        // onMouseLeaveCyber
        onMouseLeaveCyber(){
            this.hideTimeOut = setTimeout(() => {
                this.showCyberToast = false;
            }, 50);
        },

        // onMouseEnterCreative
        onMouseEnterCreative() {
            clearTimeout(this.hideTimeOut);
            this.showCreativeToast = true;
        },
        // onMouseLeaveCreative
        onMouseLeaveCreative() {
            this.hideTimeOut = setTimeout(() => {
                this.showCreativeToast = false;
            }, 50);
        },

        // onMouseEnterCareer
        onMouseEnterCareer(){
            clearTimeout(this.hideTimeOut);
            this.showCareerToast = true;
        },
        // onMouseLeaveCareer
        onMouseLeaveCareer(){
            this.hideTimeOut = setTimeout(() => {
                this.showCareerToast = false
            }, 50);
        },

        // omMouseEnterData
        onMouseEnterData(){
            clearTimeout(this.hideTimeOut);
            this.showDataToast = true;
        },
        // onMouseLeaveData
        onMouseLeaveData(){
            this.hideTimeOut = setTimeout(() => {
                this.showDataToast = false;
            }, 50);
        },
        // goToLogin
        goToLogin(){
            this.$router.push('/login')
        },

        // onMouseEnter
        onMouseEnter() {
            clearTimeout(this.hideTimeOutId); 
            this.showToast = true;
        },

        // onMouseLeave
        onMouseLeave() {
            this.hideTimeOutId = setTimeout(() => {
                this.showToast = false;
            }, 50)
        },

        // cancelHide
        cancelHide(){
            clearTimeout(this.hideTimeOutId);
        }
    }
}
</script>
