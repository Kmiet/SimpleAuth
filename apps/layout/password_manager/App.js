import React, { Fragment } from 'react'
import { BrowserRouter as Router, Link, Route, Switch, Redirect } from 'react-router-dom'

import Button from '../components/Button'
import Footer from '../components/Footer'
import SetNewPasswd from './SetNewPasswd'
import NavBar from '../components/NavBar'

export default class App extends React.Component {
  constructor() {
    super()

  }

  render() {
    return (
      <Router>
        <Fragment>
          <SetNewPasswd />
          <Footer>
            <img src="" />
            2019 SimpleAuth
          </Footer>
        </Fragment>
      </Router>
    )
  }
}