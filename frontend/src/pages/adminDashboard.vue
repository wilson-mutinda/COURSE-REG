<template>
    <div class="min-h-screen bg-gray-100">
        <div class="flex items-center w-full flex-col md:flex-row gap-4 p-1">
            <!-- left -->
            <div class="left md:w-[20%] lg:w-[15%] bg-white min-h-screen rounded-md">
                <!-- logo -->
                 <div class="flex items-center gap-2 p-2">
                    <img src="/book.png" alt="book" width="40px">
                    <p class="text-4xl">E<span class="text-green-400">Learn</span></p>
                 </div>

                 <!-- other buttons -->
                  <div class="flex flex-col space-y-3 mt-3 p-2">
                    <button class="flex items-center gap-2 bg-green-200 rounded-md p-2 hover:bg-purple-100">
                        <img src="/home.png" alt="home" width="30px">
                        <p class="text-2xl">Dashboard</p>
                    </button>
                    <button class="flex items-center gap-2 rounded-md p-2 hover:bg-purple-100">
                        <img src="/learning.png" alt="learning" width="30px">
                        <p class="text-2xl">Courses</p>
                    </button>
                    <button class="flex items-center gap-2 rounded-md p-2 hover:bg-purple-100">
                        <img src="/academic.png" alt="academic" width="30px">
                        <p class="text-2xl">Students</p>
                    </button>
                  </div>
            </div>
            <!-- right -->
            <div class="right md:w-[80%] lg:w-[85%] bg-gray-100 min-h-screen rounded-md">
                <!-- navbar -->
                 <div class="flex justify-between items-center p-4">
                    <!-- title -->
                    <div class="">
                        <p class="text-2xl font-bold">Dashboard</p>
                        <!-- <p> courses:{{ courseCount }}</p>
                        <p>students:{{ studentCount }}</p> -->
                    </div>
                    <!-- search, ntifications and -->
                     <div class="flex items-center gap-4">
                        <!-- search bar -->
                         <div class=" flex rounded-full ring-1 bg-transparent gap-2 ring-green-300 p-2 hover:ring-red-300 bg-white">
                            <img src="/search.png" alt="search" width="20px" height="20px">
                            <input type="text" name="" id="" class="outline-none text-lg bg-transparent" placeholder="Search...">
                         </div>

                         <!-- notification -->
                          <div class="bg-white p-3 rounded-full">
                            <img src="/notification.png" alt="notification" width="30px">
                          </div>
                          
                          <!-- other -->
                           <div class="flex items-center gap-4 p-3 bg-white rounded-md">
                            <img src="/user.png" alt="avatar" width="30px">
                            <p>John Doe</p>
                            <button>
                                <img src="/down-arrow.png" alt="down-arrow" width="12px">
                            </button>
                           </div>
                     </div>
                 </div>

                 <!-- body -->
                  <div class="">
                    <!-- top -->
                     <div class="flex gap-10">
                        <!-- all students -->
                         <div class="flex items-center bg-white p-6 rounded-md">
                            <img src="/academic.png" alt="learning" width="40px" class="bg-purple-200 rounded-full p-1 mr-2">
                            <div class="">
                                <p class="font-semibold">Total Students</p>
                                <span class="font-bold">{{ studentCount }}</span>
                            </div>
                         </div>
                         <!-- all courses -->
                          <div class="flex items-center bg-white p-6 rounded-md">
                            <img src="/learning.png" alt="academic" width="40px" class="bg-purple-200 rounded-full p-1 mr-2">
                            <div class="">
                                <p class="font-semibold">Total Courses</p>
                                <span class="font-bold">{{ courseCount }}</span>
                            </div>
                          </div>
                     </div>
                  </div>
            </div>
        </div>
    </div>
</template>

<script>
import api from '@/sevices/api';

export default{

    data(){
        return {
            courseCount: 0,

            studentCount: 0,
        };
    },

    methods: {

        // fetch all students
        async fetchAllStudents(){
            try {
                const response = await api.get('all_students')
                this.studentCount = response.data.length
            } catch (error) {
                console.error('Failed to fetch students', error);
            }
        },

        // Fetch all courses
        async fetchAllCourses(){
            try {
                const response = await api.get('all_courses');
                this.courseCount = response.data.length;
            } catch (error) {
                console.error('Failed to fetch courses', error);
            }
        }

    },

    mounted(){
        // allCourses
        this.fetchAllCourses();

        // allStudents
        this.fetchAllStudents();
    }
};

</script>
