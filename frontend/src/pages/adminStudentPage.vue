<template>

    <!-- create course success toast -->
     <div v-if="showCourseCreatedToast" class="bg-blue-400 fixed rounded-md p-4 mt-20 right-4 top-6 shadow-lg">
        <p class="text-white text-xl">Success</p>
     </div>

    <div class="min-h-screen bg-gray-100">
        <div class="flex w-full flex-col md:flex-row gap-4 p-1">

            <!-- left -->
            <div class="left md:w-[20%] lg:w-[15%] bg-white md:min-h-screen rounded-md p-2">
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
                    <button @click="goToCoursePage" class="flex items-center gap-2 rounded-md p-2 hover:bg-purple-100">
                        <img src="/learning.png" alt="learning" width="30px">
                        <p class="text-2xl">Courses</p>
                    </button>
                    <button class="flex items-center gap-2 bg-green-200 rounded-md p-2 hover:bg-purple-100">
                        <img src="/academic.png" alt="academic" width="30px">
                        <p class="text-2xl">Students</p>
                    </button>
                  </div>
            </div>

            <!-- right -->
            <div class="right md:w-[80%] lg:w-[85%] bg-gray-100 min-h-screen rounded-md p-2">

                <!-- navbar -->
                 <div class="flex justify-between items-center p-4 sticky top-0 z-40 bg-white rounded-md shadow mb-4">
                    <!-- title -->
                    <p class="text-2xl font-bold hidden md:block">Dashboard</p>

                    <!-- search, ntifications and -->
                     <div class="flex items-center gap-4">
                        <!-- search bar -->
                         <div class=" flex rounded-full ring-1 gap-2 ring-green-300 p-2 hover:ring-red-300 bg-white">
                            <img src="/search.png" alt="search" width="20px">
                            <input v-model="searchTerm" type="text" name="" id="" class="outline-none text-lg bg-transparent" placeholder="Search students...">
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
                  <div class="flex justify-between mr-5">
                    <p class="text-4xl font-bold">All Students</p>
                    <button @click="goToRegisterPage" type="button" class="bg-green-500 rounded-md text-white text-lg p-2">
                        <p>Create Student</p>
                    </button>
                  </div>
                  <div v-if="filteredStudents.length > 0" class="">
                    <div v-for="(student, index) in filteredStudents" :key="index" class="bg-white mt-4 rounded-md p-4 w-full max-w-md">
                        <div class="flex items-center gap-2">
                            <p class="text-2xl">Name:</p>
                            <p class="text-xl text-gray-500">{{ student.first_name }} {{ student.last_name }} </p>
                        </div>
                        <div class="flex gap-4 mt-4">
                            <p class="text-xl">Course:</p>
                            <p>{{ student.course_name }}</p>
                        </div>
                        <div class="">
                            <button type="button" @click="deleteStudent(student)">
                                <img src="/delete.png" alt="delete" width="30px">
                            </button>
                        </div>
                    </div>
                  </div>
                  <div v-else class="text-center text-gray-600 py-4">
                    No Students found
                  </div>
            </div>
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

            allStudents: [],

            searchTerm: ''

        };
    },

    computed: {
        // filteredStudents
        filteredStudents(){
            return this.allStudents.filter(student => 
                student.first_name.toLowerCase().includes(this.searchTerm.toLowerCase())
            )
        },
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
        // goToRegister
        goToRegisterPage(){
            this.$router.push('/create-account')
        },

        // deleteStudent
        async deleteStudent(student){
            try {
                const confirmDelete = window.confirm(`Delete ${student.first_name}`);
                if (!confirmDelete) return
                await api.delete(`delete_student/${student.id}`);
                this.allStudents = this.allStudents.filter(s => 
                    s.id !== student.id
                )
            } catch (error) {
                console.error('Error deleting student:', error);
            }
        },
        // fetchAllStudents
        async fetchAllStudents(){
            try {
                const response = await api.get('all_students');
                this.allStudents = response.data
            } catch (error) {
                console.error('Failed to fetch students:', error);
                this.students = []
            }
        },
        // goToStudentPage
        goToDashboardPage(){
            this.$router.push('/admin-dashboard')
        },

        // goToCoursePage
        goToCoursePage(){
            this.$router.push('/admin-dashboard/courses')
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

        this.fetchAllStudents();

        this.showNotifications();

        this.timeInterval = setInterval(() => {
            this.notifications = [...this.notifications]
        }, 60000);

        // userFlag
        this.fetchFlag();

        // allCourses
        await this.fetchAllCourses();

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
