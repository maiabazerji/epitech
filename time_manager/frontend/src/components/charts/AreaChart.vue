<!-- <script setup>
import { ref, onMounted } from "vue";

const series = ref([]);

const chartOptions = ref({
  chart: {
    height: 350,
    type: "area",
  },
  dataLabels: {
    enabled: false,
  },
  stroke: {
    curve: "smooth",
  },
  colors: ["#4A00FF", "#FF00D3", "#00D7C0", "#FFBE00"],
  xaxis: {
    categories: ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"],
  },
  tooltip: {
    x: {
      format: "dd/MM/yy HH:mm",
    },
  },
});

const fetchWorkingTimes = async (userID) => {
  try {
    const token = localStorage.getItem('token');
    const response = await fetch(`http://localhost/api/workingtime/${userID}`, {
      method: 'GET',
      headers: {
        'Authorization': `Bearer ${token}`,
        'Content-Type': 'application/json',
      }
    });
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }
    const data = await response.json();

    if (data && Array.isArray(data.WorkingTime)) {
      series.value = data.WorkingTime.map(day => calculateWorkingHours(day));
    } else {
      series.value = [];
    }

  } catch (error) {
    console.error("Error fetching Working Hours:", error);
  }
  return(series);
};

onMounted(() => {
  const userID = localStorage.getItem('userID'); 
  // series = fetchWorkingTimes(userID);
  return fetchWorkingTimes(userID);
});

function calculateWorkingHours(day) {
  const [startHour, startMinute] = day.start.split(":").map(Number);
  const [endHour, endMinute] = day.end.split(":").map(Number);
  const startTime = startHour + startMinute / 60;
  const endTime = endHour + endMinute / 60;
  return endTime - startTime;
}

</script>

<template>
  <div id="chart">
    <apexchart type="area" height="350" :options="chartOptions" :series="series"></apexchart>
  </div>
</template> -->
