<template>
    <div class="bg-green-400">
        <p>Welcome {{ fname.charAt(0).toUpperCase() + fname.slice(1) }} {{ lname.charAt(0).toUpperCase() + lname.slice(1) }} {{ phone }}</p>
    </div>
</template>

<script>
export default {
    data(){
        return {
            fname: '',
            lname: '',
            phone: '',
        }
    },
    mounted() {
        this.fname = localStorage.getItem('f_name');
        this.lname = localStorage.getItem('l_name');
        this.phone = localStorage.getItem('phone');
    },
}
</script>
