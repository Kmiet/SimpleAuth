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
    if(this._isValid(event)) this.setState({ disabledButton: false, error: "", [event.target.name]: event.target.value })
    else this.setState({ disabledButton: true, error: "Some error message", [event.target.name]: event.target.value })
    console.log(this.state)
  }

  handleSubmit() {
    
  }

  _isValid(event) {
    if(event.target.value && this._isEmailValid(this.state.email)) return true
    else if(this._isEmailValid(event.target.value) && this.state.password) return true
    else return false
  }

  _isEmailValid(email) {
    const emailRegex = new RegExp("^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)+$")
    return emailRegex.test(email)
  }

  render() {
    return (
      <Form header="Login to your account" error={this.state.error}>
        <Input 
          label="Email"
          type="email" 
          name="email" 
          onChange={this.handleChange}
          value={this.state.email} 
          />
        <Input 
          label="Password"
          type="password" 
          name="password" 
          onChange={this.handleChange} 
          value={this.state.password} 
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