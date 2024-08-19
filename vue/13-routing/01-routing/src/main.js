import { createApp } from 'vue';

import App from './App.vue';
import {createRouter, createWebHistory} from "vue-router";
import TeamsList from "./components/teams/TeamsList.vue";
import UsersList from "./components/users/UsersList.vue";

const router = createRouter({
  history: createWebHistory(),
  routes: [
    { path: "/teams", components: TeamsList },
    { path: "/users", components: UsersList },
  ]
});

const app = createApp(App)

app.use(router);

app.mount('#app');
