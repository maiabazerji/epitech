<script setup>
import { ref, onMounted } from "vue";
const daysOfWeekbar = ref([]);
const userData = ref([]); 

// Generate days of the week from Monday to Friday with their dates
onMounted(() => {
  const today = new Date();
  const dayOfWeek = today.getDay(); // 0 (Sunday) to 6 (Saturday)
  const monday = new Date(today);
  monday.setDate(today.getDate() - dayOfWeek + 1); // Adjust to Monday

  for (let i = 0; i < 5; i++) {
    const day = new Date(monday);
    day.setDate(monday.getDate() + i);
    daysOfWeekbar.value.push({
      day: day.toLocaleDateString('en-US', { weekday: 'long' }),
      date: day.toISOString().split('T')[0]
    });
  }
});

// Function to update the Gantt bars and area chart data
function updateBarsAndSeries() {
  daysOfWeekbar.value = userData.value.map(user => ({
    myBeginDate: user.workingTimes.daysOfWeek.start ? new Date().toISOString().split('T')[0] + ' ' + user.workingTimes.start : null,
    myEndDate: user.workingTimes.daysOfWeek.end ? new Date().toISOString().split('T')[0] + ' ' + user.workingTimes.end : null,
  }));
}

onMounted(() => {
  updateBarsAndSeries();
});
</script>

<template>
  <g-gantt-chart
    :chart-start="new Date().toISOString().split('T')[0] + ' 00:00'"
    :chart-end="new Date().toISOString().split('T')[0] + ' 23:59'"
    precision="hour"
    bar-start="myBeginDate"
    bar-end="myEndDate"
  >
    <g-gantt-row label="Monday" :bars="daysOfWeekbar" />
    <g-gantt-row label="Tuesday" :bars="daysOfWeekbar" />
    <g-gantt-row label="Wednesday" :bars="daysOfWeekbar" />
    <g-gantt-row label="Thursday" :bars="daysOfWeekbar" />
    <g-gantt-row label="Friday" :bars="daysOfWeekbar" />
  </g-gantt-chart>
</template>