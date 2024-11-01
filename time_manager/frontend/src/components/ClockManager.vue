<script>
import { ref } from 'vue';

export default {
  setup() {
    const currentMonth = ref(new Date());
    const days = ref([
      { name: 'Monday' },
      { name: 'Tuesday' },
      { name: 'Wednesday' },
      { name: 'Thursday' },
      { name: 'Friday' },
      { name: 'Saturday' },
      { name: 'Sunday' },
    ]);

    const prevMonth = () => {
      currentMonth.value.setMonth(currentMonth.value.getMonth() - 1);
    };

    const nextMonth = () => {
      currentMonth.value.setMonth(currentMonth.value.getMonth() + 1);
    };

    const getDaysInMonth = (year, month) => {
      return new Date(year, month + 1, 0).getDate(); // Get the last day of the month
    };

    return {
      currentMonth,
      days,
      prevMonth,
      nextMonth,
      getDaysInMonth,
    };
  }
};
</script>

<template>
  <div class="calendar-container flex flex-col my-4 mr-4">
    <div class="header flex justify-between items-center mb-4">
      <button @click="prevMonth" class="text-sm">
        <span>&lt;</span> <!-- Left arrow -->
      </button>
      <span class="font-bold">
        {{ currentMonth.toLocaleString('default', { month: 'long', year: 'numeric' }) }}
      </span>
      <button @click="nextMonth" class="text-sm">
        <span>&gt;</span> <!-- Right arrow -->
      </button>
    </div>
    
    <div class="days grid grid-cols-7 gap-2 mb-2">
      <div v-for="day in days" :key="day.name" class="font-bold text-center">
        {{ day.name }}
      </div>
    </div>
    
    <div class="dates grid grid-cols-7 gap-2">
      <div v-for="n in getDaysInMonth(currentMonth.getFullYear(), currentMonth.getMonth())" :key="n" class="text-center">
        <span class="block">{{ n }}</span>
      </div>
    </div>
  </div>
</template>

<style scoped>
.calendar-container {
  max-width: 400px; /* Adjust the width as necessary */
}

.header {
  padding: 10px; /* Add some padding for better appearance */
}

.days,
.dates {
  margin-top: 10px; /* Add margin to separate header and days */
}
</style>
























<!-- <script>
import { ref, onMounted } from 'vue';
export default {
  setup() {
    const time = ref('00:00:00.000');
    const timeBegan = ref(null);
    const timeStopped = ref(null);
    const stoppedDuration = ref(0);
    const started = ref(null);
    const running = ref(false);
    const days = ref([
      { name: 'Monday' },
      { name: 'Tuesday' },
      { name: 'Wednesday' },
      { name: 'Thursday' },
      { name: 'Friday' }
    ]);
    const start = () => {
      if (running.value) return;
      if (timeBegan.value === null) {
        reset();
        timeBegan.value = new Date();
      }
      if (timeStopped.value !== null) {
        stoppedDuration.value += new Date() - timeStopped.value;
      }
      started.value = setInterval(clockRunning, 10);
      running.value = true;
    };
    const stop = () => {
      running.value = false;
      timeStopped.value = new Date();
      clearInterval(started.value);
    };
    const reset = () => {
      running.value = false;
      clearInterval(started.value);
      stoppedDuration.value = 0;
      timeBegan.value = null;
      timeStopped.value = null;
      time.value = '00:00:00.000';
    };
    const clockRunning = () => {
      const currentTime = new Date();
      const timeElapsed = new Date(currentTime - timeBegan.value - stoppedDuration.value);
      const hour = timeElapsed.getUTCHours();
      const min = timeElapsed.getUTCMinutes();
      const sec = timeElapsed.getUTCSeconds();
      const ms = timeElapsed.getUTCMilliseconds();
      time.value = `${zeroPrefix(hour, 2)}:${zeroPrefix(min, 2)}:${zeroPrefix(sec, 2)}.${zeroPrefix(ms, 3)}`;
    };
    const zeroPrefix = (num, digit) => {
      return String(num).padStart(digit, '0');
    };
    onMounted(() => {
      // Any additional initialization if needed
    });
    return {
      time,
      days,
      start,
      stop,
      reset
    };
  }
};
</script>

<template>
  <div class="flex my-4 mr-4">
    <div>
      <div class="flex border rounded-xl stats-vertical h-full w-full">
        <div class="stat flex items-center">
          <div id="clock">
            <div class="bg-gray-100 h-52 w-52 rounded-full flex justify-center items-center mb-4">
              <span class="time">{{ time }}</span>
            </div>
            <div class="flex gap-2">
              <button @click="start" class="btn btn-accent">Start</button>
              <button @click="stop" class="btn btn-secondary">Stop</button>
              <button @click="reset" class="btn btn-warning">Reset</button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template> -->