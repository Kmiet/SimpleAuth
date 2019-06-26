import React from 'react'
import { Link } from 'react-router-dom'
import axios from 'axios'

import Form from '../components/Form'
import Input from '../components/Input'
import Button from '../components/Button'
import Divider from '../components/Divider'

export default class LoginForm extends React.Component {
  constructor() {
    super()
    this.state = {
      csrf_token: document.CSRF_TOKEN,
      disabledButton: true, 
      error: "", 
      email: "", 
      password: "" 
    }

    this.handleChange = this.handleChange.bind(this)
    this.handleSubmit = this.handleSubmit.bind(this)
  }

  handleChange(event) {
    //  error state - debug only
    if(this._isValid(event)) this.setState({ disabledButton: false, [event.target.name]: event.target.value })
    else this.setState({ disabledButton: true, [event.target.name]: event.target.value })
    console.log(this.state)
  }

  handleSubmit(event) {
    event.preventDefault()
    const login_uri = this._buildSubmitURI()
    axios.get(login_uri, {
      headers: {
        Authorization: this.state.email + " " + this.state.password + " " + this.state.csrf_token
      }
    }).then(response => {
      window.location.replace(response.headers.location)
    }).catch(err => {
      this.setState({ email: "", error: "Invalid email or password", password: "" })
    })
  }

  _isValid(event) {
    if(event.target.value.length > 7 && this._isEmailValid(this.state.email)) return true
    else if(this._isEmailValid(event.target.value) && this.state.password.length > 7) return true
    else return false
  }

  _isEmailValid(email) {
    const emailRegex = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
    return emailRegex.test(email)
  }

  _buildSubmitURI() {
    let queryString = window.location.search.slice(1)
    if(queryString === "") {
      queryString = "redirect_uri=https%3A%2F%2Faccounts.simpleauth.org%2F"
    }
    return "http://localhost:4000/oauth/authorize?" + queryString
  }

  render() {
    return (
      <Form header="Login to your account" error={this.state.error}>
        <Input 
          label="Email"
          type="email" 
          name="email"
          placeholder="example@example.com" 
          onChange={this.handleChange}
          value={this.state.email}
          required 
          />
        <Input 
          label="Password"
          type="password" 
          name="password"
          placeholder="minimum 8 characters long"
          onChange={this.handleChange}
          value={this.state.password}
          required
          />
        <Link id="forgot" to="/forgot-password">Forgot your password?</Link>
        <Button 
          onClick={this.handleSubmit} 
          text="Login"
          disabled={this.state.disabledButton}
          />
        <Link id="signup" to="/signup"><Button text="Sign up" /></Link>
        <Divider text="or"/>
      </Form>
    )
  }
}