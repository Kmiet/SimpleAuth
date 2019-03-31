import React, { Fragment } from 'react'
import { BrowserRouter as Router, Link, Route, Switch } from 'react-router-dom'
import LoginForm from './LoginForm';
import Footer from '../components/Footer';
import Logo from '../components/Logo';

export default class App extends React.Component {
  constructor() {
    super()

  }

  render() {
    return (
      <Router>
        <Fragment>
          <Switch>
            <Route path="/login" component={LoginForm} />
            <Route path="/signup" component={LoginForm} />
            <Route path="/forgot-password" component={LoginForm} />
            <Route exact path="/" component={LoginForm} />
            <Route path="/" component={LoginForm} />
          </Switch>
          <Footer>
          </Footer>
        </Fragment>
      </Router>
    )
  }
}