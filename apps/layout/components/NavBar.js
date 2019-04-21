import React, { Fragment } from 'react'
import { BrowserRouter as Router, Link, Route, Switch, Redirect } from 'react-router-dom'

import Button from '../components/Button'
import Footer from '../components/Footer'
import Logo from '../components/Logo'

export default class NavBar extends React.Component {
  constructor(props) {
    super()
    this.state = { showSideNav: false }
    this.toggleSideNav = this.toggleSideNav.bind(this)
  }

  toggleSideNav() {
    this.setState({ showSideNav: !this.state.showSideNav })
  }

  render() {
    return (
      <div id="navbar">
        {this.props.logo}
        <div style={{flex: 1}}></div>
        <nav>
          {this.props.children}
        </nav>
        <div id="hamburger" onClick={this.toggleSideNav}>
          <span></span>
          <span></span>
          <span></span>
        </div>
        {this.state.showSideNav ? (
          <nav id="sidenav">
            {this.props.children}
          </nav>
        ) : ""}
      </div>
    )
  }
}