import { createApp } from 'vue';
import App from './App.vue';
import './assets/tailwind.css';
import ganttastic from '@infectoone/vue-ganttastic';
import { OhVueIcon, addIcons } from "oh-vue-icons";
import * as FaIcons from "oh-vue-icons/icons/fa";
import VueApexCharts from 'vue3-apexcharts';
import router from './router';


addIcons(...Object.values(FaIcons));

const app = createApp(App)
    .use(ganttastic)
    .use(VueApexCharts)
    .component("v-icon", OhVueIcon)
    .use(router);

app.mount('#app');
