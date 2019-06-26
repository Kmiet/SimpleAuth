import React from 'react'
import { Link } from 'react-router-dom'
import axios from 'axios'

import Form from '../components/Form'
import Input from '../components/Input'
import Button from '../components/Button'

export default class ForgotPasswordForm extends React.Component {
  constructor() {
    super()
    this.state = { 
      disabledButton: true,
      email: "",
      emailSent: false,
      csrf_token: document.CSRF_TOKEN
    }

    this.handleChange = this.handleChange.bind(this)
    this.handleSubmit = this.handleSubmit.bind(this)
  }

  handleChange(event) {
    if(this._isValid(event)){
      this.setState({ disabledButton: false, [event.target.name]: event.target.value })
    } else {
      this.setState({ disabledButton: true, [event.target.name]: event.target.value })
    }
    //this.setState({ disabledButton: true, [event.target.name]: event.target.value })
    console.log(this.state)
  }

  handleSubmit() {
    event.preventDefault();
    axios.post('http://localhost:4000/forgot-password/', {
      csrf_token: this.state.csrf_token,
      email: this.state.email
    }).then(response => {
      this.setState({ emailSent: true })
      console.log(response)
    }).catch(err => {
      console.log(err)
    })
  }

  _isValid(event) {
    return this._isEmailValid(event.target.value)
  }

  _isEmailValid(email) {
    const emailRegex = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
    return emailRegex.test(email)
  }

  render() {
    return (
      <Form header="Reset your password">
        <Input 
          label="Email"
          type="email" 
          name="email" 
          onChange={this.handleChange}
          value={this.state.email}
          required
          />
        <Button 
          onClick={this.handleSubmit} 
          text="Reset password"
          disabled={this.state.disabledButton}
          />
        <Link to="/login">Back to login</Link>
      </Form>
    )
  }
}