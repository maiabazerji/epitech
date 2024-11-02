<template>
  <div id="polarChart" class="w-full h-full flex justify-center items-center">
    <apexchart type="polarArea" :options="chartOptions" :series="series"></apexchart>
  </div>
</template>

<script>
import axios from 'axios';
import { ref, onMounted } from 'vue';
import ApexCharts from 'apexcharts';

export default {
  setup() {
    const series = ref([]);
    const chartOptions = ref({
      chart: {
        type: 'polarArea',
      },
      responsive: [
        {
          breakpoint: 480,
          options: {
            chart: {
              width: 200,
            },
            legend: {
              position: 'bottom',
            },
          },
        },
      ],
    });

    const fetchData = async () => {
      try {
        const token = localStorage.getItem('token');
        const usersResponse = await axios.get(`http://localhost/api/users`, {
          headers: {
            'Authorization': `Bearer ${token}`,
            'Content-Type': 'application/json',
          },
        });

        console.log('Users Response:', usersResponse.data);

        const users = Array.isArray(usersResponse.data) ? usersResponse.data : [];

        if (!Array.isArray(users)) {
          throw new Error('Unexpected data format: users is not an array');
        }

        const workingTimesPromises = users.map(user =>
          axios.get(`http://localhost/api/workingtime/${user.id}`)
        );

        const workingTimesResponses = await Promise.all(workingTimesPromises);
        const workingTimesData = workingTimesResponses.map(response => response.data);

        // Set series data, default to [0] if empty
        series.value = workingTimesData.flat().map(entry => entry.workingTime) || [0];

        console.log('Series Data:', series.value); // Log series data for debugging

        renderChart();  // Render the chart after fetching data
      } catch (error) {
        console.error('Error fetching data:', error.message);
        if (error.response) {
          console.error('Server responded with a status other than 2xx:', error.response.status, error.response.data);
        } else if (error.request) {
          console.error('Request made but no response received:', error.request);
        }
      }
    };

    const renderChart = () => {
      // Create chart only if there are valid series data
      if (series.value.length > 0) {
        const chart = new ApexCharts(document.querySelector("#polarChart"), {
          series: series.value,
          chart: chartOptions.value.chart,
          responsive: chartOptions.value.responsive,
        });
        chart.render();
      } else {
        console.error('No valid series data to render the chart');
      }
    };

    onMounted(fetchData);

    return {
      series,
      chartOptions
    };
  }
};
</script>
