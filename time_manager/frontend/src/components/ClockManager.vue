<script>
import { ref, watch } from 'vue';
import axios from 'axios';

export default {
  props: {
    userId: {
      type: String,
      required: true,
    },
  },
  setup(props) {
    const currentMonth = ref(new Date());
    const days = ref([
      { name: 'Sun', isWeekday: false },
      { name: 'Mon', isWeekday: true },
      { name: 'Tue', isWeekday: true },
      { name: 'Wed', isWeekday: true },
      { name: 'Thu', isWeekday: true },
      { name: 'Fri', isWeekday: true },
      { name: 'Sat', isWeekday: false },
    ]);

    const showModal = ref(false);
    const selectedDate = ref(null);
    const workingTimeId = ref(null);
    const startTime = ref('');
    const endTime = ref('');

    const prevMonth = () => {
      currentMonth.value.setMonth(currentMonth.value.getMonth() - 1);
      currentMonth.value = new Date(currentMonth.value);
    };

    const nextMonth = () => {
      currentMonth.value.setMonth(currentMonth.value.getMonth() + 1);
      currentMonth.value = new Date(currentMonth.value);
    };

    const getDaysInMonth = (year, month) => {
      const date = new Date(year, month, 1);
      const daysInMonth = [];
      const firstDayOfWeek = date.getDay();

      // Fill with empty slots for the days before the first of the month
      for (let i = 0; i < firstDayOfWeek; i++) {
        daysInMonth.push(null);
      }

      while (date.getMonth() === month) {
        daysInMonth.push(new Date(date));
        date.setDate(date.getDate() + 1);
      }

      return daysInMonth;
    };

    const daysInCurrentMonth = ref(getDaysInMonth(currentMonth.value.getFullYear(), currentMonth.value.getMonth()));

    const handleDayClick = (day) => {
      if (day && day.getDay() !== 0 && day.getDay() !== 6) { // Only weekdays
        selectedDate.value = day;
        showModal.value = true;
      }
    };

    const saveWorkingTime = async () => {
      try {
        if (workingTimeId.value) {
          const response = await axios.put(`/api/workingtime/${workingTimeId.value}`, {
            date: selectedDate.value.toISOString().split('T')[0],
            startTime: startTime.value,
            endTime: endTime.value,
          });
          console.log('Successfully updated working time:', response.data);
        } else {
          const response = await axios.post(`/api/workingtime/${props.userId}`, {
            date: selectedDate.value.toISOString().split('T')[0],
            startTime: startTime.value,
            endTime: endTime.value,
          });
          workingTimeId.value = response.data.id; 
          console.log('Successfully created working time:', response.data);
        }
      } catch (error) {
        console.error('Error saving working time:', error.response ? error.response.data : error.message);
      } finally {
        closeModal();
      }
    };

    const closeModal = () => {
      showModal.value = false;
      selectedDate.value = null;
      startTime.value = '';
      endTime.value = '';
      workingTimeId.value = null; // Reset the ID after closing
    };

    watch(currentMonth, () => {
      daysInCurrentMonth.value = getDaysInMonth(currentMonth.value.getFullYear(), currentMonth.value.getMonth());
    });

    return {
      currentMonth,
      days,
      daysInCurrentMonth,
      prevMonth,
      nextMonth,
      showModal,
      selectedDate,
      startTime,
      endTime,
      handleDayClick,
      saveWorkingTime,
      closeModal,
    };
  },
};
</script>

<template>
  <div class="calendar-container" style="max-width: 500px; margin: 20px auto; padding: 20px; border: 1px solid #ddd; border-radius: 8px; box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1); background-color: #fff; font-family: Arial, sans-serif;">
    <div class="header" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px; font-size: 1.5em; font-weight: bold; color: #333;">
      <button @click="prevMonth" class="nav-button" style="background: none; border: none; font-size: 1.5em; color: #007bff; cursor: pointer; transition: color 0.3s;">&lt;</button>
      <span style="font-weight: bold; color: #333;">{{ currentMonth.toLocaleString('default', { month: 'long', year: 'numeric' }) }}</span>
      <button @click="nextMonth" class="nav-button" style="background: none; border: none; font-size: 1.5em; color: #007bff; cursor: pointer; transition: color 0.3s;">&gt;</button>
    </div>

    <div class="days" style="display: grid; grid-template-columns: repeat(7, 1fr); gap: 8px;">
      <div v-for="day in days" :key="day.name" :style="day.isWeekday ? 'background-color: #e3f2fd; color: #333; text-align: center; font-weight: bold; padding: 8px 0;' : 'background-color: #ffebee; color: #333; text-align: center; font-weight: bold; padding: 8px 0;'">{{ day.name }}</div>
    </div>

    <div class="dates" style="display: grid; grid-template-columns: repeat(7, 1fr); gap: 8px;">
      <div
        v-for="(day, index) in daysInCurrentMonth"
        :key="index"
        :style="day === null
          ? 'background-color: #f0f0f0; color: transparent; text-align: center; padding: 10px 0; border-radius: 4px;'
          : (day.getDay() === 0 || day.getDay() === 6
              ? 'background-color: #ffebee; color: #666; text-align: center; padding: 10px 0; border-radius: 4px; cursor: not-allowed;'
              : 'background-color: #d9ead3; text-align: center; padding: 10px 0; border-radius: 4px; cursor: pointer; transition: background-color 0.3s, color 0.3s;')"
        @click="day && day.getDay() !== 0 && day.getDay() !== 6 ? handleDayClick(day) : null"
      >
        {{ day ? day.getDate() : '' }}
      </div>
    </div>

    <!-- Modal for Working Time -->
<!-- Modal for Working Time -->
    <div v-if="showModal" class="modal-overlay" style="position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0, 0, 0, 0.5); display: flex; align-items: flex-start; justify-content: flex-start;">
      <div class="modal-content" style="background: #fff; padding: 20px; border-radius: 8px; width: 300px; text-align: center; margin: 20px; position: absolute; left: 0;"> <!-- Align to left -->
        <h3 style="margin-bottom: 10px;">Manage Working Time</h3>
        <p style="margin-bottom: 10px;">{{ selectedDate.toLocaleDateString() }}</p>
        <input v-model="startTime" type="time" placeholder="Start Time" class="input-field" style="width: 100%; padding: 8px; margin-top: 10px;" />
        <input v-model="endTime" type="time" placeholder="End Time" class="input-field" style="width: 100%; padding: 8px; margin-top: 10px;" />
        <div class="modal-buttons" style="display: flex; justify-content: space-between; margin-top: 15px;">
          <button @click="saveWorkingTime" style="background-color: #28a745; color: #fff; padding: 8px 16px; border: none; border-radius: 4px; cursor: pointer;">Save</button>
          <button @click="closeModal" style="background-color: #6c757d; color: #fff; padding: 8px 16px; border: none; border-radius: 4px; cursor: pointer;">Close</button>
        </div>
      </div>
    </div>
  </div>
</template>
