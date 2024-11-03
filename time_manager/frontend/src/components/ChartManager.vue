<script setup>
import { ref } from 'vue';
import PieChart from './charts/PieChart.vue';
import RadialChart from './charts/RadialChart.vue';
import PolarChart from './charts/PolarChart.vue';

const selectedChart = ref('pie');
const userRole = ref('manager'); 
</script>

<template>
  <div v-if="userRole === 'manager'" class="w-full border my-4 mr-4 rounded-xl flex items-center justify-center">
    <div>
      <div class="flex">
        <div v-if="selectedChart === 'pie'" class="w-96">
          <PieChart />
        </div>
        <div v-if="selectedChart === 'radial'" class="w-[242px]">
          <RadialChart />
        </div>
        <div v-if="selectedChart === 'polar'" class="w-96">
          <PolarChart />
        </div>
      </div>
      <div class="flex gap-2 justify-center pt-6">
        <button @click="selectedChart = 'pie'" class="btn btn-primary">Pie Chart</button>
        <button @click="selectedChart = 'radial'" class="btn btn-primary">Radial Chart</button>
        <button @click="selectedChart = 'polar'" class="btn btn-primary">Polar Chart</button>
      </div>
    </div>
  </div>
</template>
