import logo from './logo.svg';
import './App.css';
import {Component} from "react";

class App extends Component {

  constructor() {
    super();

    this.state = {
      monsters: [],
      searchField: ''
    }
  }

  componentDidMount() {
    fetch("https://jsonplaceholder.typicode.com/users")
        .then(response => response.json())
        .then(users => this.setState({monsters: users}, () => console.log(this.state.monsters)));
  }

  onSearchChange = (event) => {
    const searchField = event.target.value.toLocaleLowerCase();
    return this.setState(() => {
      return {searchField};
    });
  };

  render() {

    const {monsters, searchField} = this.state;
    const {onSearchChange} = this;

    const filteredMonsters = monsters.filter(monster => {
      return monster.name.toLocaleLowerCase().includes(searchField);
    })

    return (
        <div className="App">
          <input className='search-box' type='search' placeholder='search monsters'
                 onChange={onSearchChange}
          />
          {filteredMonsters.map(monster =>
              <div key={monster.id}>
                <h1>{monster.name}</h1>
              </div>
          )}
        </div>
    );
  }
}

export default App;
