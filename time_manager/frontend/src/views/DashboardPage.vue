<script setup>
import {ref, onMounted} from 'vue';
import UserComponent from '../components/UserComponent.vue';
import WorkingTimes from '../components/WorkingTimes.vue';
import WorkingTime from '../components/WorkingTime.vue';
import ClockManager from '../components/ClockManager.vue';
import ChartManager from '../components/ChartManager.vue';

const user = ref({
  username: '',
  email: '',
  role: ''
});

const myModal = ref();

onMounted(async () => { 
 user.value = {
   username: localStorage.getItem('username'),
   email: localStorage.getItem('email'),
   role: localStorage.getItem('role')
 };
});
const handleProfileEdit = (event) => {
  event.preventDefault();
  console.log('Profile edited:', user.value);
  closeModal();
};

const openModal = () => {
  if (myModal.value) {
    myModal.value.showModal();
  }
};

const closeModal = () => {
  if (myModal.value) {
    myModal.value.close();
  }
};
</script>


<template>
  <div class="bg-primary-content flex h-screen">
    <div class="w-1/5 flex justify-center pt-10">
      <div>
        <div class="flex justify-center">
          <div class="avatar">
            <div class="mask mask-squircle w-24">
              <img src="https://img.daisyui.com/images/stock/photo-1534528741775-53994a69daeb.webp" alt="User avatar" />
            </div>
          </div>
        </div>
        <div class="flex flex-col items-center mt-4">
          <p class="text-2xl">Hello, {{ user.username }}!</p>
          <p class="text-sm">{{ user.email }}</p>
          <p class="uppercase font-bold">{{ user.role }}</p>
        </div> 

        <!-- Edit Profile Button -->
        <div class="flex justify-center mt-4">
          <button class="btn btn-primary" @click="openModal">
            Edit profile
          </button>

          <!-- Edit Profile Modal -->
          <dialog ref="myModal" class="modal">
            <div class="modal-box">
              <form @submit="handleProfileEdit">
                <button type="button" class="btn btn-sm btn-circle btn-ghost absolute right-2 top-2" @click="closeModal">✕</button>
                <h3 class="text-lg font-bold">Edit profile</h3>
                <div class="flex flex-col gap-2 mt-4">
                  <div class="flex justify-between items-center">
                    <span class="label-text">Username</span>
                    <input type="text" v-if="user.username" class="input input-bordered w-full max-w-xs" />
                  </div>
                  <div class="flex justify-between items-center">
                    <span class="label-text">E-mail</span>
                    <input type="text" v-if="user.email" class="input input-bordered w-full max-w-xs" />
                  </div>
                  <div class="flex justify-between items-center">
                    <span class="label-text">Role</span>
                    <input type="text" v-if="user.role" class="input input-bordered w-full max-w-xs" />
                  </div>
                  <button type="submit" class="btn mt-4">Save</button>
                </div>
              </form>
            </div>
          </dialog>
        </div>
      </div>
    </div> 


    <div class="absolute bottom-5 left-5">
            <a href="/">
              <button class="btn">
                <v-icon name="fa-sign-out-alt" />
              </button>
            </a>
    </div>

    <!-- Main Content Area -->
    <div class="w-full flex justify-center bg-white rounded-l-[25px]">
      <div class="w-full">
        <div class="grid grid-cols-2">
          <UserComponent />
          <div class="flex">
            <ClockManager />
            <ChartManager />
          </div>
        </div>
        <div class="grid grid-cols-2 gap-4">
          <WorkingTime />
          <WorkingTimes />
        </div>
      </div>
    </div>
  </div>
</template>
