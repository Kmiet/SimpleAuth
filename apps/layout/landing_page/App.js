import React, { Fragment } from 'react'
import { BrowserRouter as Router, Link, Route, Switch, Redirect } from 'react-router-dom'

import Button from '../components/Button'
import Footer from '../components/Footer'
import NavBar from '../components/NavBar'
import Hero from './Hero'

export default class App extends React.Component {
  constructor() {
    super()

  }

  render() {
    return (
      <Router>
        <Fragment>
          <NavBar>
            {/*
            <Link to="/">Features</Link>
            <Link to="/">Pricing</Link>
            <Link to="/">Docs</Link>
            */}
            <Link to="https://accounts.simpleauth.org/login">
              <Button id="login-button" text="Login"/>
            </Link>
            <Link to="https://accounts.simpleauth.org/login">
              <Button id="signup-button" text="Sign up"/>
            </Link>
          </NavBar>
          <Hero />
          <Footer>
            <img src="" />
            2019 SimpleAuth
          </Footer>
        </Fragment>
      </Router>
    )
  }
}