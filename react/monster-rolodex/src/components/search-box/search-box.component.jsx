import {Component} from "react";


class SearchBox extends Component {

    render() {
        return (
            <input
                type='search'
                className={this.props.className}
                placeholder={this.props.placeholder}
                onChange={this.props.onChange}
            />
        );
    }
}

export default SearchBox;