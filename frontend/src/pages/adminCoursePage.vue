<template>

    <!-- create course success toast -->
     <div v-if="showCourseCreatedToast" class="bg-blue-400 fixed rounded-md p-4 mt-20 right-4 top-6 shadow-lg">
        <p class="text-white text-xl">Success</p>
     </div>

    <div class="min-h-screen bg-gray-100">
        <div class="flex w-full flex-col md:flex-row gap-0 md:gap-4 p-0 md:p-1 box-border">

            <!-- left -->
            <div class="left w-full md:w-[20%] lg:w-[15%] bg-white md:min-h-screen rounded-md p-2">
                <!-- logo -->
                 <div class="flex items-center gap-2 p-2">
                    <img src="/book.png" alt="book" width="40px">
                    <p class="text-4xl">E<span class="text-green-400">Learn</span></p>
                 </div>

                 <!-- other buttons -->
                  <div class="flex flex-col space-y-3 mt-6 p-2">
                    <button @click="goToDashboardPage" class="flex items-center gap-2 rounded-md p-2 hover:bg-purple-100">
                        <img src="/home.png" alt="home" width="30px">
                        <p class="text-2xl">Dashboard</p>
                    </button>
                    <button class="flex items-center gap-2 bg-green-200 rounded-md p-2 hover:bg-purple-100">
                        <img src="/learning.png" alt="learning" width="30px">
                        <p class="text-2xl">Courses</p>
                    </button>
                    <button @click="goToStudentPage" class="flex items-center gap-2 rounded-md p-2 hover:bg-purple-100">
                        <img src="/academic.png" alt="academic" width="30px">
                        <p class="text-2xl">Students</p>
                    </button>
                  </div>
            </div>

            <!-- right -->
            <div class="right w-full md:w-[80%] lg:w-[85%] bg-gray-100 rounded-md p-2">

                <!-- navbar -->
                 <div class="flex justify-between items-center p-4 sticky top-0 z-40 bg-white rounded-md shadow mb-4">
                    <!-- title -->
                    <p class="text-2xl font-bold hidden md:block">Dashboard</p>

                    <!-- search, ntifications and -->
                     <div class="flex items-center gap-4">
                        <!-- search bar -->
                         <div class=" flex rounded-full ring-1 gap-2 ring-green-300 p-2 hover:ring-red-300 bg-white">
                            <img src="/search.png" alt="search" width="20px">
                            <input v-model="searchTerm" type="text" name="" id="" class="outline-none text-lg bg-transparent" placeholder="Search courses...">
                         </div>

                         <!-- notification button -->
                          <div class="bg-white p-3 rounded-full relative">
                            <button @click="openNotificationModal">
                                <img src="/notification.png" alt="notification" width="30px">
                                <span v-if="notifications.some(n=> ['student_created', 'student_updated'].includes(n.action))" 
                                    class="absolute -top-1 -right-1 bg-red-500 text-white text-xs rounded-full px-1">
                                    {{ notifications.filter(n => ['student_created', 'student_updated'].includes(n.action) && !n.read).length }}
                                </span>
                            </button>
                          </div>

                          <!-- notification modal -->
                           <div v-if="showNotificationModal" class="bg-black bg-opacity-50 fixed z-50 w-full top-0 h-full left-0 flex items-center justify-center">
                            <div class="bg-white p-6 rounded-lg shadow-lg w-96 max-h-[80vh] overflow-y-auto">
                                <h2 class="text-lg font-bold mb-4">Unread Notifications</h2>
                                <ul>
                                    <li v-for="n in unreadNotifications" :key="n.id" class="mb-2 border-b pb-2">
                                        <p><strong>{{ n.action }}</strong>: {{ n.message }}</p>
                                    </li>
                                </ul>
                                <button @click="closeNotificationModal" class="mt-4 bg-blue-500 text-white px-4 py-2 rounded">Close</button>
                            </div>
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
                  <div class="px-4 py-6">
                    <div class="mb-6 flex justify-between mr-2">
                        <div class="">
                            <p class="text-4xl font-semibold mb-2">All Courses</p>
                            <span class="text-lg text-gray-600">Manage, edit and organize courses</span>
                        </div>

                        <div class="flex items-center gap-10">
                            <button @click="showActive" type="button" :class="buttonActive ? 'bg-purple-700 px-4 py-2 text-lg text-white rounded-md' : 'bg-purple-300 px-4 py-2 text-lg text-white rounded-md'">Active</button>
                            <button @click="showInactive" type="button" :class="buttonInactive ? 'bg-pink-700 px-4 py-2 text-lg text-white rounded-md' : 'bg-pink-300 px-4 py-2 text-lg text-white rounded-md'">Inactive</button>
                            <button @click="showAll" type="button" :class="buttonAll ? 'bg-gray-700 px-4 py-2 text-lg text-white rounded-md' : 'bg-gray-300 px-4 py-2 text-lg text-white rounded-md'">All</button>
                        </div>

                        <div class="">
                            <button type="button" @click="openCreateCourseModal" class="bg-green-500 px-4 py-2 rounded-md text-white text-xl">Add Course</button>
                        </div>

                    </div>
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                        <div v-if="filteredCourses().length > 0" v-for="(course, index) in filteredCourses()" :key="index" class="bg-white rounded-lg shadow-md p-4 hover:shadow-lg transition-shadow duration-300">
                            <div class="flex items-center justify-between">
                                <p class="text-xl font-medium text-gray-800">{{ course.name }}</p>
                                <p class="text-sm text-gray-500 rounded-full bg-blue-400 py-2 px-4">{{ course.status }}</p>
                            </div>
                            <div class="mt-3 flex items-center justify-between">
                                <span>{{ course.category }}</span>
                                <p class="font-bold">Cost: {{ course.price }}</p>
                            </div>

                            <div class="flex gap-2 mt-6">
                                <img src="/study.png" alt="student" width="20px">
                                <p class="text-lg text-gray-400">{{ course.student_count }} students enrolled</p>
                            </div>
                            <div class="flex items-center justify-end gap-4 mt-4">
                                <button type="button" @click="openUpdateCourseModal(course)">
                                    <img src="/edit.png" alt="edit" width="30px"></img>
                                </button>
                                <button type="button" @click="deleteCourse(course)">
                                    <img src="/delete.png" alt="delete" width="30px"></img>
                                </button>
                            </div>
                        </div>
                        <div v-else class="col-span-full text-center text-gray-600 py-8">
                            No Matching courses found!
                        </div>
                    </div>
                  </div>
            </div>
        </div>
    </div>

    <div v-if="showCreateCourseModal" class="bg-black bg-opacity-50 fixed inset-0 flex items-center justify-center">
        <div class="bg-white w-full rounded-md max-w-md p-2 relative">
            <form @submit.prevent="createCourse" action="">
                <div class="absolute right-2 top-1">
                    <p v-if="errors.general" class="text-sm text-red-500">{{ errors.general }}</p>
                    <button type="button" @click="closeCreateCourseModal">
                        <img src="/close.png" alt="close" width="12px">
                    </button>
                </div>
                <p class="text-center text-xl">{{ courseId ? "Update Course" : "Create Course" }}</p>
                <div class="p-2">
                    <div class="">
                        <label class="block text-xl" for="name">Name</label>
                        <input v-model="name" class="rounded-md ring-1 mt-1 mb-2 p-2 w-full ring-green-400 hover:ring-green-700 outline-none text-xl" type="text" name="name" id="">
                        <p v-if="errors.name" class="text-sm text-red-500">{{ errors.name }}</p>
                    </div>
                    <div class="">
                        <label class="block text-xl" for="category">Category</label>
                        <select v-model="category" class="rounded-md ring-1 mt-1 mb-2 p-2 w-full ring-green-400 hover:ring-green-700 outline-none text-xl" name="category" id="">
                            <option value="">-- Select Category --</option>
                            <option value="data">Data</option>
                            <option value="cyber security">Cybersecurity</option>
                            <option value="creative tech">Creative Tech</option>
                            <option value="career">Career</option>
                        </select>
                        <p v-if="errors.category" class="text-sm text-red-500">{{ errors.category }}</p>
                    </div>
                    <div class="">
                        <label class="block text-xl" for="duration">Duration</label>
                        <input v-model="duration" class="rounded-md ring-1 mt-1 mb-2 p-2 w-full ring-green-400 hover:ring-green-700 outline-none text-lg" type="text" name="duration" id="">
                        <p v-if="errors.duration" class="text-sm text-red-500">{{ errors.duration }}</p>
                    </div>
                    <div class="">
                        <label class="block text-xl" for="price">Price</label>
                        <input v-model="price" class="rounded-md ring-1 mt-1 mb-2 p-2 w-full ring-green-400 hover:ring-green-700 outline-none text-lg" type="number" name="price" id="">
                        <p v-if="errors.price" class="text-sm text-red-500">{{ errors.price }}</p>
                    </div>
                </div>

                <div v-if="courseId" class="mb-3">
                    <button type="button" @click="toggleCourseStatus()" class="text-white  text-lg rounded-md p-2 bg-yellow-500">{{ courseStatus === "Active" ? "Deactivate" : "Activate" }}</button>
                </div>
                
                <div class="flex items-center justify-between mr-6 ml-5">
                    <button type="button" class="rounded-md bg-gray-600 py-2 px-4 hover:bg-gray-900 text-white text-lg" @click="closeCreateCourseModal">Close</button>
                    <button type="submit" class="rounded-md bg-blue-600 py-2 px-4 hover:bg-blue-900 text-white text-lg">{{ courseId ? "Update" : "Create" }}</button>
                </div>
            </form>
        </div>
    </div>

</template>

<script>
import api from '@/sevices/api';
import dayjs from 'dayjs';
import relativeTime from 'dayjs/plugin/relativeTime';

// Customize language
import 'dayjs/locale/en'; // default locale
dayjs.locale('en', {
  relativeTime: {
    future: 'in %s',
    past: '%s ago',
    s: 'a few secs',
    m: '1 min',
    mm: '%d mins',
    h: '1 hour',
    hh: '%d hrs',
    d: '1 day',
    dd: '%d days',
    M: '1 mo',
    MM: '%d mos',
    y: '1 yr',
    yy: '%d yrs',
  }
});

dayjs.extend(relativeTime);

export default{

    data(){
        return {

            flag: '',
            email: '',
            phone: '',

            showAdminInfo: false,

            notifications: [],

            timeInterval: null,

            showFourNotifications: 4,

            readNotification: false,

            showNotificationModal: false,

            allCourses: [],

            showCreateCourseModal: false,

            showUpdateCourseModal: false,

            name: '',
            category: '',
            duration: '',
            price: '',

            courseId: '',

            courseStatus: '',

            errors: {},

            searchTerm: '',

            showCourseCreatedToast: false,

            selectedStatus: 'All',

            buttonActive: false,
            buttonAll: false,
            buttonInactive: false,

        };
    },

    computed: {
        // unreadNotifications
        unreadNotifications(){
            return this.notifications.filter(n => 
                ['student_created', 'student_updated'].includes(n.action) && !n.read
            );
        },
        // fourNotifications
        fourNotifications(){
            return this.notifications.slice(0, this.showFourNotifications)
        },       
    },

    methods: {

        // showActive
        showActive(){
            this.buttonActive = true,
            this.buttonAll = false
            this.buttonInactive = false
            this.selectedStatus = 'Active'
        },

        // showInactive
        showInactive(){
            this.buttonInactive = true
            this.buttonAll = false
            this.buttonActive = false
            this.selectedStatus = 'Inactive'
        },

        // showAll
        showAll(){
            this.buttonAll = true
            this.buttonActive = false
            this.buttonInactive = false
            this.selectedStatus = 'All'
        },

        // toggleCourseStatus
        async toggleCourseStatus(){
            const newStatus = this.courseStatus === 'Active' ? 'Inactive' : 'Active'
            await api.patch(`update_course/${this.courseId}`, {
                status: newStatus
            });
            this.courseStatus = newStatus;
        },

        // openCreateCourseModal
        openCreateCourseModal(){
            this.errors = {}
            this.clearForm();
            this.courseId = '';
            this.showCreateCourseModal = true
        },

        // openUpdateCourseModal
        async openUpdateCourseModal(course){
            this.showCreateCourseModal = true;
            this.errors = {};
            this.courseId = course.id
            const updatedCourse = await api.get(`single_course/${course.id}`)
            this.name = updatedCourse.data.name
            this.category = updatedCourse.data.category
            this.duration = updatedCourse.data.duration
            this.price = updatedCourse.data.price
            this.courseStatus = updatedCourse.data.status
        },

        // filteredCourses
        filteredCourses(){
            return this.allCourses.filter(course =>{
                const matchName = course.name.toLowerCase().includes(this.searchTerm.toLowerCase());
                const matchesStatus = this.selectedStatus === 'All' || course.status === this.selectedStatus;
                return matchName && matchesStatus
            }
            )
        },

        // clearForm
        clearForm(){
            this.name = '',
            this.category = '',
            this.duration = ''
        },

        // createCourse
        async createCourse(){
            this.errors = {};
            const payload = {
                course: {
                    name: this.name,
                    category: this.category,
                    duration: this.duration,
                }
            };
            
            try {
                if (this.courseId) {
                    const response = await api.patch(`update_course/${this.courseId}`, payload)
                } else {
                    const response = await api.post('create_course', payload)
                }
    
                this.clearForm();
                this.showCreateCourseModal = false;
    
                this.showCourseCreatedToast = true;
                setTimeout(() => {
                    this.showCourseCreatedToast = false
                }, 2000);
    
                this.fetchAllCourses();
                this.errors = {};
            } catch (error) {
                if (error.response && error.response.data && error.response.data.errors) {
                    this.errors = error.response.data.errors
                } else {
                    this.errors = { general: "Something went wrong!"}
                }
            }
        },

        // closeCreateCourseModal
        closeCreateCourseModal(){
            this.showCreateCourseModal = false;
            this.fetchAllCourses();
        },

        // deleteCourse
        async deleteCourse(courseObj){
            try {
                const confirmDelete = window.confirm(`Want to delete ${courseObj.name}?`)
                if (confirmDelete) {
                    await api.delete(`delete_course/${courseObj.id}`)
                    this.fetchAllCourses()
                }
            } catch (error) {
                console.error('Error deleteing course:', error);
            }
        },

        // fetchAllCourses
        async fetchAllCourses(){
            const response = await api.get('all_courses')
            this.allCourses = response.data
        },

        // goToStudentPage
        goToDashboardPage(){
            this.$router.push('/admin-dashboard')
        },

        // goToCoursePage
        goToStudentPage(){
            this.$router.push('/admin-dashboard/students')
        },

        // openNotificationModal
        openNotificationModal(){
            this.showNotificationModal = true
        },

        // closeNotificationModal
        async closeNotificationModal(){
            this.showNotificationModal = false;

            // mark unread notifications as read
            const unread = this.unreadNotifications;
            for (const notif of unread){
                try {
                    await api.patch(`update_notification/${notif.id}`, {
                        read: true
                    });
                    notif.read = true
                } catch (error) {
                    console.error('Failed:', error);
                }
            }
        },

        // viewNotification
        async viewNotification(){
            try {
                const notif = this.notifications.find(n => 
                    ['student_created', 'student_updated'].includes(n.action) && !n.read
                );
                if (notif) {
                    await api.patch(`update_notification/${notif.id}`, {
                        read: true
                    });
                    notif.read = true;
                }
            } catch (error) {
                console.error('Failed to update notification:', error);
            }

        },

        // formatTime
        formatTime(datetime){
            return dayjs(datetime).fromNow();
        },

        // showNotification
        async showNotifications() {
            try {
                const response = await api.get('all_notifications');
                this.notifications = response.data
            } catch (error) {
                console.error('Error fetching notifications:', error);
            }
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

    },

    async mounted(){

        this.showNotifications();

        this.timeInterval = setInterval(() => {
            this.notifications = [...this.notifications]
        }, 60000);

        // userFlag
        this.fetchFlag();

        // allCourses
        await this.fetchAllCourses();

        // filteredCourses
        this.filteredCourses()

        // allStudents
        await this.fetchAllStudents();

        // allCourses
        await this.AllCourses();

        // activatedCourses
        this.activatedCourses();

        // deactivatedCourses
        this.deactivatedCourses();
    },

    beforeUnmount(){
        clearInterval(this.timeInterval);
    }
};

</script>
