import logo from './logo.svg';
import './App.css';
import {Component} from "react";

class App extends Component {

  constructor() {
    super();

    this.state = {
      monsters: [
        {id: 1, name: "Linda"},
        {id: 2, name: "Hehe"},
        {id: 3, name: "Archer"},
        {id: 4, name: "Hoho"},
      ]
    }
  }

  render() {
    return <div className="App">
      {this.state.monsters.map(monster =>
          <div key={monster.id}>
            <h1>{monster.name}</h1>
          </div>
      )}
    </div>;
  }
}

export default App;
