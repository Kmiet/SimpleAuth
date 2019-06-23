import React, { Fragment } from 'react'
import { BrowserRouter as Router, Link, Route, Switch, Redirect } from 'react-router-dom'
import axios from 'axios'

import Footer from '../components/Footer'
import AppBar from './AppBar';
import ClientView from './ClientView';
import HomeView from './HomeView';
import ProfileView from './ProfileView';

export default class App extends React.Component {
  constructor() {
    super()
    this.state = {}
    this.onLogout = this.onLogout.bind(this)
  }

  async componentWillMount() {
    // if(this.state.user === undefined) 
    //   await this._preloadUserInfo()
    // if(this.state.clients === undefined)
    //   await this._preloadClientsInfo()
    this.setState({ user: { id: 'X-Y-Z', username: 'John Smith' }, clients: [{
      id: 123,
      name: 'App 1',
      desc: 'First App',
      logo: 'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c2/Adobe_XD_CC_icon.svg/1050px-Adobe_XD_CC_icon.svg.png'
    },{
      id: 123,
      name: 'App 2',
      desc: 'Second App',
      logo: 'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c2/Adobe_XD_CC_icon.svg/1050px-Adobe_XD_CC_icon.svg.png'
    },{
      id: 123,
      name: 'App 3',
      desc: 'Third App',
      logo: 'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c2/Adobe_XD_CC_icon.svg/1050px-Adobe_XD_CC_icon.svg.png'
    }] })
  }

  onLogout() {
    
  }

  _preloadUserInfo() {
    axios.get('http://localhost:4000/userinfo').then(data => {
      this.setState({ user: data })
    }).catch(err => {
      window.location.replace('http://localhost:4000/')
    })
  }

  _preloadClientsInfo() {
    axios.get('http://localhost:4000/user/' + this.state.user.id + '/clients').then(data => {
      this.setState({ clients: data })
    }).catch(err => {
      window.location.replace('http://localhost:4000/')
    })
  }

  render() { 
    return (
      <Router>
        <Fragment>
          <AppBar user={this.state.user} onLogout={this.onLogout} currentClient={this.state.currentClient} />
          <Switch>
            <Route path="/apps/:app_id" component={ClientView} />
            <Route path="/apps" render={() => <HomeView clients={this.state.clients} />} />
            <Route path="/profile" render={() => (<ProfileView clients={this.state.clients} />)} />
            <Route path="/settings" render={() => (<ProfileView clients={this.state.clients} />)} />
            <Route path="/" render={() => (<HomeView clients={this.state.clients} />)} />
          </Switch>
        </Fragment>
      </Router>
    )
  }
}