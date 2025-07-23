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
                    <button class="flex items-center gap-2 rounded-md p-2 hover:bg-purple-100">
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
            <div class="right md:w-[80%] lg:w-[85%] bg-white min-h-screen rounded-md">
                <!-- navbar -->
                 <div class="flex">
                    <!-- title -->
                    <div class="">
                        <p>Dashboard</p>
                    </div>
                    <!-- search, ntifications and -->
                     <div class="flex">
                        <!-- search bar -->
                         <div class=" flex rounded-md ring-1 bg-transparent gap-2 ring-green-300 p-2 hover:ring-red-300">
                            <img src="/search.png" alt="search" width="20px" height="20px">
                            <input type="text" name="" id="" class="outline-none text-lg" placeholder="Search...">
                         </div>

                         <!-- notification -->
                          <div class="">
                            <img src="/notification.png" alt="notification" width="30px">
                          </div>
                          
                          <!-- other -->
                           <div class="">
                            <img src="/user.png" alt="avatar" width="30px">
                           </div>
                     </div>
                 </div>
            </div>
        </div>
    </div>
</template>