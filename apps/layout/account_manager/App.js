import React, { Fragment } from 'react'
import { BrowserRouter as Router, Link, Route, Switch, Redirect } from 'react-router-dom'

import Button from '../components/Button'
import Footer from '../components/Footer'
import NavBar from '../components/NavBar'

export default class App extends React.Component {
  constructor() {
    super()
    this.state = {
      user: {
        firstName: window._INITIAL_DATA.firstName,
        lastName: window._INITIAL_DATA.lastName
      }
    }
  }

  render() {
    return (
      <Router>
        <Fragment>
        </Fragment>
      </Router>
    )
  }
}