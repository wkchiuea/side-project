import logo from './logo.svg';
import './App.css';
import {useEffect, useState} from "react";
import CardList from "./components/card-list/card-list.component.jsx";
import SearchBox from "./components/search-box/search-box.component";


const App = () => {

    const [searchField, setSearchField] = useState(''); // [value, setValue]
    const [monsters, setMonsters] = useState([]);
    const [filteredMonsters, setFilteredMonsters] = useState(monsters);

    useEffect(() => {
        fetch("https://jsonplaceholder.typicode.com/users")
            .then(response => response.json())
            .then(users => setMonsters(users));
    }, []);

    useEffect(() => {
        const newFilteredMonsters = monsters.filter(monster => {
            return monster.name.toLocaleLowerCase().includes(searchField);
        });

        setFilteredMonsters(newFilteredMonsters);
    }, [monsters, searchField]);

    const onSearchChange = (event) => {
        const searchFieldStr = event.target.value.toLocaleLowerCase();
        setSearchField(searchFieldStr);
    };


    return (
        <div className="App">
            <h2 className="app-title">Haha</h2>
            {/*<SearchBox className='search-box' placeholder='search monsters' onChange={onSearchChange}/>*/}
            {/*<CardList monsters={filteredMonsters} />*/}
        </div>
    );

}


// class App extends Component {
//
//   constructor() {
//     super();
//
//     this.state = {
//       monsters: [],
//       searchField: ''
//     }
//   }
//

//

//
//   render() {
//
//     const {monsters, searchField} = this.state;
//     const {onSearchChange} = this;
//

//

//   }
// }

export default App;
