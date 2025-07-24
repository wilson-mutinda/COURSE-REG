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
              <div class="right md:w-[80%] lg:w-[85%] bg-gray-200 min-h-screen rounded-md">r</div>
        </div>
    </div>
</template>