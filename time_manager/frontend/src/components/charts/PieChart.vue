<script>
import axios from 'axios';
import { ref, onMounted } from 'vue';
import ApexCharts from 'apexcharts';

export default {
  setup() {
    const series = ref([]);
    const chartOptions = ref({
      chart: {
        type: "donut",
      },
      responsive: [
        {
          breakpoint: 480,
          options: {
            chart: {
              width: 200,
            },
            legend: {
              position: "bottom",
            },
          },
        },
      ],
    });

    const fetchData = async () => {
      try {
        const token = localStorage.getItem('token');
        const usersResponse = await axios.get(`http://localhost:4000/api/users`, {
          headers: {
            'Authorization': `Bearer ${token}`,
            'Content-Type': 'application/json',
          }
        });

        // Log the response data for debugging
        console.log('Users Response:', usersResponse.data);

        const users = Array.isArray(usersResponse.data) ? usersResponse.data : [];

        // Check if users is an array
        if (!Array.isArray(users)) {
          throw new Error('Unexpected data format: users is not an array');
        }

        const workingTimesPromises = users.map(user =>
          axios.get(`http://localhost:4000/api/workingtime/${user.id}`)
        );

        const workingTimesResponses = await Promise.all(workingTimesPromises);
        const workingTimesData = workingTimesResponses.map(response => response.data);

        // Flatten the working times data and extract working time
        series.value = workingTimesData.flat().map(entry => entry.workingTime);

        renderChart();  // Render the chart after fetching data
      } catch (error) {
        // Enhanced error handling
        console.error('Error fetching data:', error.message);
        if (error.response) {
          console.error('Server responded with a status other than 2xx:', error.response.status, error.response.data);
        } else if (error.request) {
          console.error('Request made but no response received:', error.request);
        }
      }
    };

    const renderChart = () => {
      const chart = new ApexCharts(document.querySelector("#pieChart"), {
        series: series.value,
        chart: chartOptions.value.chart,
        responsive: chartOptions.value.responsive,
        labels: series.value.map((_, index) => `User ${index + 1}`)
      });
      chart.render();
    };

    onMounted(fetchData);  

    return {
      series,
      chartOptions
    };
  }
};
</script>

<template>
  <div id="pieChart" class="w-full h-full flex justify-center items-center">
    <apexchart type="donut" :options="chartOptions" :series="series"></apexchart>
  </div>
</template>
