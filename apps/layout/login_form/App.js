import React, { Fragment } from 'react'
import { BrowserRouter as Router, Link, Route, Switch, Redirect } from 'react-router-dom'
import LoginForm from './LoginForm'
import SignupForm from './SignupForm'
import Footer from '../components/Footer'
import Logo from '../components/Logo'
import ForgotPasswordForm from './ForgotPasswordForm';

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
            <Route path="/signup" component={SignupForm} />
            <Route path="/forgot-password" component={ForgotPasswordForm} />
            <Redirect from="/" to="/login" />
          </Switch>
          <Footer>
            2019 SimpleAuth
          </Footer>
        </Fragment>
      </Router>
    )
  }
}