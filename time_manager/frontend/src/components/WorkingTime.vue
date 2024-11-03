<script setup>
import { ref, onMounted } from 'vue';
import GanttChart from './charts/GanttChart.vue';
import axios from 'axios';

const days = ref([]);
const selectedDay = ref(null);

const fetchWorkingTimes = async () => {
  try {
    const token = localStorage.getItem('token');
    const response = await axios.get('/api/workingtime', {
      headers: { Authorization: `Bearer ${token}` },
    });
    days.value = response.data;
  } catch (error) {
    console.error('Error fetching working times:', error);
  }
};

// Dialog element refs
const addDialog = ref(null);
const editDialog = ref(null);
const deleteDialog = ref(null);

const openAddDialog = () => {
  addDialog.value?.showModal();
};

const openEditDialog = (day) => {
  selectedDay.value = { ...day };
  editDialog.value?.showModal();
};

const openDeleteDialog = (day) => {
  selectedDay.value = day;
  deleteDialog.value?.showModal();
};

const closeDialog = (dialogRef) => {
  dialogRef?.close();
};

onMounted(() => {
  fetchWorkingTimes();
});
</script>

<template>
  <div class="mb-4 mx-4">
    <div class="border rounded-xl h-96">
      <GanttChart />
      <div class="grid grid-cols-3 gap-2 m-2 mt-11 justify-end items-center">
        <button class="btn" @click="openAddDialog">
          <v-icon name="fa-plus" />
        </button>
        <button class="btn" @click="openEditDialog">
          <v-icon name="fa-edit" />
        </button>
        <button class="btn" @click="openDeleteDialog">
          <v-icon name="fa-trash" />
        </button>
      </div>
    </div>

    <!-- Add Dialog -->
    <dialog ref="addDialog" class="modal">
      <form @submit.prevent="addWorkingTime">
        <button type="button" class="btn btn-sm btn-circle btn-ghost absolute right-2 top-2" @click="closeDialog(addDialog)">✕</button>
        <!-- Additional form elements go here -->
      </form>
    </dialog>

    <!-- Edit Dialog -->
    <dialog ref="editDialog" class="modal">
      <div class="modal-box w-11/12 max-w-5xl">
        <form @submit.prevent="editWorkingTime">
          <button type="button" class="btn btn-sm btn-circle btn-ghost absolute right-2 top-2" @click="closeDialog(editDialog)">✕</button>
          <table class="table">
            <thead>
              <tr>
                <th>Date</th>
                <th>Worked</th>
                <th>Started at</th>
                <th>Finished at</th>
                <th></th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="(day, index) in days" :key="index">
                <td class="font-bold">{{ day.date }}</td>
                <td><input type="checkbox" v-model="day.worked" class="checkbox" /></td>
                <td><input type="time" v-model="day.start" class="input w-full max-w-xs h-6" /></td>
                <td><input type="time" v-model="day.end" class="input w-full max-w-xs h-6" /></td>
                <td><button type="button" class="btn btn-warning" @click="openEditDialog(day)"><v-icon name="fa-edit" /></button></td>
              </tr>
            </tbody>
          </table>
        </form>
      </div>
    </dialog>

    <!-- Delete Dialog -->
    <dialog ref="deleteDialog" class="modal">
      <div class="modal-box">
        <form @submit.prevent="deleteWorkingTime">
          <button type="button" class="btn btn-sm btn-circle btn-ghost absolute right-2 top-2" @click="closeDialog(deleteDialog)">✕</button>
        </form>
      </div>
    </dialog>
  </div>
</template>
