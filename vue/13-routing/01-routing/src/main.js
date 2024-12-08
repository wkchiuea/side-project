import { createApp } from 'vue';

import App from './App.vue';
import {createRouter, createWebHistory} from "vue-router";
import TeamsList from "./components/teams/TeamsList.vue";
import UsersList from "./components/users/UsersList.vue";
import TeamMembers from "@/components/teams/TeamMembers.vue";
import TeamsFooter from "@/components/teams/TeamsFooter.vue";
import UserFooter from "@/components/users/UserFooter.vue";

const router = createRouter({
  history: createWebHistory(),
  routes: [
    { path: "/", redirect: "/teams" },
    { path: "/teams", components: {default: TeamsList, footer: TeamsFooter},
      meta: {needsAuth: true},
      name: "teams",
      children: [
        { name: "team-members", path: ":teamId", component: TeamMembers, props: true },
      ]},
    { path: "/users", components: {default: UsersList, footer: UserFooter},
      beforeEnter(to, from, next) {
        next();
      }
    },
    { path: "/:notFound(.*)", redirect: "/teams" }
  ],
  // linkActiveClass: "changeActiveClassName"
  scrollBehavior(to, from, savedPosition) {
    if (savedPosition) {
      return savedPosition;
    }
    return {left: 0, top: 0};
  }
});

router.beforeEach(function(to, from , next) {
  next();
  // next(false);
  // next("/users");
  // if (to.name === "team-members") {
  //   next();
  // } else {
  //   next({name: "team-members", params: {teamId: "t2"}});
  // }
  if (to.meta.needsAuth) {

  }
});

router.afterEach(function(to, from) {
  // sending analytics data to server
});

const app = createApp(App)

app.use(router);

app.mount('#app');
