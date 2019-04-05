import React from 'react'
import { Link } from 'react-router-dom'
import axios from 'axios'

import Form from '../components/Form'
import Input from '../components/Input'
import Button from '../components/Button'

export default class SignUp extends React.Component {
  constructor() {
    super()
    this.state = { 
      disabledButton: true,
      error: "", 
      email: "", 
      password: "",
      confirmPassword: "",
       
    }

    this.handleChange = this.handleChange.bind(this)
    this.handleSubmit = this.handleSubmit.bind(this)
  }

  handleChange(event) {
    if(this._isValid(event)) this.setState({ disabledButton: false, [event.target.name]: event.target.value })
    this.setState({ disabledButton: true, [event.target.name]: event.target.value })
    console.log(this.state)
  }

  handleSubmit() {
    
  }

  _isValid(event) {
    if(this._isPasswordConfirmed(event) && this._isEmailValid(this.state.email)) return true
    else if(this._isEmailValid(event.target.value) && this._isPasswordConfirmed(event)) return true
    else return false
  }

  _isEmailValid(email) {
    const emailRegex = new RegExp("^[a-z0-9\_\.\-]{2,20}\@[a-z0-9\_\-]{2,20}\.[a-z]{2,9}$")
    return emailRegex.test(email)
  }

  _isPasswordConfirmed(event) {
    if(event.target.value === this.state.password) return true
    else if(event.target.value === this.state.confirmPassword) return true
    else return false
  }

  render() {
    return (
      <Form header="Create a Free Account" error={this.state.error}>
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
        <Input 
          label="Confirm password"
          type="password" 
          name="confirmPassword" 
          onChange={this.handleChange} 
          value={this.state.confirmPassword} 
          />
        <Button 
          onClick={this.handleSubmit} 
          text="Sign up"
          disabled={this.state.disabledButton}
          />
        <Link to="/login">Already have an account</Link>
      </Form>
    )
  }
}