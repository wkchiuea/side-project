import logo from './logo.svg';
import './App.css';
import {Component} from "react";

class App extends Component {

  constructor() {
    super();

    this.state = {
      name: "hehe"
    }
  }

  render() {
    return (
        <div className="App">
          <header className="App-header">
            <img src={logo} className="App-logo" alt="logo" />
            <p>Hi, I'm {this.state.name}</p>
            <button onClick={() => {
              this.setState(
                  (state, props) => {
                    return {
                      name: "Hoho"
                    }
                  },
                  () => {
                    console.log(this.state.name);
                  }
              )
            }}>Change Name</button>
          </header>
        </div>
    );
  }
}

export default App;
