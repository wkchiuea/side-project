const app = Vue.createApp({
  data() {
    return {
      playerHealth: 100,
      monsterHealth: 100,
      currentRound: 1,
      winner: null,
      logMessages: []
    }
  },
  computed: {
    monsterBarStyles() {
      const val = Math.max(this.monsterHealth, 0);
      return {width: val + '%'};
    },
    playerBarStyles() {
      const val = Math.max(this.playerHealth, 0);
      return {width: val + '%'};
    },
    disableSP() {
      return this.currentRound % 3 !== 0;
    }
  },
  watch: {
    playerHealth(value) {
      if (value <= 0 && this.monsterHealth <= 0) {
        this.winner = "draw";
      } else if (value <= 0) {
        this.winner = "monster";
      }
    },
    monsterHealth(value) {
      if (value <= 0 && this.playerHealth <= 0) {
        this.winner = "draw";
      } else if (value <= 0) {
        this.winner = "player";
      }
    }
  },
  methods: {
    startGame() {
      this.playerHealth = 100;
      this.monsterHealth = 100;
      this.currentRound = 1;
      this.winner = null;
      this.logMessages = [];
    },
    attackMonster() {
      ++this.currentRound;
      const attackValue = getRandomValue(5, 12);
      this.monsterHealth -= attackValue;
      this.addLogMessage("Player", "Monster", attackValue)
      this.attackPlayer();
    },
    attackPlayer() {
      const attackValue = getRandomValue(8, 15);
      this.addLogMessage("Monster", "Player", attackValue)
      this.playerHealth -= attackValue;
    },
    specialAttack() {
      ++this.currentRound;
      const attackValue = getRandomValue(10, 25);
      this.monsterHealth -= attackValue;
      this.attackPlayer();
    },
    healPlayer() {
      ++this.currentRound;
      const healValue = getRandomValue(8, 20);
      this.playerHealth = Math.min(this.playerHealth + healValue, 100);
      this.attackPlayer();
    },
    surrend() {
      this.winner = "monster";
    },
    addLogMessage(who, what, val) {
      this.logMessages.unshift({
        actionBy: who,
        actionType: what,
        value: val
      });
    }
  }
});

function getRandomValue(min, max) {
  return Math.floor(Math.random() * (max - min)) + min;
}

app.mount("#game");