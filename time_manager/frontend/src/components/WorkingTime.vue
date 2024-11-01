<script setup>
import { ref, onMounted } from 'vue';
import GanttChart from './charts/GanttChart.vue';
import axios from 'axios';

const days = ref([]);
const addWorkingTimesDialog = ref(null);
const editWorkingTimesDialog = ref(null);
const deleteWorkingTimesDialog = ref(null);
const selectedDay = ref(null); // To track which day is selected for editing or deleting

const generateWorkingDays = () => {
  const today = new Date();
  const currentDay = today.getDay();
  const startOfWeek = new Date(today);
  startOfWeek.setDate(today.getDate() - currentDay + (currentDay === 0 ? -6 : 1));

  for (let i = 0; i < 5; i++) {
    const currentDate = new Date(startOfWeek);
    currentDate.setDate(startOfWeek.getDate() + i);
    const formattedDate = currentDate.toISOString().split('T')[0];

    days.value.push({
      date: formattedDate,
      worked: false,
      start: '08:00',
      end: '17:00',
    });
  }
};

const fetchWorkingTimes = async () => {
  try {
    const token = localStorage.getItem('token');
    const response = await axios.get('/api/working-times', {
      headers: { Authorization: `Bearer ${token}` },
    });
    days.value = response.data; // Assuming the API returns the days data in the expected format
  } catch (error) {
    console.error('Error fetching working times:', error);
  }
};

const addWorkingTime = async () => {
  const token = localStorage.getItem('token');
  try {
    await axios.post('/api/workingtime', selectedDay.value, {
      headers: { Authorization: `Bearer ${token}` },
    });
    fetchWorkingTimes(); 
    addWorkingTimesDialog.value.close();
  } catch (error) {
    console.error('Error adding working time:', error);
  }
};

const editWorkingTime = async () => {
  const token = localStorage.getItem('token');
  try {
    await axios.put(`/api/working-times/${selectedDay.value.date}`, selectedDay.value, { // Make sure to send the correct ID
      headers: { Authorization: `Bearer ${token}` },
    });
    fetchWorkingTimes(); 
    editWorkingTimesDialog.value.close();
  } catch (error) {
    console.error('Error editing working time:', error);
  }
};

const deleteWorkingTime = async () => {
  const token = localStorage.getItem('token');
  try {
    await axios.delete(`/api/working-times/${selectedDay.value.date}`, {
      headers: { Authorization: `Bearer ${token}` },
    });
    fetchWorkingTimes(); // Refresh the list after deletion
    deleteWorkingTimesDialog.value.close();
  } catch (error) {
    console.error('Error deleting working time:', error);
  }
};

const confirmEdit = (day) => {
  selectedDay.value = { ...day }; 
  editWorkingTimesDialog.value.showModal(); // Ensure this is set correctly
};

const confirmDelete = (day) => {
  selectedDay.value = day; 
  deleteWorkingTimesDialog.value.showModal(); // Ensure this is set correctly
};

onMounted(() => {
  generateWorkingDays();
  fetchWorkingTimes(); // Fetch working times 
});
</script>

<template>
  <div class="mb-4 mx-4">
    <div>
      <div class="border rounded-xl h-96">
        <GanttChart />
        <div class="grid grid-cols-3 gap-2 m-2 mt-11 justify-end items-center">
          <button class="btn" @click="addWorkingTimesDialog.value.showModal()">
            <v-icon name="fa-plus" />
          </button>
          <button class="btn" @click="editWorkingTimesDialog.value.showModal()">
            <v-icon name="fa-edit" />
          </button>
          <button class="btn" @click="deleteWorkingTimesDialog.value.showModal()">
            <v-icon name="fa-trash" />
          </button>
        </div>
      </div>

      <dialog ref="addWorkingTimesDialog" class="modal">
        <form @submit.prevent="addWorkingTime">
          <button type="button" class="btn btn-sm btn-circle btn-ghost absolute right-2 top-2" @click="addWorkingTimesDialog.value.close()">✕</button>
        </form>
      </dialog>

      <dialog ref="editWorkingTimesDialog" class="modal">
        <div class="modal-box w-11/12 max-w-5xl">
          <form @submit.prevent="editWorkingTime">
            <button type="button" class="btn btn-sm btn-circle btn-ghost absolute right-2 top-2" @click="editWorkingTimesDialog.value.close()">✕</button>
            <div class="overflow-x-auto">
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
                    <td><button type="button" class="btn btn-warning" @click="confirmEdit(day)"><v-icon name="fa-edit" /></button></td>
                  </tr>
                </tbody>
              </table>
            </div>
          </form>
        </div>
      </dialog>

      <dialog ref="deleteWorkingTimesDialog" class="modal">
        <div class="modal-box">
          <form @submit.prevent="deleteWorkingTime">
            <button type="button" class="btn btn-sm btn-circle btn-ghost absolute right-2 top-2" @click="deleteWorkingTimesDialog.value.close()">✕</button>
          </form>
          <div class="overflow-x-auto">
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
                  <td><button type="button" class="btn btn-danger" @click="confirmDelete(day)"><v-icon name="fa-trash" /></button></td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </dialog>
    </div>
  </div>
</template>
