<script setup>
import { ref, onMounted } from "vue";
import axios from "axios";

const series = ref([]);
const radialChartOptions = ref({
  chart: {
    height: 100,
    type: 'radialBar',
  },
  plotOptions: {
    radialBar: {
      dataLabels: {
        name: {
          fontSize: '22px',
        },
        value: {
          fontSize: '16px',
        },
        total: {
          show: false,
          label: 'Total',
        },
      },
    },
  },
  labels: [],
});

const calculateTotalWorkingTime = (workingTimes) => {
  const totalWorkingTime = workingTimes.reduce((acc, curr) => acc + curr.time, 0);
  return workingTimes.map((entry) => ({
    userId: entry.userId,
    percentage: ((entry.time / totalWorkingTime) * 100).toFixed(2),
  }));
};

const fetchData = async () => {
  try {
    const token = localStorage.getItem('token');
    const usersResponse = await axios.get('http://localhost/api/users', {
      headers: {
        Authorization: `Bearer ${token}`
      }
    });

    if (!Array.isArray(usersResponse.data)) {
      throw new TypeError('Expected an array of users');
    }
    
    const users = usersResponse.data;

    const workingTimesPromises = users.map(user =>
      axios.get(`http://localhost/api/workingtime/${user.id}`, {
        headers: {
          Authorization: `Bearer ${token}`
        }
      })
    );

    const workingTimesResponses = await Promise.all(workingTimesPromises);
    const workingTimes = workingTimesResponses.map(response => response.data).flat();

    const percentageWorkingTimes = calculateTotalWorkingTime(workingTimes);

    const userIdToUsername = (userId) => {
      const user = users.find(user => user.id === userId);
      return user ? user.username : 'Unknown';
    };

    const labels = percentageWorkingTimes.map(entry => userIdToUsername(entry.userId));

    series.value = percentageWorkingTimes.map(entry => parseFloat(entry.percentage));
    radialChartOptions.value.labels = labels;

  } catch (error) {
    console.error('Error fetching data:', error);
  }
};

onMounted(fetchData);
</script>

<template>
  <div id="chart" class="w-full h-full flex justify-center items-center">
    <apexchart type="radialBar" :options="radialChartOptions" :series="series"></apexchart>
  </div>
</template>
