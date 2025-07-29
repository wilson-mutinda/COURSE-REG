<template>
    <div class="bg-gray-200 min-h-screen flex justify-center p-6">
        <div class="bg-white w-full max-w-[90%] rounded-md p-6 h-auto">
            <p class="font-semibold text-xl">Welcome {{ first_name.charAt(0).toUpperCase() + first_name.slice(1) }}!</p>
            <span class="text-lg text-gray-700">Please fill in the remaining info:</span>

            <div class="">
                <form action="" @submit.prevent="finalSubmit">
                    <p v-if="errors.general" class="text-red-500 text-sm">{{ errors.general }}</p>

                    <div class="mt-5 space-y-2">
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                            <div class="">
                                <label class="block mt-4 mb-2 font-semibold text-xl" for="first_name">First Name</label>
                                <input required v-model="first_name" class="rounded-md ring-1 p-2 w-full outline-none ring-gray-400 hover:ring-green-300" type="text" name="first_name" id="">
                                <span v-if="errors.first_name" class="text-red-500 text-sm">{{ errors.first_name }}</span>
                            </div>

                            <div class="">
                                <label class="block mt-4 mb-2 font-semibold text-xl" for="middle_name">Middle Name</label>
                                <input required v-model="middle_name" class="rounded-md ring-1 p-2 w-full outline-none ring-gray-400 hover:ring-green-300" type="text" name="last_name" id="">
                                <span v-if="errors.middle_name" class="text-red-500 text-sm">{{ errors.middle_name }}</span>
                            </div>
                        </div>

                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                            <div class="">
                                <label class="block mt-4 mb-2 font-semibold text-xl" for="last_name">Last Name</label>
                                <input required v-model="last_name" class="rounded-md ring-1 p-2 w-full outline-none ring-gray-400 hover:ring-green-300" type="text" name="last_name" id="">
                                <span v-if="errors.last_name" class="text-red-500 text-sm">{{ errors.last_name }}</span>
                            </div>
                        </div>

                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                            <div class="">
                                <label class="block mt-4 mb-2 font-semibold text-xl" for="dob">Date of Birth</label>
                                <input required v-model="date_of_birth" class="rounded-md ring-1 p-2 w-full outline-none ring-gray-400 hover:ring-green-300" type="date" name="dob" id="">
                                <span v-if="errors.date_of_birth" class="text-red-500 text-sm">{{ errors.date_of_birth }}</span>
                            </div>

                            <div class="">
                                <label class="block mt-4 mb-2 font-semibold text-xl" for="gender">Gender</label>
                                <select required v-model="gender" class="rounded-md ring-1 p-2 w-full outline-none ring-gray-400 hover:ring-green-400" name="gender" id="">
                                    <option value="">-- Select Gender --</option>
                                    <option value="male">Male</option>
                                    <option value="female">Female</option>
                                </select>
                                <span v-if="errors.gender" class="text-red-500 text-sm">{{ errors.gender }}</span>
                            </div>
                        </div>

                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                            <div class="">
                                <label class="block mt-4 mb-2 font-semibold text-xl" for="country">Country</label>
                                <select required v-model="country" class="ring-1 rounded-md p-2 w-full outline-none ring-gray-400 hover:ring-green-400" name="country" id="">
                                    <option value=""> -- Choose Country --</option>
                                    <option value="kenya">Kenya</option>
                                </select>
                                <span v-if="errors.country" class="text-red-500 text-sm">{{ errors.country }}</span>
                            </div>
                            <div class="">
                                <label class="block mt-4 mb-2 font-semibold text-xl" for="phone">Phone Number</label>
                                <input required v-model="phone" class="rounded-md ring-1 p-2 w-full outline-none ring-gray-400 hover:ring-green-300" type="tel" name="tel" id="">
                                <span v-if="errors.phone" class="text-red-500 text-sm">{{ errors.phone }}</span>
                            </div>
                        </div>

                        <div class="w-full flex justify-end">
                            <button class="bg-blue-400 rounded-md px-4 py-2 text-white text-lg">Save</button>
                        </div>
                    </div>

                </form>
            </div>
        </div>
    </div>
</template>

<script>
import api from '@/sevices/api';

export default {
    data(){
        return {
            first_name: '',
            last_name: '',
            middle_name: '',
            date_of_birth: '',
            gender: '',
            country: '',
            phone: '',
            user_id: '',

            course_id: '',

            errors: {}
        }
    },
    mounted() {
        this.first_name = localStorage.getItem('first_name');
        this.last_name = localStorage.getItem('last_name');
        this.phone = localStorage.getItem('phone');
        this.user_id = localStorage.getItem('user_id');

        this.course_id = localStorage.getItem('course_id')

        if (!this.user_id){
            this.$router.push('/create-account')
        }
    },
    methods: {
        // clearForm
        clearForm(){
            this.first_name = '';
            this.last_name = '';
            this.middle_name = '';
            this.date_of_birth = '';
            this.gender = '';
            this.country = '';
            this.phone = '';
        },

        // finalSubmit
        async finalSubmit(){
            
            this.errors = {};
            try {
                const payload = {
                    student: {
                        middle_name: this.middle_name,
                        date_of_birth: this.date_of_birth,
                        gender: this.gender,
                        country: this.country
                    }
                };
                const response = await api.patch(`add_student_info/${this.user_id}`, payload);
                // alert('Student created successfully!')
                this.$router.push('/student/course-reg')
                // clearForm
                this.clearForm();
                this.errors = {};
            } catch (error) {
                if (error.response && error.response.data && error.response.data.errors) {
                    this.errors = error.response.data.errors
                } else {
                    this.errors = { general: "Something wet wrong!"}
                }
            }
        }
    }
}
</script>
