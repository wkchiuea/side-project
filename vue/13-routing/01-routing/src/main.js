import { createApp } from 'vue';

import App from './App.vue';
import {createRouter, createWebHistory} from "vue-router";
import TeamsList from "./components/teams/TeamsList.vue";
import UsersList from "./components/users/UsersList.vue";
import TeamMembers from "@/components/teams/TeamMembers.vue";

const router = createRouter({
  history: createWebHistory(),
  routes: [
    { path: "/", redirect: "/teams" },
    { path: "/teams", component: TeamsList,
      children: [
        { path: ":teamId", component: TeamMembers, props: true },
      ]},
    { path: "/users", component: UsersList },
    { path: "/:notFound(.*)", redirect: "/teams" }
  ],
  // linkActiveClass: "changeActiveClassName"
});

const app = createApp(App)

app.use(router);

app.mount('#app');
