<template>

    <!-- create course success toast -->
     <div v-if="showCourseCreatedToast" class="bg-blue-400 fixed rounded-md p-4 mt-20 right-4 top-6">
        <p class="text-white text-xl">Success</p>
     </div>

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
                 <div class="flex justify-between items-center p-4 sticky top-0 z-40 bg-white mb-4">
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
                            <input v-model="searchTerm" type="text" name="" id="" class="outline-none text-lg bg-transparent" placeholder="Search courses...">
                         </div>

                         <!-- notification -->
                          <div class="bg-white p-3 rounded-full">
                            <img src="/notification.png" alt="notification" width="30px">
                          </div>
                          
                          <!-- other -->
                           <div class="relative">
                                <div class="flex items-center gap-4 p-3 bg-white rounded-md">
                                    <img src="/user.png" alt="avatar" width="30px" class="rounded-full ring-1 p-1 ring-green-400 w-10 h-10">
                                    <p class="text-lg font-semibold">{{ flag.charAt(0).toUpperCase() + flag.slice(1) }}</p>
                                    <button type="button" @click="toggleAdminInfo">
                                    <img src="/down-arrow.png" alt="down-arrow" width="12px">
                                    </button>
                                </div>

                                <!-- Admin info -->
                                <div v-if="showAdminInfo" class="mt-2 bg-white shadow-md p-2 rounded-md text-sm absolute z-10">
                                    <p><strong>Email:</strong> {{ email }}</p>
                                    <p><strong>Phone:</strong> {{ phone }}</p>
                                </div>
                            </div>
                     </div>
                 </div>

                 <!-- body -->
                  <div class="">
                    <!-- top -->
                     <div class="flex gap-10">
                        <!-- all students -->
                         <div class="flex items-center bg-white p-6 rounded-md">
                            <img src="/academic.png" alt="learning" width="40px" class="bg-blue-200 rounded-full p-1 mr-2">
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

                     <!-- course overview -->
                      <div class="rounded-md bg-white mt-5 mr-4 p-2 shadow">
                        <div class="flex justify-between items-center mb-4">
                            <!-- title -->
                            <div class="p-2">
                                <p class="text-2xl font-semibold">Course Overview</p>
                            </div>

                            <!-- create button -->
                            <div class="">
                                <button @click="openCreateCourseForm" class="rounded-md bg-green-400 px-4 py-2 gap-2 flex items-center hover:bg-green-500 text-white text-lg">
                                    <img src="/plus.png" alt="add" width="14px">
                                    <span class="text-xl">Create Course</span>
                                </button>
                            </div>
                        </div>

                        <!-- table -->
                         <div class="overflow-x-auto">
                            <table class="w-full text-left border-collapse">
                                <!-- thead -->
                                <thead class="bg-gray-100 text-gray-700">
                                    <tr class="">
                                        <th>#</th>
                                        <th>Courses</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>

                                <!-- tbody -->
                                 <tbody>
                                    <tr v-if="filteredCourses().slice(0, showFourCourses).length === 0">
                                        <td colspan="3" class="text-center text-gray-500 py-4">No matches!</td>
                                    </tr>
                                    
                                    <tr v-for="(course, index) in filteredCourses().slice(0, showFourCourses)" :key="index" class="hover:bg-gray-50 border-b">
                                        <td>{{ index + 1 }}.</td>
                                        <td>
                                            <div class="flex items-center gap-4">
                                                <img src="/open-magazine.png" alt="open-magazine" class="w-8 h-8 rounded-full ring-1 ring-blue-500 px-2 py-1">
                                                <div class="flex flex-col space-y-2">
                                                    <p class="text-xl font-semibold">{{ course.name }}</p>
                                                    <span class="text-lg text-gray-600">
                                                        {{ course.category.charAt(0).toUpperCase() + course.category.slice(1) }}
                                                    </span>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="flex items-center gap-3">
                                                <button @click="openEditCourseModal(course)" class="rounded-full p-2" type="button">
                                                    <img src="/edit.png" alt="edit" width="20px">
                                                </button>
                                                <button @click="deleteCourse(course.id)" class="rounded-full p-2" type="button">
                                                    <img src="/delete.png" alt="delete" width="20px">
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                 </tbody>
                            </table>
                         </div>
                         <!-- show more -->
                         <div v-if="showFourCourses < allCourses.length" class="">
                            <button @click="moreCourses" class="bg-blue-30 rounded-md p-2 text-green-400">
                                <p>Show more...</p>
                            </button>
                         </div>
                      </div>
                  </div>
            </div>
        </div>
    </div>

    <!-- modal -->
     <div v-if="openCreateCourseModal" class="bg-black bg-opacity-70 fixed inset-0 flex justify-center items-center">
        <div class="bg-white w-full max-w-md p-4 rounded-md relative">
            <form @submit.prevent="createCourse" action="">
                <!-- close buton -->
                 <div class="absolute right-5 top-2">
                    <button @click="openCreateCourseModal = false" type="button">
                        <img src="/close.png" alt="close" width="12px">
                    </button>
                 </div>
                <p class="mb-2 text-center text-xl">
                    {{ isEditMode ? 'Update Course' : 'Create Course' }}
                </p>

                <!-- name -->
                <div class="">
                    <label class="block text-xl" for="name">Name</label>
                    <input class="ring-1 ring-green-400 w-full rounded-md p-2 outline-none text-xl mb-2" v-model="name" placeholder="pathway, cybersecurity" type="text" name="name" id="">
                </div>

                <!-- category -->
                 <div class="">
                    <label class="block text-xl" for="category">Category</label>
                    <select class="rounded-md ring-1 ring-green-400 w-full p-2 outline-none text-xl mb-2" v-model="category" name="category" id="">
                        <option value="">-- Select Category --</option>
                        <option value="data">Data</option>
                        <option value="cyber security">Cybersecurity</option>
                        <option value="creative tech">Creative Tech</option>
                        <option value="career">Career</option>
                    </select>
                 </div>
                 <!-- duration -->
                  <div class="">
                    <label class="block text-xl" for="duration">Duration</label>
                    <input class="ring-1 ring-green-400 w-full rounded-md p-2 outline-none text-xl mb-2" v-model="duration" placeholder="8 weeks, 6 months" type="text" name="duration" id="">
                  </div>

                  <!-- buttons -->
                   <div class="flex justify-between mt-4">
                    <button class="rounded-md bg-gray-600 px-4 py-2 text-white text-lg" @click="openCreateCourseModal = false" type="button">Close</button>
                    <button type="submit" class="rounded-md bg-blue-400 px-4 py-2 text-white text-lg">
                        {{ isEditMode ? 'Update' : 'Create' }}
                    </button>
                   </div>
            </form>
        </div>
     </div>
</template>

<script>
import api from '@/sevices/api';

export default{

    data(){
        return {
            searchTerm: '',

            courseCount: 0,

            studentCount: 0,

            flag: '',
            email: '',
            phone: '',

            showAdminInfo: false,

            allCourses: [],

            openCreateCourseModal: false,

            name: '',
            category: '',
            duration: '',

            showCourseCreatedToast: false,

            showFourCourses: 4,

            courseIdToUpdate: null,
            isEditMode: false,
        };
    },

    computed: {
        // showOnly4Coursespergo
        fourCourses(){
            return this.allCourses.slice(0, this.showFourCourses)
        }        
    },

    methods: {

        // filteredCourses
        filteredCourses(){
            return this.allCourses.filter(course => 
                course.name.toLowerCase().includes(this.searchTerm.toLowerCase())
            )
        },

        // resetCourseForm
        resetConfirmForm(){
            this.name = '';
            this.category = '';
            this.duration = '';
            this.courseIdToUpdate = null;
            this.isEditMode = false;
        },

        // openCreateCourseForm
        openCreateCourseForm(){
            this.resetConfirmForm();
            this.openCreateCourseModal = true;
        },

        // openEditCourseModal
        openEditCourseModal(course){
            this.name = course.name;
            this.category = course.category;
            this.duration = course.duration;
            this.courseIdToUpdate = course.id;
            this.isEditMode = true;
            this.openCreateCourseModal = true;
        },

        // showMore
        moreCourses(){
            this.showFourCourses += 4
        },

        // deleteCourse
        async deleteCourse(courseId){
            const confrmDelete = window.confirm('Sure To Delete?');
            if (confrmDelete){
                await api.delete(`delete_course/${courseId}`);
                this.fetchAllCourses();
                this.AllCourses();
            }
        },

        // createCourse
        async createCourse() {
            const payload = {
                course: {
                    name: this.name,
                    category: this.category,
                    duration: this.duration,
                }
            };
            try {
                if(this.isEditMode && this.courseIdToUpdate) {
                    await api.patch(`update_course/${this.courseIdToUpdate}`, payload);
                } else {
                    await api.post('create_course', payload);
                }

                this.openCreateCourseModal = false;
                this.name = '';
                this.category = '';
                this.duration = '';
                this.courseIdToUpdate = null;
                this.isEditMode = false;

                // refresh courses
                await this.fetchAllCourses();
                await this.AllCourses();

                // show toast
                this.showCourseCreatedToast = true;

                // hide toast after 3 seconds
                setTimeout(() => {
                    this.showCourseCreatedToast = false;
                }, 3000);
            } catch (error) {
                console.error("Something went wrong!", error);
            }
        },

        // AllCourses
        async AllCourses(){
            const response = await api.get('all_courses');
            this.allCourses = response.data
        },

        // toggleAdminInfo
        toggleAdminInfo(){
            this.showAdminInfo = !this.showAdminInfo;
            if (this.showAdminInfo) {
                this.email = localStorage.getItem('email');
                this.phone = localStorage.getItem('phone');
            }
        },

        // fetchFlag
        fetchFlag(){
            this.flag = localStorage.getItem('flag')
        },

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
        // userFlag
        this.fetchFlag();

        // allCourses
        this.fetchAllCourses();

        // allStudents
        this.fetchAllStudents();

        // allCourses
        this.AllCourses();
    }
};

</script>
